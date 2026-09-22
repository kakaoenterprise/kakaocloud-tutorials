# KakaoCloud 3-Tier 웹 아키텍처 (Terraform)

[VM 기반 웹 서비스 3-Tier 아키텍처 튜토리얼](https://docs.kakaocloud.com/tutorial/compute/vm-based-web)의 인프라를
공식 [`kakaoenterprise/kakaocloud`](https://registry.terraform.io/providers/kakaoenterprise/kakaocloud/latest/docs)
Terraform Provider로 배포하는 예제입니다.

## 아키텍처

```text
Internet
  └─ Web ALB (:80, Public IP)
       └─ Web VM 2대 (:80, Nginx/React)
            └─ App NLB (:8080, Private VIP)
                 └─ App VM 2대 (:8080, Spring Boot)
                      └─ Managed MySQL (:3306)
```

배스천 호스트는 별도의 Public IP를 가지며, `admin_cidr`에서만 SSH, Nginx Proxy Manager 관리 화면 및
SSH 포트 포워딩 범위에 접근할 수 있습니다.

| 구분 | 생성 리소스 |
|---|---|
| 네트워크 | VPC 1개, Internet Gateway, Public Route, Subnet 5개(`main`, `web`, `alb`, `app`, `mysql`) |
| 보안 | 배스천, Web, App, MySQL용 Security Group 4개 |
| 배스천 | Ubuntu 20.04 VM 1대, Public IP, Docker, Nginx Proxy Manager |
| Web 계층 | Nginx/React VM 2대, Public ALB |
| App 계층 | Spring Boot VM 2대, Internal NLB |
| 데이터베이스 | Managed MySQL Instance Group 1개(Primary 1대) |

## 사전 준비

- Terraform 1.11 이상
- KakaoCloud 프로젝트에 등록된 키페어
- KakaoCloud Application Credential

Application Credential은 파일에 작성하지 말고 환경 변수로 설정합니다.

```shell
export KAKAOCLOUD_APPLICATION_CREDENTIAL_ID="<application-credential-id>"
export KAKAOCLOUD_APPLICATION_CREDENTIAL_SECRET="<application-credential-secret>"
```

## 사용 방법

1. 변수 파일을 생성합니다.

   ```shell
   cp terraform.tfvars.example terraform.tfvars
   ```

2. `terraform.tfvars`에서 다음 필수 값을 수정합니다.

   ```hcl
   # 현재 접속 위치의 Public IP를 /32 CIDR로 지정합니다.
   admin_cidr = "203.0.113.10/32"

   # 충분히 강한 비밀번호로 변경합니다.
   mysql_database_user_password = "<mysql-password>"

   # 기본값(kr2-cloudtech)과 다른 키페어를 사용하면 지정합니다.
   keypair_name = "<registered-keypair-name>"
   ```

3. 구성을 초기화하고 배포합니다.

   ```shell
   terraform init
   terraform plan
   terraform apply
   ```

4. 배포 결과를 확인합니다.

   ```shell
   terraform output
   ```

주요 출력값은 다음과 같습니다.

| 출력값 | 설명 |
|---|---|
| `bastion_public_ip` | 배스천 호스트 Public IP |
| `nginx_proxy_manager_url` | Nginx Proxy Manager 관리 화면 |
| `web_load_balancer_public_ip` | 서비스 접속용 Web Load Balancer Public IP |
| `app_load_balancer_private_vip` | App Load Balancer Private VIP |
| `web_instance_private_ips` | Web VM Private IP 목록 |
| `app_instance_private_ips` | App VM Private IP 목록 |
| `mysql_endpoint` | Managed MySQL 접속 Endpoint |
| `keypair_name` | VM에 적용된 키페어 이름 |

## 배포 후 설정

Web/App VM의 cloud-init은 Docker를 설치하고 `kakaocloud-library` 브랜치의 애플리케이션을 자동으로
빌드·실행합니다. Private VM에 SSH로 접속하려면 다음 설정이 추가로 필요합니다.

1. `http://<bastion_public_ip>:81`에 접속합니다.
2. Nginx Proxy Manager 기본 계정 `admin@example.com` / `changeme`로 로그인한 직후 비밀번호를 변경합니다.
3. 각 Web/App VM의 Private IP와 22번 포트를 대상으로 `10000-10010` 범위 내 Stream을 생성합니다.
4. 생성한 포트로 접속합니다.

   ```shell
   ssh -p <forwarded-port> <user>@<bastion_public_ip>
   ```

## 주요 변수

기본 배포 리전은 `kr-central-2-a`, VPC CIDR은 `10.0.0.0/16`입니다. VM은 기본적으로 Ubuntu 20.04,
`m2a.large`, Root Volume 20GB를 사용합니다. 전체 입력값과 기본값은 [`variables.tf`](./variables.tf)와
[`terraform.tfvars.example`](./terraform.tfvars.example)에서 확인할 수 있습니다.

## 파일 구성

```text
versions.tf                 Provider 및 Terraform 버전
variables.tf                입력 변수
terraform.tfvars.example    변수 파일 예시
data.tf                     Image, Flavor, MySQL 데이터 조회
locals.tf                   조회 결과에서 사용할 ID 계산
network.tf                  VPC, IGW, Route, Subnet, Security Group
keypair.tf                  등록된 SSH 키페어 조회
bastion.tf                  배스천 VM, Public IP, Nginx Proxy Manager
web.tf                      Web 계층 VM
app.tf                      App 계층 VM
mysql.tf                    Managed MySQL Instance Group
lb_web.tf                   Public Web ALB 및 Public IP
lb_app.tf                   Internal App NLB
outputs.tf                  출력값
```

## 참고 및 주의사항

- 이 예제는 `kakaoenterprise/kakaocloud` Provider `0.5.x`를 사용합니다.
- 모든 리소스는 기본적으로 하나의 Availability Zone에 배포됩니다. 운영 환경에서는 Multi-AZ 구성과
  장애 복구 전략을 별도로 설계하세요.
- `terraform.tfvars`, State, Plan, Private Key 등 민감한 로컬 파일은 커밋하지 마세요.
- MySQL 비밀번호는 VM의 `user_data`와 Terraform State에 저장될 수 있습니다. State는 암호화된 원격
  Backend와 엄격한 접근 제어를 적용해 관리하는 것을 권장합니다.
- Security Group 규칙은 튜토리얼 실행을 위해 VPC 또는 관련 Subnet 범위를 허용합니다. 운영 환경에서는
  필요한 Source와 Port만 허용하도록 강화하세요.
- Managed MySQL이 `AVAILABLE` 상태가 된 직후 Endpoint가 아직 제공되지 않을 수 있어, 구성에서 2분 대기 후
  Endpoint를 다시 조회합니다. Endpoint가 비어 있으면 잠시 후 `terraform apply`를 다시 실행하세요.
- 실습을 마치면 과금 방지를 위해 리소스를 삭제합니다.

  ```shell
  terraform destroy
  ```

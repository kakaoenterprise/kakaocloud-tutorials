# KakaoCloud Tutorials

[카카오클라우드 기술문서](https://docs.kakaocloud.com/)의 튜토리얼과 서비스 가이드에서 사용하는 예제 코드입니다.
예제별로 브랜치가 나뉘어 있습니다. 원하는 예제를 선택하고, 연결된 문서의 절차와 다운로드 명령에 따라 실습하세요.

## 예제 목록

| 예제 | 브랜치 | 설명 | 관련 문서 |
|---|---|---|---|
| 카카오클라우드 라이브러리 | [kakaocloud-library](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/kakaocloud-library) | 도서 검색과 채팅 기능을 제공하는 웹 애플리케이션 | [VM 기반 웹 서비스](https://docs.kakaocloud.com/tutorial/compute/vm-based-web), [채팅 웹 서비스](https://docs.kakaocloud.com/tutorial/compute/chat-application), [Container Registry](https://docs.kakaocloud.com/tutorial/container/cr-basic), [GitOps](https://docs.kakaocloud.com/tutorial/dev-tools/gitops-pipeline) |
| Bastion 호스트 설치 | [bastion-host](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/bastion-host) | Nginx Proxy Manager를 이용한 SSH 포트 포워딩 환경 설치 | [VM 기반 웹 서비스](https://docs.kakaocloud.com/tutorial/compute/vm-based-web), [채팅 웹 서비스](https://docs.kakaocloud.com/tutorial/compute/chat-application), [MongoDB Replica Set](https://docs.kakaocloud.com/tutorial/compute/vm-mongodb-replicaset) |
| Jupyter Notebook | [jupyter-notebook](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/jupyter-notebook) | Python 라이브러리 실행과 GPU 인식을 확인하는 Notebook | [GPU에서 Jupyter Notebook 환경 구성](https://docs.kakaocloud.com/tutorial/compute/vm-jupyter-notebook-setting) |
| 쿠버네티스 모니터링 | [k8s-monitor](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/k8s-monitor) | Prometheus, Grafana 및 Slack 알림 설정 | [Kubernetes Engine 클러스터 모니터링](https://docs.kakaocloud.com/tutorial/observability/k8se-cluster-monitoring) |
| 쿠버네티스 GPU 모니터링 | [k8s-gpu-monitor](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/k8s-gpu-monitor) | GPU 모니터링을 위한 Prometheus 스택 설정 | [NVIDIA GPU 모니터링](https://docs.kakaocloud.com/tutorial/observability/nvidia-gpu-monitoring) |
| Kubernetes Engine 가이드 | [k8se-public-guides](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/k8se-public-guides) | 로드 밸런서, CSI, Ingress 및 NFS 구성 예제 | [예제별 사용 안내](https://github.com/kakaoenterprise/kakaocloud-tutorials/blob/k8se-public-guides/README.md) |

## 보관된 예제

아래 예제는 보관용으로 제공하며, 유지보수와 업데이트가 종료되었습니다.

| 예제 | 브랜치 | 보관 코드 |
|---|---|---|
| Terraform 3-tier 구성 | [terraform-3tier](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/terraform-3tier) | [원본 코드](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/archive/terraform-3tier-2026-10-08) |
| Terraform MongoDB Replica Set 구성 | [terraform-mongodb](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/terraform-mongodb) | [원본 코드](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/archive/terraform-mongodb-2026-10-08) |
| Ansible 인프라 구성 | [ansible-infra](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/ansible-infra) | [원본 코드](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/archive/ansible-infra-2026-10-08) |

`kakaocloud-terraform-3tier` 브랜치의 애플리케이션 예제는 [kakaocloud-library](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/kakaocloud-library)에서 제공합니다.
Kubernetes Engine의 이전 버전 예제는 [해당 브랜치의 안내](https://github.com/kakaoenterprise/kakaocloud-tutorials/blob/k8se-public-guides/README.md#이전-버전-예제)를 참고하세요.

# KakaoCloud Tutorials

이 프로젝트는 [카카오클라우드 기술문서](https://docs.kakaocloud.com/)에서 사용하는 예제 프로젝트 및 코드를 제공합니다.
예제별로 브랜치가 분리되어 있습니다. 아래 목록에서 연결 문서와 유지 상태를 확인하세요.

## 현행 예제

| 예제 | 브랜치 | 연결 문서 및 상태 |
|---|---|---|
| 카카오클라우드 라이브러리 | [kakaocloud-library](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/kakaocloud-library) | [VM 기반 웹 서비스](https://docs.kakaocloud.com/tutorial/compute/vm-based-web), [채팅 웹 서비스](https://docs.kakaocloud.com/tutorial/compute/chat-application), [Container Registry](https://docs.kakaocloud.com/tutorial/container/cr-basic), [GitOps](https://docs.kakaocloud.com/tutorial/dev-tools/gitops-pipeline)에서 사용. 유지 |
| Bastion 호스트 설치 | [bastion-host](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/bastion-host) | VM 웹 서비스, 채팅, [MongoDB Replica Set](https://docs.kakaocloud.com/tutorial/compute/vm-mongodb-replicaset) 문서에서 사용. 유지·갱신 대상 |
| Jupyter Notebook 실행 예제 | [jupyter-notebook](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/jupyter-notebook) | [GPU Jupyter Notebook](https://docs.kakaocloud.com/tutorial/compute/vm-jupyter-notebook-setting) 문서는 별도 kc-handson-config 저장소를 참조. 유지·문서 참조 통합 대상 |
| 쿠버네티스 모니터링 | [k8s-monitor](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/k8s-monitor) | [클러스터 모니터링](https://docs.kakaocloud.com/tutorial/observability/k8se-cluster-monitoring) 문서는 별도 kc-handson-config 저장소를 참조. 유지·문서 참조 통합 대상 |
| 쿠버네티스 GPU 모니터링 | [k8s-gpu-monitor](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/k8s-gpu-monitor) | [GPU 모니터링](https://docs.kakaocloud.com/tutorial/observability/nvidia-gpu-monitoring) 문서는 별도 kc-handson-config 저장소를 참조. 유지·버전 검증 및 문서 참조 통합 대상 |
| Kubernetes Engine 서비스 가이드 | [k8se-public-guides](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/k8se-public-guides) | LB, CSI, Ingress, NFS 가이드에서 사용. 유지하며 일부 구버전·중복 경로는 브랜치 README에 보관 표시 |

## 검증 대기 예제

| 예제 | 브랜치 | 검증 상태 |
|---|---|---|
| 공식 KakaoCloud Terraform Provider 기반 3-tier | [feat/terraform-3tier-example](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/feat/terraform-3tier-example) | 실제 배포·실행 검증 전. 공개 문서에서 직접 참조되지 않으며, 이전 Terraform 예제의 정식 대체로 안내하지 않음 |

## 보관된 예제

보관일: 2026-10-08. 보관 태그는 README에 상태 안내를 추가하기 전의 원본 커밋을 보존합니다.

| 브랜치 | 보관 이유 | 원본 코드 | 이후 안내 |
|---|---|---|---|
| [terraform-3tier](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/terraform-3tier) | 공개 문서의 직접 참조를 확인하지 못한 이전 3-tier 자동화 예제. 과거 앱 저장소·구성에 의존 | [보관 태그](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/archive/terraform-3tier-2026-10-08) | 유지보수 종료. 새 Terraform 예제는 검증 전 |
| [terraform-mongodb](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/terraform-mongodb) | 현재 수동 구성 문서와 OS·설치 버전이 다른 이전 MongoDB 자동화 예제 | [보관 태그](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/archive/terraform-mongodb-2026-10-08) | 유지보수 종료. 현재 문서는 위 MongoDB Replica Set 튜토리얼 참고 |
| [ansible-infra](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/ansible-infra) | 공개 문서의 직접 참조를 확인하지 못했으며 필수 변수 파일이 누락된 이전 자동화 예제 | [보관 태그](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/archive/ansible-infra-2026-10-08) | 유지보수 종료. 검증된 대체 자동화 예제 없음 |
| [kakaocloud-terraform-3tier](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/kakaocloud-terraform-3tier) | 보관 시점에 kakaocloud-library와 동일한 커밋이며 Terraform 코드가 없는 중복 브랜치 | [보관 태그](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/archive/kakaocloud-terraform-3tier-2026-10-08) | 현행 앱 예제는 kakaocloud-library에서 제공 |

k8se-public-guides의 구버전·중복 파일 보관 범위는 [해당 README](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/k8se-public-guides#보관된-구버전중복-경로)를 참고하세요.
공공 환경 예제는 공개 문서 연결을 확인하지 못한 상태로 표시하며, 공공 문서 확인 전 삭제·이동 및 유지보수 종료 확정을 유보합니다.

## 보관 정책과 검증 범위

- 브랜치 이름과 파일 경로는 기존 GitHub 및 다운로드 링크의 호환성을 위해 유지합니다.
- 유지보수 종료로 표시한 예제·경로에는 신규 기능이나 버전 갱신을 진행하지 않습니다. 재개하려면 현재 문서와 실행 환경을 검증하고 상태 안내를 갱신합니다.
- 문서의 직접 참조를 찾지 못했다는 것은 해당 문서의 폐기나 모든 외부 링크의 부재를 의미하지 않습니다.
- 이 목록은 2026-10-08 기준 공개 사이트맵 1,264개 페이지와 원격 브랜치 12개를 대조한 결과입니다. 별도 [kc-handson-config](https://github.com/kakaoenterprise/kc-handson-config) 저장소를 참조하는 문서도 포함합니다.
- 실제 Docker 실행 및 클라우드 배포는 검증하지 않았습니다. 현행 목록은 실행 성공이나 최신 버전 호환성을 보장하지 않습니다.

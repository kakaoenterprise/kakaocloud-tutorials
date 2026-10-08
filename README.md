# Kubernetes Engine 가이드 예제

카카오클라우드 Kubernetes Engine에서 로드 밸런서와 스토리지, Ingress를 구성하는 예제입니다.
각 가이드에서 안내하는 설정값을 적용한 뒤 예제를 사용하세요.

## 예제 목록

| 구성 | 예제 파일 | 사용 안내 |
|---|---|---|
| 로드 밸런서(기존 방식) | [createLB/lb-nginx.yml](./createLB/lb-nginx.yml) | [이전 버전 가이드](https://docs.kakaocloud.com/service/container-pack/k8se/how-to-guides/k8se-create-delete-lb-deprecated) |
| 블록 스토리지 CSI | [dynamicPV/cinder-csi.yaml](./dynamicPV/cinder-csi.yaml) | [블록 스토리지 CSI Provisioner 설정](https://docs.kakaocloud.com/service/container-pack/k8se/how-to-guides/k8se-csi) |
| Ingress 컨트롤러 | [controller-v1.12.1/deploy.yaml](./controller-v1.12.1/deploy.yaml) | [인그레스 컨트롤러 배포](https://docs.kakaocloud.com/service/container-pack/k8se/how-to-guides/k8se-ingress) |
| NFS Client Provisioner | [NFSclientprovisioner/nfs-subdir-external-provisioner.yml](./NFSclientprovisioner/nfs-subdir-external-provisioner.yml) | [NFS Client Provisioner 설정](https://docs.kakaocloud.com/service/container-pack/k8se/how-to-guides/k8se-nfs) |

새 방식으로 로드 밸런서를 구성하려면 [로드 밸런서 생성 및 제어](https://docs.kakaocloud.com/service/container-pack/k8se/how-to-guides/k8se-create-delete-lb-recommended) 가이드를 참고하세요.
`createLB/lb-nginx.yml`은 기존 annotation 방식의 예제이며, 이 방식은 2026년 12월 31일 지원 종료 예정입니다.

## 이전 버전 예제

아래 경로는 이전 버전의 코드 참고용으로 보관하며, 유지보수와 업데이트가 종료되었습니다.

| 경로 | 내용 |
|---|---|
| [controller-v1.0.5/](./controller-v1.0.5/) | Ingress NGINX 1.0.5 설정 |
| [controller-v1.3.1/](./controller-v1.3.1/) | Ingress NGINX 1.3.1 설정 |
| [ingress-nginx/](./ingress-nginx/) | 이전 Ingress 컨트롤러 설정 |
| [settingIC/](./settingIC/) | 이전 Ingress 컨트롤러 및 로드 밸런서 설정 |
| [guide-samples/](./guide-samples/) | 이전 서비스 가이드 예제 모음 |

[보관 코드 보기](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/archive/k8se-public-guides-2026-10-08)

## 공공 환경 예제

[gov-guide-samples/](./gov-guide-samples/)에는 공공 환경용 예제가 포함되어 있습니다.
해당 환경의 서비스 가이드와 설정값을 기준으로 사용하세요.

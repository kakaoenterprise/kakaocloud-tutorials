# Kubernetes Engine 가이드 예제

[카카오클라우드 기술문서](https://docs.kakaocloud.com/)의 Kubernetes Engine 서비스 가이드에서 사용하는 예제입니다.
이 브랜치는 계속 유지하며, 아래 구버전·중복 경로만 보관 대상으로 표시합니다.

## 현재 공개 문서에서 사용하는 파일

| 파일 | 연결 문서 |
|---|---|
| [createLB/lb-nginx.yml](./createLB/lb-nginx.yml) | [로드 밸런서 생성 및 삭제](https://docs.kakaocloud.com/service/container-pack/k8se/how-to-guides/k8se-create-delete-lb) |
| [dynamicPV/cinder-csi.yaml](./dynamicPV/cinder-csi.yaml) | [블록 스토리지 CSI Provisioner 설정](https://docs.kakaocloud.com/service/container-pack/k8se/how-to-guides/k8se-csi) |
| [controller-v1.12.1/deploy.yaml](./controller-v1.12.1/deploy.yaml) | [인그레스 컨트롤러 배포](https://docs.kakaocloud.com/service/container-pack/k8se/how-to-guides/k8se-ingress) |
| [NFSclientprovisioner/nfs-subdir-external-provisioner.yml](./NFSclientprovisioner/nfs-subdir-external-provisioner.yml) | [NFS Client Provisioner 설정](https://docs.kakaocloud.com/service/container-pack/k8se/how-to-guides/k8se-nfs) |

위 목록은 공개 문서의 참조를 확인한 결과이며, 현재 환경에서의 실행 검증이나 최신 버전 권장을 의미하지 않습니다.

## 보관된 구버전·중복 경로

보관일: 2026-10-08

변경 전 원본: [archive/k8se-public-guides-2026-10-08](https://github.com/kakaoenterprise/kakaocloud-tutorials/tree/archive/k8se-public-guides-2026-10-08)

| 경로 | 보관 이유 및 상태 |
|---|---|
| [controller-v1.0.5/](./controller-v1.0.5/) | 구버전 Ingress 예제. 유지보수 종료 |
| [controller-v1.3.1/](./controller-v1.3.1/) | 구버전 Ingress 예제. 유지보수 종료 |
| [ingress-nginx/](./ingress-nginx/) | 구버전 Ingress 예제의 중복 경로. 유지보수 종료 |
| [settingIC/](./settingIC/) | 구버전 Ingress 예제 및 관련 설정의 중복 경로. 유지보수 종료 |
| [guide-samples/](./guide-samples/) | 루트 예제와 중복된 사본. 유지보수 종료 |
| [gov-guide-samples/](./gov-guide-samples/) | 공공 환경 예제로 보관 표시. 이번 공개 문서 검토에서 연결을 확인하지 못했으며, 공공 문서 확인 전 삭제·이동 및 유지보수 종료 확정은 유보 |

보관 경로는 이력 참조용으로 유지하며, 현재 환경에서의 실행은 검증되지 않았습니다.
기존 다운로드 링크를 유지하기 위해 파일을 삭제하거나 이동하지 않습니다. 그 밖의 미참조 파일은 이번 검토만으로 보관 또는 폐기를 확정하지 않습니다.

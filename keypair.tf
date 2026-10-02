####################################
# SSH 키페어
#
# 카카오클라우드에 이미 등록된 키페어를 조회해 인스턴스에 사용합니다.
# 기본값은 kr2-cloudtech 입니다.
####################################

data "kakaocloud_keypair" "this" {
  name = var.keypair_name
}

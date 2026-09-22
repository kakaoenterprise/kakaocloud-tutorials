####################################
# 배스천 호스트
#
# 프라이빗 웹/앱 서브넷으로 들어가는 SSH 게이트웨이이며,
# Nginx Proxy Manager(NPM) 웹 UI(http://<배스천-퍼블릭IP>:81)에서
# TCP 스트림 포워딩 규칙을 설정할 수 있게 합니다.
####################################

locals {
  # cloud-init이 스크립트로 인식하려면 shebang이 첫 글자여야 함 (앞에 공백 금지)
  bastion_user_data = <<-EOT
#!/bin/bash
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive
# 부팅 직후 DNS가 비어 있을 수 있어, 이름 조회가 될 때까지 대기한다.
dns_ok=0
for i in $(seq 1 30); do
  if getent hosts archive.ubuntu.com >/dev/null 2>&1 || getent hosts kr-central-2-a.clouds.archive.ubuntu.com >/dev/null 2>&1; then
    echo "DNS 준비 완료 ($i/30)"
    dns_ok=1
    break
  fi
  echo "DNS 대기 중 ($i/30)..."
  sleep 10
done
if [ "$dns_ok" != "1" ]; then
  echo "DNS 대기 시간 초과"
  exit 1
fi
apt-get update -y
apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

mkdir -p /opt/npm/data /opt/npm/letsencrypt
docker run -d \
  --name nginx-proxy-manager \
  --restart unless-stopped \
  -p 81:81 \
  -p 10000-10010:10000-10010 \
  -v /opt/npm/data:/data \
  -v /opt/npm/letsencrypt:/etc/letsencrypt \
  jc21/nginx-proxy-manager:latest
EOT
}

resource "kakaocloud_instance" "bastion" {
  name      = "${var.project_name}-bastion"
  image_id  = local.image_id
  flavor_id = local.flavor_id
  key_name  = data.kakaocloud_keypair.this.name

  subnets = [
    { id = kakaocloud_subnet.main.id }
  ]

  initial_security_groups = [
    { name = kakaocloud_security_group.bastion.name }
  ]

  volumes = [
    { size = var.root_volume_size }
  ]

  # 카카오클라우드 Create instance API는 user_data를 Base64 문자열로 요구함
  user_data = base64encode(trimspace(local.bastion_user_data))
}

resource "kakaocloud_public_ip" "bastion" {
  description = "${var.project_name}-bastion public IP"

  related_resource = {
    device_id   = kakaocloud_instance.bastion.id
    device_type = "instance"
    id          = kakaocloud_instance.bastion.addresses[0].network_interface_id
  }

  # 퍼블릭 IP 연결은 VPC에 IGW가 붙은 뒤에만 가능하다.
  depends_on = [kakaocloud_internet_gateway_attachment.this]
}

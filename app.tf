####################################
# 애플리케이션 계층 (Spring Boot 백엔드)
####################################

locals {
  # cloud-init이 스크립트로 인식하려면 shebang이 첫 글자여야 함 (앞에 공백 금지)
  app_user_data = <<-EOT
#!/bin/bash
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive
# 프라이빗 서브넷은 부팅 직후 DNS가 비어 있을 수 있어, 이름 조회가 될 때까지 대기한다.
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
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin git

git clone -b kakaocloud-library https://github.com/kakaoenterprise/kakaocloud-tutorials /opt/kakaocloud-tutorials
cd /opt/kakaocloud-tutorials

docker run -d \
  --name kakaocloud-library-server \
  --restart unless-stopped \
  -e MYSQL_HOST=${local.mysql_host} \
  -e DB_USERNAME=${var.mysql_database_user_name} \
  -e DB_PASSWORD=${var.mysql_database_user_password} \
  -p 8080:8080 \
  $(docker build -q -f ./server/deploy/Dockerfile ./server)
EOT
}

resource "kakaocloud_instance" "app" {
  count = var.app_instance_count

  name      = "${var.project_name}-app-${count.index + 1}"
  image_id  = local.image_id
  flavor_id = local.flavor_id
  key_name  = data.kakaocloud_keypair.this.name

  subnets = [
    { id = kakaocloud_subnet.app.id }
  ]

  initial_security_groups = [
    { name = kakaocloud_security_group.app.name }
  ]

  volumes = [
    { size = var.root_volume_size }
  ]

  # 카카오클라우드 Create instance API는 user_data를 Base64 문자열로 요구함
  user_data = base64encode(trimspace(local.app_user_data))

  depends_on = [terraform_data.mysql_endpoint_ready]
}

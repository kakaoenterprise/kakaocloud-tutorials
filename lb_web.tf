####################################
# Web load balancer (public, L7/ALB)
# Publicly reachable entry point for the whole application.
####################################

resource "kakaocloud_load_balancer" "web" {
  name              = "${var.project_name}-web-lb"
  flavor_id         = local.alb_flavor_id
  availability_zone = var.availability_zone
  subnet_id         = kakaocloud_subnet.main.id
  description       = "Public ALB in front of the web tier"
}

resource "kakaocloud_load_balancer_listener" "web" {
  load_balancer_id = kakaocloud_load_balancer.web.id
  protocol         = "HTTP"
  protocol_port    = 80
}

resource "kakaocloud_load_balancer_target_group" "web" {
  name                    = "${var.project_name}-web-target-group"
  load_balancer_id        = kakaocloud_load_balancer.web.id
  protocol                = "HTTP"
  load_balancer_algorithm = "ROUND_ROBIN"
  listener_id             = kakaocloud_load_balancer_listener.web.id
}

resource "kakaocloud_load_balancer_health_monitor" "web" {
  type             = "HTTP"
  delay            = 10
  timeout          = 5
  max_retries      = 3
  max_retries_down = 3
  http_method      = "GET"
  http_version     = "1.1"
  url_path         = "/"
  expected_codes   = "200"
  target_group_id  = kakaocloud_load_balancer_target_group.web.id
}

resource "kakaocloud_load_balancer_target_group_member" "web" {
  count = var.web_instance_count

  name            = "${var.project_name}-web-${count.index + 1}"
  target_group_id = kakaocloud_load_balancer_target_group.web.id
  address         = kakaocloud_instance.web[count.index].addresses[0].private_ip
  protocol_port   = 80
  subnet_id       = kakaocloud_subnet.web.id
  weight          = 1
}

resource "kakaocloud_public_ip" "web_lb" {
  description = "${var.project_name}-web-lb public IP"

  related_resource = {
    device_id   = kakaocloud_load_balancer.web.id
    device_type = "load-balancer"
  }

  # 퍼블릭 IP 연결은 VPC에 IGW가 붙은 뒤에만 가능하다.
  depends_on = [kakaocloud_internet_gateway_attachment.this]
}

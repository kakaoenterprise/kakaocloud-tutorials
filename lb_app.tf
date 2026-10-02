####################################
# Application load balancer (internal, L4/NLB)
# Sits between the web tier and the application tier.
####################################

resource "kakaocloud_load_balancer" "app" {
  name              = "${var.project_name}-app-lb"
  flavor_id         = local.nlb_flavor_id
  availability_zone = var.availability_zone
  subnet_id         = kakaocloud_subnet.alb.id
  description       = "Internal NLB in front of the application tier"
}

resource "kakaocloud_load_balancer_listener" "app" {
  load_balancer_id = kakaocloud_load_balancer.app.id
  protocol         = "TCP"
  protocol_port    = 8080
}

# NLB 리스너 생성 직후 target group을 바로 만들면 백엔드가 아직 완전히
# 준비되지 않아 CreateTargetGroup 자체는 성공하지만 그 뒤 상태 폴링에서
# 404가 반복되다 실패하는 경우가 있었다. 짧게 대기한 뒤 생성을 시도하고,
# timeouts.create를 넉넉히 잡아 폴링이 너무 빨리 포기하지 않도록 한다.
resource "time_sleep" "wait_app_lb_listener" {
  depends_on      = [kakaocloud_load_balancer_listener.app]
  create_duration = "60s"
}

resource "kakaocloud_load_balancer_target_group" "app" {
  name                    = "${var.project_name}-app-target-group"
  load_balancer_id        = kakaocloud_load_balancer.app.id
  protocol                = "TCP"
  load_balancer_algorithm = "ROUND_ROBIN"
  listener_id             = kakaocloud_load_balancer_listener.app.id

  timeouts = {
    create = "10m"
  }

  depends_on = [time_sleep.wait_app_lb_listener]
}

resource "kakaocloud_load_balancer_health_monitor" "app" {
  type             = "TCP"
  delay            = 10
  timeout          = 5
  max_retries      = 3
  max_retries_down = 3
  target_group_id  = kakaocloud_load_balancer_target_group.app.id
}

resource "kakaocloud_load_balancer_target_group_member" "app" {
  count = var.app_instance_count

  name            = "${var.project_name}-app-${count.index + 1}"
  target_group_id = kakaocloud_load_balancer_target_group.app.id
  address         = kakaocloud_instance.app[count.index].addresses[0].private_ip
  protocol_port   = 8080
  subnet_id       = kakaocloud_subnet.app.id
  weight          = 1
}

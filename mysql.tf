####################################
# Managed MySQL (single instance, matching the tutorial's "Primary only"
# availability setting)
####################################

resource "kakaocloud_mysql_instance_group" "this" {
  name        = "${var.project_name}-mysql"
  description = "MySQL instance group for the 3-tier tutorial"

  parameter_group = {
    type = "DEFAULT"
    id   = local.mysql_parameter_group_id
  }

  spec_content = {
    engine_version         = local.mysql_engine_version
    flavor_id              = local.mysql_flavor_id
    data_disk_size         = var.mysql_data_disk_size
    log_disk_size          = var.mysql_log_disk_size
    database_user_name     = var.mysql_database_user_name
    database_user_password = var.mysql_database_user_password
    primary_port           = var.mysql_primary_port
  }

  desired_network_info = {
    primary_subnet_info = {
      replicas  = 1
      subnet_id = kakaocloud_subnet.mysql.id
    }
    security_group_ids = [kakaocloud_security_group.mysql.id]
  }

  backup_schedule = {
    enabled = false
  }
}

# 인스턴스 그룹이 AVAILABLE이어도 endpoint는 조금 뒤에 채워질 수 있다.
# 생성 직후 한 번 대기한 다음 data source로 다시 읽어 엔드포인트가 있는지 검수한다.
resource "time_sleep" "wait_mysql_endpoint" {
  depends_on      = [kakaocloud_mysql_instance_group.this]
  create_duration = "2m"
}

data "kakaocloud_mysql_instance_group" "ready" {
  id = kakaocloud_mysql_instance_group.this.id

  depends_on = [time_sleep.wait_mysql_endpoint]
}

locals {
  mysql_host = try(data.kakaocloud_mysql_instance_group.ready.endpoint[0], "")
}

# 엔드포인트가 비어 있으면 앱 VM user_data를 만들지 않고 여기서 멈춘다.
resource "terraform_data" "mysql_endpoint_ready" {
  input = local.mysql_host

  lifecycle {
    precondition {
      condition     = length(data.kakaocloud_mysql_instance_group.ready.endpoint) > 0
      error_message = "MySQL 엔드포인트가 아직 비어 있습니다. 콘솔에서 엔드포인트가 생긴 뒤 terraform apply를 다시 실행하세요."
    }
  }
}

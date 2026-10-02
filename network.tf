####################################
# VPC
####################################

resource "kakaocloud_vpc" "this" {
  name       = var.project_name
  cidr_block = var.vpc_cidr
}

# Decoupled VPC는 IGW가 자동으로 붙지 않으므로 생성 후 VPC에 연결한다.
# https://registry.terraform.io/providers/kakaoenterprise/kakaocloud/latest/docs/resources/internet_gateway_attachment
resource "kakaocloud_internet_gateway" "this" {
  name = "${var.project_name}-igw"
}

resource "kakaocloud_internet_gateway_attachment" "this" {
  internet_gateway_id = kakaocloud_internet_gateway.this.id
  vpc_id              = kakaocloud_vpc.this.id
}

# IGW 연결 후에 기본 경로를 등록한다.
resource "kakaocloud_route_table" "public" {
  name   = "${var.project_name}-public-rt"
  vpc_id = kakaocloud_vpc.this.id

  request_routes = [
    {
      destination = "0.0.0.0/0"
      target_id   = kakaocloud_internet_gateway.this.id
      target_type = "igw"
    }
  ]

  depends_on = [kakaocloud_internet_gateway_attachment.this]
}

####################################
# Subnets (one per tier, matching the tutorial's layout)
####################################

resource "kakaocloud_subnet" "main" {
  vpc_id            = kakaocloud_vpc.this.id
  name              = "${var.project_name}-main"
  cidr_block        = var.subnet_main_cidr
  availability_zone = var.availability_zone
  route_table_id    = kakaocloud_route_table.public.id
}

resource "kakaocloud_subnet" "web" {
  vpc_id            = kakaocloud_vpc.this.id
  name              = "${var.project_name}-web"
  cidr_block        = var.subnet_web_cidr
  availability_zone = var.availability_zone
  route_table_id    = kakaocloud_route_table.public.id
}

resource "kakaocloud_subnet" "alb" {
  vpc_id            = kakaocloud_vpc.this.id
  name              = "${var.project_name}-alb"
  cidr_block        = var.subnet_alb_cidr
  availability_zone = var.availability_zone
  route_table_id    = kakaocloud_route_table.public.id
}

resource "kakaocloud_subnet" "app" {
  vpc_id            = kakaocloud_vpc.this.id
  name              = "${var.project_name}-app"
  cidr_block        = var.subnet_app_cidr
  availability_zone = var.availability_zone
  route_table_id    = kakaocloud_route_table.public.id
}

resource "kakaocloud_subnet" "mysql" {
  vpc_id            = kakaocloud_vpc.this.id
  name              = "${var.project_name}-mysql"
  cidr_block        = var.subnet_mysql_cidr
  availability_zone = var.availability_zone
  route_table_id    = kakaocloud_route_table.public.id
}

####################################
# Security groups
####################################

# Bastion: SSH from the admin CIDR, plus the Nginx Proxy Manager admin UI (81)
# and the SSH port-forwarding range (10000-10010) used to reach the private tiers.
resource "kakaocloud_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Bastion host security group"

  rules = [
    {
      direction        = "ingress"
      description      = "SSH from admin CIDR"
      protocol         = "TCP"
      port_range_min   = 22
      port_range_max   = 22
      remote_ip_prefix = var.admin_cidr
    },
    {
      direction        = "ingress"
      description      = "Nginx Proxy Manager admin UI"
      protocol         = "TCP"
      port_range_min   = 81
      port_range_max   = 81
      remote_ip_prefix = var.admin_cidr
    },
    {
      direction        = "ingress"
      description      = "SSH port-forward range (10000-10010)"
      protocol         = "TCP"
      port_range_min   = 10000
      port_range_max   = 10010
      remote_ip_prefix = var.admin_cidr
    },
    {
      direction        = "egress"
      description      = "Allow all outbound"
      protocol         = "ALL"
      remote_ip_prefix = "0.0.0.0/0"
    }
  ]
}

# Web tier: HTTP from the web load balancer (deployed in the main subnet),
# plus SSH from the bastion subnet for management.
resource "kakaocloud_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Web tier security group"

  rules = [
    {
      direction        = "ingress"
      description      = "HTTP from web ALB / health checks"
      protocol         = "TCP"
      port_range_min   = 80
      port_range_max   = 80
      remote_ip_prefix = var.vpc_cidr
    },
    {
      direction        = "ingress"
      description      = "SSH from bastion subnet"
      protocol         = "TCP"
      port_range_min   = 22
      port_range_max   = 22
      remote_ip_prefix = var.subnet_main_cidr
    },
    {
      direction        = "egress"
      description      = "Allow all outbound"
      protocol         = "ALL"
      remote_ip_prefix = "0.0.0.0/0"
    }
  ]
}

# Application tier: 8080 from the application load balancer, plus SSH from bastion.
resource "kakaocloud_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Application tier security group"

  rules = [
    {
      direction        = "ingress"
      description      = "8080 from app NLB / health checks"
      protocol         = "TCP"
      port_range_min   = 8080
      port_range_max   = 8080
      remote_ip_prefix = var.vpc_cidr
    },
    {
      direction        = "ingress"
      description      = "SSH from bastion subnet"
      protocol         = "TCP"
      port_range_min   = 22
      port_range_max   = 22
      remote_ip_prefix = var.subnet_main_cidr
    },
    {
      direction        = "egress"
      description      = "Allow all outbound"
      protocol         = "ALL"
      remote_ip_prefix = "0.0.0.0/0"
    }
  ]
}

# MySQL tier: 3306 from anywhere inside the VPC.
resource "kakaocloud_security_group" "mysql" {
  name        = "${var.project_name}-mysql-sg"
  description = "MySQL tier security group"

  rules = [
    {
      direction        = "ingress"
      description      = "MySQL from within the VPC"
      protocol         = "TCP"
      port_range_min   = 3306
      port_range_max   = 3306
      remote_ip_prefix = var.vpc_cidr
    },
    {
      direction        = "egress"
      description      = "Allow all outbound"
      protocol         = "ALL"
      remote_ip_prefix = "0.0.0.0/0"
    }
  ]
}

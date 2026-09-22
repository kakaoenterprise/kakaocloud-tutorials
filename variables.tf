####################################
# Provider credentials (optional)
####################################

variable "application_credential_id" {
  description = "KakaoCloud application credential ID. Prefer the KAKAOCLOUD_APPLICATION_CREDENTIAL_ID env var instead."
  type        = string
  default     = ""
  sensitive   = true
}

variable "application_credential_secret" {
  description = "KakaoCloud application credential secret. Prefer the KAKAOCLOUD_APPLICATION_CREDENTIAL_SECRET env var instead."
  type        = string
  default     = ""
  sensitive   = true
}

####################################
# General
####################################

variable "project_name" {
  description = "Prefix applied to every resource name created by this module (matches the 'tutorial' prefix used in the KakaoCloud 3-tier tutorial)."
  type        = string
  default     = "tutorial"
}

variable "availability_zone" {
  description = "KakaoCloud availability zone to deploy into."
  type        = string
  default     = "kr-central-2-a"
}

variable "admin_cidr" {
  description = "CIDR block (typically your-public-ip/32) allowed to reach the bastion host over SSH (22), the Nginx Proxy Manager admin UI (81) and the SSH port-forwarding range (10000-10010)."
  type        = string
}

####################################
# Networking
####################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_main_cidr" {
  description = "CIDR block for the 'main' subnet (bastion host + web load balancer)."
  type        = string
  default     = "10.0.0.0/20"
}

variable "subnet_web_cidr" {
  description = "CIDR block for the web tier subnet."
  type        = string
  default     = "10.0.16.0/20"
}

variable "subnet_alb_cidr" {
  description = "CIDR block for the application load balancer subnet."
  type        = string
  default     = "10.0.32.0/20"
}

variable "subnet_app_cidr" {
  description = "CIDR block for the application tier subnet."
  type        = string
  default     = "10.0.48.0/20"
}

variable "subnet_mysql_cidr" {
  description = "CIDR block for the MySQL subnet."
  type        = string
  default     = "10.0.64.0/20"
}

####################################
# Compute
####################################

variable "image_name" {
  description = "Name of the KakaoCloud image used for every VM instance (bastion, web, app)."
  type        = string
  default     = "Ubuntu 20.04"
}

variable "instance_flavor_name" {
  description = "Name of the KakaoCloud instance flavor used for every VM instance."
  type        = string
  default     = "m2a.large"
}

variable "root_volume_size" {
  description = "Root volume size (GB) for every VM instance."
  type        = number
  default     = 20
}

variable "web_instance_count" {
  description = "Number of web tier (Nginx) instances."
  type        = number
  default     = 2
}

variable "app_instance_count" {
  description = "Number of application tier (Spring Boot) instances."
  type        = number
  default     = 2
}

####################################
# SSH 키페어
####################################

variable "keypair_name" {
  description = "카카오클라우드에 이미 등록된 키페어 이름. 인스턴스 SSH 접속에 사용합니다."
  type        = string
  default     = "kr2-cloudtech"
}

####################################
# MySQL
####################################

variable "mysql_engine_version" {
  description = "MySQL engine version to look up via the kakaocloud_mysql_engine_versions data source. Leave empty to use the first version returned by KakaoCloud."
  type        = string
  default     = ""
}

variable "mysql_flavor_name" {
  description = "Name of the MySQL instance flavor."
  type        = string
  default     = "m2a.large"
}

variable "mysql_database_user_name" {
  description = "Initial MySQL administrator user name."
  type        = string
  default     = "admin"
}

variable "mysql_database_user_password" {
  description = "Initial MySQL administrator password. Must be supplied - there is no default."
  type        = string
  sensitive   = true
}

variable "mysql_data_disk_size" {
  description = "MySQL data disk size (GB)."
  type        = number
  default     = 100
}

variable "mysql_log_disk_size" {
  description = "MySQL log disk size (GB)."
  type        = number
  default     = 100
}

variable "mysql_primary_port" {
  description = "MySQL primary instance port."
  type        = number
  default     = 3306
}

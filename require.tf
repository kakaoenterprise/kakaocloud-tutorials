terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.40.0"
    }
  }
}

variable "kc_region" {}
variable "kc_availability_zone" {}
variable "kc_auth_url" {}
variable "kc_application_credential_id" {}
variable "kc_application_credential_secret" {}

# provider 설정
provider "openstack" {
  auth_url    = var.kc_auth_url
  application_credential_id = var.kc_application_credential_id
  application_credential_secret = var.kc_application_credential_secret
  region      = var.kc_region
}

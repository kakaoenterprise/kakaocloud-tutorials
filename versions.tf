terraform {
  # Provider 0.5.x uses write-only attributes (for example, user_data and
  # database_user_password), which require Terraform 1.11 or later.
  required_version = ">= 1.11.0"

  required_providers {
    kakaocloud = {
      source  = "kakaoenterprise/kakaocloud"
      version = "~> 0.5"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }
}

# Authentication is read from the environment by default:
#   export KAKAOCLOUD_APPLICATION_CREDENTIAL_ID="..."
#   export KAKAOCLOUD_APPLICATION_CREDENTIAL_SECRET="..."
#
# You can instead uncomment the block below and set the variables in
# terraform.tfvars (NOT recommended for anything other than local testing,
# since it risks committing secrets to version control).
provider "kakaocloud" {
  application_credential_id     = var.application_credential_id
  application_credential_secret = var.application_credential_secret
}

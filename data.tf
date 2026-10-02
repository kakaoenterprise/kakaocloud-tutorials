####################################
# Compute image / flavor lookups
####################################

data "kakaocloud_images" "vm" {
  filter = [
    {
      name  = "instance_type"
      value = "vm"
    },
    {
      name  = "name"
      value = var.image_name
    }
  ]
}

data "kakaocloud_instance_flavors" "vm" {
  filter = [
    {
      name  = "instance_type"
      value = "vm"
    },
    {
      name  = "name"
      value = var.instance_flavor_name
    }
  ]
}

####################################
# Load balancer flavor lookups
####################################

data "kakaocloud_load_balancer_flavors" "all" {}

####################################
# MySQL lookups
####################################

data "kakaocloud_mysql_flavors" "all" {
  show_all = true
}

data "kakaocloud_mysql_engine_versions" "all" {}

data "kakaocloud_mysql_default_parameter_groups" "all" {}

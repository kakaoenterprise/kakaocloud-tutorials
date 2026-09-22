locals {
  image_id  = data.kakaocloud_images.vm.images[0].id
  flavor_id = data.kakaocloud_instance_flavors.vm.instance_flavors[0].id

  alb_flavor_id = one([
    for f in data.kakaocloud_load_balancer_flavors.all.flavors : f.id if upper(f.name) == "ALB"
  ])
  nlb_flavor_id = one([
    for f in data.kakaocloud_load_balancer_flavors.all.flavors : f.id if upper(f.name) == "NLB"
  ])

  mysql_flavor_id = one([
    for f in data.kakaocloud_mysql_flavors.all.flavors : f.id if f.name == var.mysql_flavor_name
  ])

  mysql_engine_version = var.mysql_engine_version != "" ? var.mysql_engine_version : data.kakaocloud_mysql_engine_versions.all.engine_versions[0].engine_version

  mysql_parameter_group_id = one([
    for g in data.kakaocloud_mysql_default_parameter_groups.all.default_parameter_groups : g.id
    if g.engine_version == local.mysql_engine_version
  ])
}

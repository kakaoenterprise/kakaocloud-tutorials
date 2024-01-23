data "openstack_images_image_v2" default_image {
  name = var.default_image
  visibility = "public"
  #most_recent = true
}

# Key

data "openstack_compute_keypair_v2" "sshkey" {
  name = var.sshkey
}

data "template_file" "web_env" {
  template = file("./templates/web-env.sh")
  vars = {
    APP_ENDPOINT = "http://${openstack_lb_loadbalancer_v2.app_lb.vip_address}:8080"
  }
}

data "template_file" "bastion_init" {
  template = file("./scripts/bastion-init.sh")
  vars = {
    web1 = element(openstack_networking_port_v2.web_port.*.all_fixed_ips.0, 0)
    web2 = element(openstack_networking_port_v2.web_port.*.all_fixed_ips.0, 1)
    app1 = element(openstack_networking_port_v2.app_port.*.all_fixed_ips.0, 0)
    app2 = element(openstack_networking_port_v2.app_port.*.all_fixed_ips.0, 1)
  }
}
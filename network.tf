data "openstack_networking_network_v2" "public_network" {
  matching_subnet_cidr = data.openstack_networking_subnet_v2.public_subnet.cidr
}

data "openstack_networking_subnet_v2" "public_subnet" {
  cidr = var.public_network_cidr
}

data "openstack_networking_network_v2" "floating_network" {
  external = true
}

resource "openstack_networking_port_v2" "bastion_port" {
  name = "${var.prefix}-${var.bastion_instance_name}"
  network_id = data.openstack_networking_network_v2.public_network.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.bastion_sg.id]
}

resource "openstack_networking_floatingip_associate_v2" "bastion_fip_associate" {
  floating_ip = openstack_networking_floatingip_v2.bastion_fip.address
  port_id     = openstack_networking_port_v2.bastion_port.id
}

resource "openstack_networking_floatingip_v2" "bastion_fip" {
  pool = data.openstack_networking_network_v2.floating_network.name
  port_id = openstack_networking_port_v2.bastion_port.id
}

resource "openstack_networking_port_v2" "web_port" {
  count = length(var.web_nodes)
  name = "${var.prefix}-${var.web_nodes[count.index]}"
  network_id = data.openstack_networking_network_v2.public_network.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.web_sg.id]
}

resource "openstack_networking_port_v2" "app_port" {
  count = length(var.app_nodes)
  name = "${var.prefix}-${var.app_nodes[count.index]}"
  network_id = data.openstack_networking_network_v2.public_network.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.app_sg.id]
}

resource "openstack_networking_floatingip_associate_v2" "web_fip_associate" {
  floating_ip = openstack_networking_floatingip_v2.web_fip.address
  port_id     = openstack_lb_loadbalancer_v2.web_lb.vip_port_id
}


resource "openstack_networking_floatingip_v2" "web_fip" {
  pool = data.openstack_networking_network_v2.floating_network.name
  port_id = openstack_lb_loadbalancer_v2.web_lb.vip_port_id
}

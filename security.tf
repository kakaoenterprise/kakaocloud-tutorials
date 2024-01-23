resource "openstack_networking_secgroup_v2" "bastion_sg" {
  name = "${var.prefix}-bastion-sg"
  description = "security group for ${var.prefix}-${var.bastion_instance_name}"
}

resource "openstack_networking_secgroup_rule_v2" "bastion-ssh-sg-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.bastion_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion-mgmt-sg-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 81
  port_range_max    = 81
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.bastion_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion-tunnel-sg-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10000
  port_range_max    = 10100
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.bastion_sg.id
}

resource "openstack_networking_secgroup_v2" "web_sg" {
  name = "${var.prefix}-web-sg"
  description = "security group for ${var.prefix}-webs"
}

resource "openstack_networking_secgroup_rule_v2" "web-sg-ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = data.openstack_networking_subnet_v2.public_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.web_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "web-sg-public" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = data.openstack_networking_subnet_v2.public_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.web_sg.id
}

resource "openstack_networking_secgroup_v2" "app_sg" {
  name = "${var.prefix}-app-sg"
  description = "security group for ${var.prefix}-apps"
}

resource "openstack_networking_secgroup_rule_v2" "app-sg-ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = data.openstack_networking_subnet_v2.public_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.app_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "app-sg-public" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = data.openstack_networking_subnet_v2.public_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.app_sg.id
}
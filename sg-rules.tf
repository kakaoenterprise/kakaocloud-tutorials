resource "openstack_networking_secgroup_rule_v2" "mongodb-node-ssh-sg-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = data.openstack_networking_subnet_v2.public_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.mongodb_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "mongodb-node-using-sg-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 27017
  port_range_max    = 27017
  remote_ip_prefix  = data.openstack_networking_subnet_v2.public_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.mongodb_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "mongodb-node-ping-sg-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  port_range_min    = "0"
  port_range_max    = "0"
  remote_ip_prefix  = data.openstack_networking_subnet_v2.public_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.mongodb_sg.id
}

###### user_data ######

data "template_file" "init_replicaset" {
  template = file("./templates/init-replicaset.sh")
  vars = {
    replicaset_name = var.replicaset_name
    node1 = "node1.rs.in"
    node2 = "node2.rs.in"
    node3 = "node3.rs.in"
  }
}


data "template_file" "install_mongodb" {
  template = file("./templates/install-mongodb.sh")
  vars = {
    mongod_config_file = data.template_file.mongod_config_file.rendered
    local_dns_file = data.template_file.local_dns_file.rendered
  }
}

data "template_file" "mongod_config_file" {
  template = file("./templates/mongod.conf")
  vars = {
    replicaset_name = var.replicaset_name
  }
}

data "template_file" "local_dns_file" {
  template = file("./templates/hosts")
  vars = {
    primary = element(openstack_networking_port_v2.mongodb_port.*.all_fixed_ips.0, 0)
    secondary1 = element(openstack_networking_port_v2.mongodb_port.*.all_fixed_ips.0, 1)
    secondary2 = element(openstack_networking_port_v2.mongodb_port.*.all_fixed_ips.0, 2)
  }
}

resource "openstack_compute_instance_v2" "mongodb_node" {
  count = length(var.mongodb_name)
  name = "${var.prefix}-${var.mongodb_name[count.index]}"
  image_name = data.openstack_images_image_v2.default_image.name
  flavor_name = var.mongodb_flavor
  key_pair = data.openstack_compute_keypair_v2.sshkey.id

  user_data = <<EOF
#cloud-config
write_files:
- content: |
    ${indent(4, file("./files/attach-volume.sh"))}
  path: "/tmp/attach_volume.sh"
  owner: root:root
  permissions: '0755'

- content: |
    ${indent(4, data.template_file.install_mongodb.rendered)}
  path: "/tmp/install-mongodb.sh"
  owner: root:root
  permissions: '0755'

- content: |
    ${indent(4, data.template_file.init_replicaset.rendered)}
  path: "/tmp/init-replicaset.sh"
  owner: root:root
  permissions: '0755'

runcmd:
- [bash, /tmp/attach_volume.sh]
- [bash, /tmp/install-mongodb.sh]
- [bash, /tmp/init-replicaset.sh, ${count.index % 3}]
EOF

  block_device {
    uuid = data.openstack_images_image_v2.default_image.id
    source_type = "image"
    destination_type = "volume"
    volume_size = 20
    boot_index = 0
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.mongodb_port[count.index].id
  }

}

resource "openstack_compute_volume_attach_v2" "mongodb_storage_attach" {
  count = length(var.mongodb_name)
  volume_id = openstack_blockstorage_volume_v3.mongodb_storage[count.index].id
  instance_id = openstack_compute_instance_v2.mongodb_node[count.index].id
  device = "/dev/vdb"
}

resource "openstack_blockstorage_volume_v3" "mongodb_storage" {
  availability_zone = var.kc_availability_zone
  count = length(var.mongodb_name)
  name = "${var.prefix}-${var.mongodb_name[count.index]}-data-volume"
  size = var.mongodb_data_volume_size
}

###### port ######

resource "openstack_networking_port_v2" "mongodb_port" {
  count = length(var.mongodb_name)
  name = "${var.prefix}-${var.mongodb_name[count.index]}"
  network_id = data.openstack_networking_network_v2.public_network.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.mongodb_sg.id]
}

###### security-group ######

resource "openstack_networking_secgroup_v2" "mongodb_sg" {
  name = "${var.prefix}-mongodb-sg"
  description = "security group for ${var.prefix}-mongodb"
}

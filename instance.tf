resource "openstack_compute_instance_v2" "bastion_instance" {
  name = "${var.prefix}-${var.bastion_instance_name}"
  flavor_name = var.bastion_flavor
  key_pair = data.openstack_compute_keypair_v2.sshkey.id
  user_data = <<EOF
#cloud-config
write_files:
- content: |
    ${indent(4, data.template_file.bastion_init.rendered)}
  path: "/tmp/bastion-init.sh"
  owner: root:root
  permissions: '0755'
runcmd:
- [bash, /tmp/bastion-init.sh]
EOF

  block_device {
    uuid                  = data.openstack_images_image_v2.default_image.id
    source_type           = "image"
    volume_size           = 50
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.bastion_port.id
  }

}


resource "openstack_compute_instance_v2" "web_instance" {
  count = length(var.web_nodes)

  name = "${var.prefix}-${var.web_nodes[count.index]}"
  flavor_name = var.web_flavor
  key_pair = data.openstack_compute_keypair_v2.sshkey.id
  user_data = <<EOF
#cloud-config
write_files:
- content: |
    ${indent(4, file("./scripts/web-init.sh"))}
  path: "/tmp/web-init.sh"
  owner: root:root
  permissions: '0755'
- content: |
    ${indent(4, data.template_file.web_env.rendered)}
  path: "/tmp/web-env.sh"
  owner: root:root
  permissions: '0755'
runcmd:
- [bash, /tmp/web-init.sh]
EOF

  block_device {
    uuid                  = data.openstack_images_image_v2.default_image.id
    source_type           = "image"
    volume_size           = 50
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.web_port[count.index].id
  }

}


resource "openstack_compute_instance_v2" "app_instance" {
  count = length(var.app_nodes)

  name = "${var.prefix}-${var.app_nodes[count.index]}"
  flavor_name = var.app_flavor
  key_pair = data.openstack_compute_keypair_v2.sshkey.id
  user_data = <<EOF
#cloud-config
write_files:
- content: |
    ${indent(4, file("./scripts/app-init.sh"))}
  path: "/tmp/app-init.sh"
  owner: root:root
  permissions: '0755'
- content: |
    ${indent(4, file("./templates/app-env.sh"))}
  path: "/tmp/app-env.sh"
  owner: root:root
  permissions: '0755'
runcmd:
- [bash, /tmp/app-init.sh]
EOF

  block_device {
    uuid                  = data.openstack_images_image_v2.default_image.id
    source_type           = "image"
    volume_size           = 50
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.app_port[count.index].id
  }

}
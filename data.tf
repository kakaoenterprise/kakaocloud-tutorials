data "openstack_images_image_v2" default_image {
  name = var.default_image
  most_recent = true
}

# Network

data "openstack_networking_network_v2" "public_network" {
  matching_subnet_cidr = data.openstack_networking_subnet_v2.public_subnet.cidr
}

data "openstack_networking_subnet_v2" "public_subnet" {
  cidr = var.public_network_cidr
}

data "openstack_networking_network_v2" "floating_network" {
  external = true
}

# Key

data "openstack_compute_keypair_v2" "sshkey" {
  name = var.sshkey
}
# network

variable public_network_cidr {
  type    = string
  default = "${PUBLIC_NETWORK_CIDR}"
}

# key
variable "sshkey" {
  type = string
  default = "${USER_SSH_KEY_NAME}"
}

# default

variable default_image {
  type    = string
  default = "Ubuntu 20.04 - 5.4.0-164"
}

variable "prefix" {
  type = string
  default = "handson"
}

#

variable "replicaset_name" {
  type = string
  default = "hands-on-mongodb-replicaset"
}

# mongodb_var

variable "mongodb_name" {
  type = list(string)
  default = ["mongodb-1","mongodb-2","mongodb-3"]
}

variable mongodb_flavor {
  type    = string
  default = "m2a.xlarge"
  description = "4 vcpu, 16gb ram"
}

variable "mongodb_data_volume_size" {
  type = number
  default = 500
  description = "number 500 = 500GB"
}

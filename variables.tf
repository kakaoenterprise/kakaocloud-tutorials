# network

variable "public_network_cidr" {
  type = string
  default = ""
}

# key

variable "sshkey" {
  type = string
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

# bastion-var

variable bastion_instance_name {
  type    = string
  default = "bastion"
}

variable bastion_flavor {
  type    = string
  default = "m2a.large"
  description = "2 vcpu, 8gb ram"
}

# web-var

variable web_instance_name {
  type    = string
  default = "web"
}

variable "web_nodes" {
  type    = list(string)
  default = ["web-1", "web-2"]
}

variable web_flavor {
  type    = string
  default = "m2a.large"
  description = "2 vcpu, 8gb ram"
}

# app-var

variable app_instance_name {
  type    = string
  default = "app"
}

variable "app_nodes" {
  type    = list(string)
  default = ["app-1", "app-2"]
}

variable app_flavor {
  type        = string
  default     = "m2a.xlarge"
  description = "2 vcpu, 8gb ram"
}


variable kc_availability_zone {
  type    = string
  default = "kr-central-2-a"
}

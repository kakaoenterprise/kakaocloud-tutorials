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
  default = "Ubuntu 20.04"
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
  default = "a1-2-co"
  description = "2 vcpu, 4gb ram"
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
  default = "a1-2-co"
  description = "2 vcpu, 4gb ram"
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
  default     = "a1-4-co"
  description = "4 vcpu, 8gb ram"
}

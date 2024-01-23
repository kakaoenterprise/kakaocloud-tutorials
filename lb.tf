##### app lb

resource "openstack_lb_loadbalancer_v2" "app_lb" {
    name = "${var.prefix}-${var.app_instance_name}-lb"
    vip_network_id = data.openstack_networking_network_v2.public_network.id
    flavor_id = "94beb0cb-dc05-44d4-9ae0-e9785141a33e"
    availability_zone = var.kc_availability_zone
}

resource "openstack_lb_pool_v2" "app_lb_pool" {
    name = "${var.prefix}-apps"
    lb_method = "ROUND_ROBIN"
    protocol = "TCP"
    loadbalancer_id = openstack_lb_loadbalancer_v2.app_lb.id
}

resource "openstack_lb_member_v2" "app_lb_member" {
    count = length(openstack_networking_port_v2.app_port.*.all_fixed_ips.0)
    name = var.app_nodes[count.index]
    address = element(openstack_networking_port_v2.app_port.*.all_fixed_ips.0, count.index)
    pool_id = openstack_lb_pool_v2.app_lb_pool.id
    protocol_port = 8080
    subnet_id = data.openstack_networking_subnet_v2.public_subnet.id
}

resource "openstack_lb_monitor_v2" "app_lb_monitor" {
    pool_id = openstack_lb_pool_v2.app_lb_pool.id
    name = "${var.prefix}-app-monitor"
    type = "TCP"
    delay = 10
    max_retries = 3
    timeout = 5
}

resource "openstack_lb_listener_v2" "app_lb_listener" {
    default_pool_id = openstack_lb_pool_v2.app_lb_pool.id
    loadbalancer_id = openstack_lb_loadbalancer_v2.app_lb.id
    protocol        = "TCP"
    protocol_port   = 8080
}

####### web lb

resource "openstack_lb_loadbalancer_v2" "web_lb" {
    name = "${var.prefix}-${var.web_instance_name}-lb"
    vip_network_id = data.openstack_networking_network_v2.public_network.id
    flavor_id = "687c7076-7756-4906-9630-dd51abd6f1e7"
    availability_zone = var.kc_availability_zone
}

resource "openstack_lb_pool_v2" "web_lb_pool" {
    name = "${var.prefix}-webs"
    lb_method = "ROUND_ROBIN"
    protocol = "HTTP"
    loadbalancer_id = openstack_lb_loadbalancer_v2.web_lb.id
}

resource "openstack_lb_member_v2" "web_lb_member" {
    count = length(openstack_networking_port_v2.web_port.*.all_fixed_ips.0)
    name = var.web_nodes[count.index]
    address = element(openstack_networking_port_v2.web_port.*.all_fixed_ips.0, count.index)
    pool_id = openstack_lb_pool_v2.web_lb_pool.id
    protocol_port = 80
    subnet_id = data.openstack_networking_subnet_v2.public_subnet.id
}

resource "openstack_lb_monitor_v2" "web_lb_monitor" {
    pool_id = openstack_lb_pool_v2.web_lb_pool.id
    name = "${var.prefix}-web-monitor"
    type = "HTTP"
    delay = 10
    max_retries = 3
    timeout = 5
    url_path = "/"
}

resource "openstack_lb_listener_v2" "web_lb_listener" {
    default_pool_id = openstack_lb_pool_v2.web_lb_pool.id
    loadbalancer_id = openstack_lb_loadbalancer_v2.web_lb.id
    protocol        = "HTTP"
    protocol_port   = 80
}

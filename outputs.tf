output "bastion_public_ip" {
  description = "Public IP of the bastion host. SSH here first, then use SSH port-forwarding (via the Nginx Proxy Manager UI on port 81) to reach the web/app tiers."
  value       = kakaocloud_public_ip.bastion.public_ip
}

output "nginx_proxy_manager_url" {
  description = "URL of the Nginx Proxy Manager admin UI running on the bastion (default login: admin@example.com / changeme - change it immediately)."
  value       = "http://${kakaocloud_public_ip.bastion.public_ip}:81"
}

output "web_load_balancer_public_ip" {
  description = "Public IP of the web load balancer - the entry point for the application."
  value       = kakaocloud_public_ip.web_lb.public_ip
}

output "app_load_balancer_private_vip" {
  description = "Private VIP of the internal application load balancer."
  value       = kakaocloud_load_balancer.app.private_vip
}

output "web_instance_private_ips" {
  description = "Private IPs of the web tier instances."
  value       = [for i in kakaocloud_instance.web : i.addresses[0].private_ip]
}

output "app_instance_private_ips" {
  description = "Private IPs of the application tier instances."
  value       = [for i in kakaocloud_instance.app : i.addresses[0].private_ip]
}

output "mysql_endpoint" {
  description = "Connection endpoint(s) for the managed MySQL instance group."
  value       = data.kakaocloud_mysql_instance_group.ready.endpoint
}

output "keypair_name" {
  description = "인스턴스에 적용한 카카오클라우드 키페어 이름."
  value       = data.kakaocloud_keypair.this.name
}

output "ClusterODM_internal_ip" {
  value = digitalocean_droplet.webodm.*.ipv4_address_private
}
output "NodeODM_internal_ip" {
  value = digitalocean_droplet.nodeodm.*.ipv4_address_private
}
output "WebODM" {
  value = digitalocean_droplet.webodm.*.ipv4_address 
}
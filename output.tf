output "ClusterODM_internal_ip" {
  value = droplet.webodm.private_ip
}
output "NodeODM_internal_ip" {
  value = droplet.nodeodm.*.public_ip
}
output "WebODM" {
  value = droplet.webodm.public_ip
}
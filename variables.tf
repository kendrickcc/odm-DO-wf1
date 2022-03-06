variable "prefix_name" {
  description = "The prefix name to use with resources"
  default     = "odm"
}
variable "pvt_key" {
  default = "~/.ssh/id_rsa_webodm.pem"
}
variable "pub_key" {
  default = "id_rsa_webodm"
}
variable "pub_key_loc" {
  default = "~/.ssh/id_rsa_webodm.pub"
}
variable "region" {
  default = "myc3"
}
variable "webodm_count" {
  description = "Number of WebODM consoles"
  default     = 1
}
variable "webodm_os" {
  description = "Image OS for the WebODM droplet"
  default     = "ubuntu-18-04-x64"
}
variable "webodm_size" {
  description = "The server size"
  default     = "s-1vcpu-1gb"
}
variable "webodm_cidr" {
  default = "192.168.10.0/24"
}
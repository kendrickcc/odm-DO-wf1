variable "prefix_name" {
  description = "The prefix name to use with resources"
  default     = "odm"
}
variable "pub_key" {
  default = "id_rsa_webodm"
}
variable "pub_key_data" {
  description = "The contents of the public key are stored in GitHub as a secret"
}
variable "region" {
  default = "nyc3"
}
variable "webodm_cidr" {
  default = "192.168.1.0/24"
}
variable "nodeodm_count" {
  description = "Number of WebODM consoles"
  default     = 1
}
variable "webodm_os" {
  description = "Image OS for the WebODM droplet"
  default     = "ubuntu-18-04-x64"
}
variable "webodm_size" {
  description = "The server size"
  default     = "s-4vcpu-8gb"
}
variable "nodeodm_os" {
  description = "Image OS for the nodeODM droplet"
  default     = "ubuntu-18-04-x64"
}
variable "nodeodm_size" {
  description = "The server size"
  default     = "s-4vcpu-8gb"
}
/*
Slug                 Memory    VCPUs    Disk    Price Monthly    Price Hourly
s-1vcpu-1gb          1024      1        25      5.00             0.007440
s-1vcpu-1gb-amd      1024      1        25      6.00             0.008930
s-1vcpu-1gb-intel    1024      1        25      6.00             0.008930
s-1vcpu-2gb          2048      1        50      10.00            0.014880
s-1vcpu-2gb-amd      2048      1        50      12.00            0.017860
s-1vcpu-2gb-intel    2048      1        50      12.00            0.017860
s-2vcpu-2gb          2048      2        60      15.00            0.022320
s-2vcpu-2gb-amd      2048      2        60      18.00            0.026790
s-2vcpu-2gb-intel    2048      2        60      18.00            0.026790
s-2vcpu-4gb          4096      2        80      20.00            0.029760
s-2vcpu-4gb-amd      4096      2        80      24.00            0.035710
s-2vcpu-4gb-intel    4096      2        80      24.00            0.035710
s-4vcpu-8gb          8192      4        160     40.00            0.059520
c-2                  4096      2        25      40.00            0.059520
g-2vcpu-8gb          8192      2        25      60.00            0.089290
gd-2vcpu-8gb         8192      2        50      65.00            0.096730
m-2vcpu-16gb         16384     2        50      80.00            0.119050
c-4                  8192      4        50      80.00            0.119050
*/
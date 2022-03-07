#-------------------------------
# DigitalOcean Provider
#-------------------------------
provider "digitalocean" {}
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  #/* Begin comment block - only need to remove the leading "#" if need to test locally
  backend "s3" {
    key                         = "terraform.tfstate"
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    region                      = "us-east-1"
  }
  # End of S3 backend comment block */
}
#-------------------------------
# Get SSH key from DigitalOcean
#-------------------------------
data "digitalocean_ssh_key" "terraform" {
  name = var.pub_key
}
#-------------------------------
# Get cloud-init template file
#-------------------------------
data "template_file" "user_data" {
  template = file("odmSetup.tpl")
  vars = {
    ssh_key = var.id_rsa_webodm
  }
}
#-------------------------------
# Create new project and add resources
#-------------------------------
resource "digitalocean_project" "odm" {
  name        = "OpenDroneMap"
  description = "OpenDroneMap"
  purpose     = "Web Application"
  environment = "Development"
}
resource "digitalocean_project_resources" "odm" {
  project = digitalocean_project.odm.id
  resources = concat(
    digitalocean_droplet.odm.*.urn
  )
}
#-------------------------------
# VPC
#-------------------------------
resource "digitalocean_vpc" "odm" {
  name     = "${var.prefix_name}-vpc"
  region   = var.region
  ip_range = var.webodm_cidr
}
#-------------------------------
# Firewall
#-------------------------------
resource "digitalocean_firewall" "odm" {
  name        = "ODM_22-8000"
  droplet_ids = digitalocean_droplet.odm.*.id
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8000"
    source_addresses = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
#-------------------------------
# Droplets
#-------------------------------
resource "digitalocean_droplet" "odm" {
  count     = var.webodm_count
  image     = var.webodm_os
  name      = "${var.prefix_name}-(${count.index}+1)"
  region    = var.region
  size      = var.webodm_size
  vpc_uuid  = digitalocean_vpc.odm.id
  user_data = data.template_file.user_data.rendered
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}
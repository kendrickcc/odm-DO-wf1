#-------------------------------
# DigitalOcean Provider
#-------------------------------
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
provider "digitalocean" {}
#-------------------------------
# S3 Remote State
# Comment out this section if testing locally and do not want to use the S3 bucket
# Remove the leading # to disable the backend
#-------------------------------
#/* Begin comment block - only need to remove the leading "#"
terraform {
  backend "s3" {
    key                         = "terraform.tfstate"
    bucket                      = "20220226tfstate"
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    region                      = "us-east-1"
  }
}
#-------------------------------
# End of S3 Remote State comment block */
#-------------------------------
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
  template = file("odmSetup.yaml")
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
  project   = digitalocean_project.odm.id
  resources = concat(
    digitalocean_droplet.odm.*.urn
    )
}
#-------------------------------
# Create droplets
#-------------------------------
resource "digitalocean_droplet" "odm" {
  count  = 2
  image  = "ubuntu-18-04-x64"
  name   = "odm-${count.index}"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  #user_data = data.template_file.user_data.rendered
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}
#-------------------------------
# Security
#-------------------------------
resource "digitalocean_firewall" "odm" {
  name = "only-22-8000"

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
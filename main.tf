terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}
provider "digitalocean" {}
data "digitalocean_ssh_key" "terraform" {
  name = var.pub_key
}
data "http" "icanhazip" {
  url = "http://icanhazip.com"
}
data "template_file" "user_data" {
  template = file("../cloud-init/odmSetup.yaml")
}
resource "digitalocean_droplet" "odm" {
  count  = 1
  image  = "ubuntu-18-04-x64"
  name   = "odm-${count.index}"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
  user_data = data.template_file.user_data.rendered
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

/*
  provisioner "remote-exec" {
    inline = ["sudo apt-get update", 
      "sudo apt-get upgrade -y", 
      "sudo apt-get autoremove -y", 
      "echo Done!"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.pvt_key)
      host        = self.ipv4_address
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user root --inventory '${self.ipv4_address}', --private-key ${var.pvt_key} --extra-vars 'pub_key=${var.pub_key_loc}' odm-install.yml"
  }
*/
}
resource "digitalocean_firewall" "odm" {
  name = "only-22-8000"

  droplet_ids = digitalocean_droplet.odm.*.id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["${chomp(data.http.icanhazip.body)}/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8000"
    source_addresses = ["${chomp(data.http.icanhazip.body)}/32"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}
output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.odm :
    droplet.name => droplet.ipv4_address
  }
}

# odm-DO-wf1
OpenDroneMap in DigitalOcean using Terraform and cloud-init

## Setup

Add from the Marketplace [GitHub Action for DigitalOcean - doctl](https://github.com/marketplace/actions/github-action-for-digitalocean-doctl)

### Create backend store for Terraform state file

https://yoolanoo.com/terraform-remote-state-with-digitalocean/
https://www.digitalocean.com/community/tutorials/how-to-protect-sensitive-data-in-terraform

https://20220226tfstate.nyc3.digitaloceanspaces.com

Create Spaces access keys and enter them into GitHub
SPACES_ACCESS_KEY_ID 6B72OLWXN4EDA2YQ7SHD
SPACES_SECRET_ACCESS_KEY Ebu8+n887OfvtOsFIT6rS5ZilH4WzN0QRlkc4mvvUAY

https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs
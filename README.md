# odm-DO-wf1
OpenDroneMap in DigitalOcean using Terraform and cloud-init

## Setup

Add from the Marketplace [GitHub Action for DigitalOcean - doctl](https://github.com/marketplace/actions/github-action-for-digitalocean-doctl)

### Create backend store for Terraform state file

https://yoolanoo.com/terraform-remote-state-with-digitalocean/
https://www.digitalocean.com/community/tutorials/how-to-protect-sensitive-data-in-terraform

https://20220226tfstate.nyc3.digitaloceanspaces.com

Create Spaces access keys and enter them into GitHub
SPACES_ACCESS_KEY_ID 
SPACES_SECRET_ACCESS_KEY 

https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs
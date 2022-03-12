# OpenDroneMap WebODM in DigitalOcean using Terraform, cloud-init, and GitHub Actions

A project that will create OpenDroneMap server(s) using Terraform to build, cloud-init to configure and GitHub actions to manage the builds. No need to install Terraform locally, or any other CLI. It is advantageous to have some of the tools installed for faster testing, but is not required. This will create a new project in DigitalOcean to better manage the resources. Cloud-init is used to configure the server(s).

The intent is to build, process data, download results, then destroy the environment. GitHub actions are used to build and destroy.

## Setup

- Create a personal access token. Critical. Keep this token secure; do not upload into the repository. The key value will be entered into GitHub as a secret. Refer to this guide (https://docs.digitalocean.com/reference/api/create-personal-access-token/)

- Create backend store for Terraform state file. Create a basic Spaces bucket to store the Terraform state file. The Spaces name will be the `bucket` value used for the backend. Once created, navigate to the API menu and create a Spaces key. Similar to the personal access token, protect this information. The key ID and secret will be entered into GitHub as secrets. I also recorded the bucket name as a secret into GitHub. Perhaps overkill...

- SSH keys: Generate new and separate SSH keys for this environment. Suggest renaming the private key to have a `.pem` extension. Upload the public key to DigitalOcean. The key name will need to match what is entered into the `variables.tf` file.

- GitHub Secrets: In the repository, navigate to Settings, then under Security, select `secrets`. Create new secrets for the following:

	- DIGITALOCEAN_ACCESS_TOKEN (Set to personal access token)
	- S3_BUCKET (The Spaces space created)
	- SPACES_ACCESS_KEY_ID (Spaces access key created under the API menu)
	- SPACES_SECRET_ACCESS_KEY (Spaces secret key created under the API menu)
	- ID_RSA_WEBODM (Contents of public SSH key)

## Configuration

- variables.tf - Review this file to adjust the parameters of the build. Here you can adjust the SSH key name, number of servers to build, the region, etc...
- webODM.tf - Pay special attention to the endpoint URL under the `backend` section. Edit to match where the Spaces space is created.

## Execution

Once the secrets are entered, and the variables modified, then Actions may be used to build. Navigate to Actions at the top of the repository.

### Plan

- A - Terraform Plan: The first step to test the build files. This is important to run and get a successful run before moving onto Apply. If it fails, expand the workflow to view where it is failing.

### Apply

- B - Terraform Apply: If a successful plan, then the apply workflow will build the server(s). Once complete, expand the workflow to view the results if needed. The output phase will show the public IP address of the server.

### Output

- C - Terraform Output: A simple workflow to just report the IP addresses.

### Destroy

- X - Terraform Destroy: Will remove all resources associate with this build.

***Note***: The `destroy` workflow has a cron entry to destroy everynight at midnight. This is prevent resources from being provisioned for long periods of time. Maybe forgetting to destroy after a job, or could not access consoles, etc.. Simply a measure to keep costs down.

## OpenDroneMap

After 5 minutes, WebODM, ClusterODM and nodeODM nodes should be ready to acesss. Open the `B - Terraform Apply` action, and select `Terraform Apply` until you see `Terraform Output`. Expand this section and you should see IP addresses for the nodes. A public IP address for WebODM, then private IP addresses for ClusterODM and any nodes. 

- [public ip]:8000 WebODM
- [public ip]:8001 ClusterODM (Yes, this is changed from the default port of 10000)

Open a browser to the ClusterODM port and add in the nodes using the private IP address. Use port 3001 for the node that is on the WebODM/ClusterODM server, then port 3000 for the other nodes.

Then open port 8000 to access the WebODM portal, and add the ClusterODM using the private IP address and port 8080.

## Troubleshooting

Sometimes the `terraform.tfstate` file that is stored in Spaces can get out of sync. For example, the Destroy action is not used to remove resources as they were removed in the DigitalOcean interface. The state file will still have a record of the resource. Just delete the `terraform.tfstate` file under the Spaces space. 

If wanting to test builds locally instead of checking in and running actions, install Terraform, then comment out the backend section. This will then start to create a `terraform.tfstate` file locally. Terraform init, plan, and apply functions will all work. You may need to add an environment variable for the DigitalOcean access token.
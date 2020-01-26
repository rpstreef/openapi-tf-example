# openapi-tf-example

# Security vulnerability notice

The vulnerability is found in one of the dev-dependencies used to automate deployment and terraform scripts.

There are no known run-time vulnerabilities.

# Get started

## The essentials

- Download Terraform v0.12.x [here](https://www.terraform.io/downloads.html)
- You will need Node v12.x from [here](https://nodejs.org/en/download/)
- Git, to clone this Repo, from [here](https://git-scm.com/downloads)
- Create a free AWS account (requires credit card) [here](https://aws.amazon.com/)
- Finally, download the [AWS CLI tool](https://aws.amazon.com/cli/) 
- Setup your AWS local profile, see [this](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) guide how it's done.

## To get the API running
If you meet all the pre-requisites, do the following

- In your AWS development account create the S3 bucket for your Terraform state files.
  - Optionally, encrypt the S3 bucket and enable versioning such that you can do a rollback.
- ```git clone``` the repo
- Change your AWS credentials profile name in these files: 
  - ```./env/dev/remote-backend.tf```
  - ```./env/dev/dev.tfvars```
- Run ``` npm install ``` and then execute ``` npm run dev-init ```, this will:
  - Initialize the Terraform project for the 'dev' environment, and synchronize the state with the cloud stored .tfstate file.
  - If you run it a second time, it will fail on the workspace creation, this is not an issue (the workspace already exists)
- Run ```npm run dev-full``` to package the source code (locally) and to prepare the deployment to your AWS account.
  - Confirm with ```yes``` to deploy, anything else will cancel the deployment

See my full guide on dev.to for more information about this project


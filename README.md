# OpenAPI with AWS API Gateway, Lambda, Cognito, SNS and CloudWatch logs

This repo only deploys the infrastructure via Terraform. The source code, [this](https://github.com/rpstreef/openapi-node-example) repo, will be deployed automatically via AWS CodePipeline. By default, it's configured to automatically deploy at every push to the master branch.

Check the companion articles series '_OpenAPI_' on [dev.to](https://dev.to/rolfstreefkerk/openapi-with-terraform-on-aws-api-gateway-17je).

# Get started

## The essentials

- Download Terraform v0.12.x [here](https://www.terraform.io/downloads.html)
- You will need Node v12.x from [here](https://nodejs.org/en/download/)
- Git, to clone this Repo, from [here](https://git-scm.com/downloads)
- Create a free AWS account (requires credit card) [here](https://aws.amazon.com/)
- Finally, download the [AWS CLI tool](https://aws.amazon.com/cli/) 
- Setup your AWS local profile, see [this](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) guide how it's done.
- Manually setup an AWS S3 Bucket for Terraform state storage.

## To get the API running
If you meet all the pre-requisites, do the following

- In your AWS development account create the S3 bucket for your Terraform state files.
  - Optionally, encrypt the S3 bucket and enable versioning such that you can do a rollback.
- ```git clone``` this repo.
- Change your AWS credentials profile name in these files: 
  - ```./env/dev/remote-backend.tf```
  - ```./env/dev/dev.tfvars```
- Run ``` npm install ``` and then execute ``` npm run dev-init ```, this will:
  - Initialize the Terraform project for the 'dev' environment, and synchronize the state with the cloud stored .tfstate file.
  - If you run it a second time, it will fail on the workspace creation, this is not an issue (the workspace already exists)
- Run ```npm run dev-infra``` to prepare the deployment to your AWS account.
  - Note: this [repo](https://github.com/rpstreef/openapi-node-example) contains the node source code that the CodePipeline will deploy to the AWS Lambda and Lambda-layer.
  - Confirm with ```yes``` to deploy, anything else will cancel the deployment

See my full guide on dev.to for more information about this project

ps. I'm aware the gulp file doesn't exit nicely, i'm not an expert. Any pull requests or issue reports with pointers is definitely appreciated.

## VS Code plugins used

- [StandardJS](https://marketplace.visualstudio.com/items?itemName=chenxsan.vscode-standardjs)
- [Terraform](https://marketplace.visualstudio.com/items?itemName=mauve.terraform)
- [OpenAPI Editor](https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi)
- [OpenAPI Designer](https://marketplace.visualstudio.com/items?itemName=philosowaffle.openapi-designer)

## Running costs

There are no costs associated with deploying any of this on AWS, there is [Free Tier](https://aws.amazon.com/free) coverage for limited free use.

The following services are deployed with Terraform;
- AWS Cognito
- AWS IAM
- (Added) CloudWatch Alarms, costs will be incurred for enabling Detailed Monitoring for API Gateway (!)
- (Added) AWS CodePipeline, and CodeBuild with Github as source repository. There's a free tier for:
  - [CodeBuild](https://aws.amazon.com/codebuild/pricing/), 100 build minutes of ```build.general1.small``` per month.
  - [AWS CodePipeline](https://aws.amazon.com/codepipeline/pricing/): 1 free pipeline active per month. 
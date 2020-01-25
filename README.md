# openapi-tf-example

# Get started

- Create the S3 bucket for your Terraform state files.
- Optionally, encrypt the S3 bucket and enable versioning such that you can do a rollback.
- Run ``` npm install ``` and then execute ``` npm run dev-init ```, this will:
  - Initialize the Terraform project for the 'dev' environment, and synchronize the state with the cloud stored .tfstate file.
  - If you run it a second time, it will fail on the workspace creation, this is not an issue (the workspace already exists)



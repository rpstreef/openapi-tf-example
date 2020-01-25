terraform {
  backend "s3" {
    encrypt = true
    bucket  = "dev-example-tf"
    key     = "example.tfstate"
    region  = "us-east-1"
    profile = "multithreadlabs-dev"
  }
}


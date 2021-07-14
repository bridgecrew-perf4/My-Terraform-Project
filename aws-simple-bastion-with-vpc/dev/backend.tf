terraform {
  backend "s3" {
    # S3 state bucket
    region               = "us-west-2"
    profile              = "sso_poweruser"
    session_name         = "terraform"
    bucket               = "dev-us-west-2-my-terraform-backend-files"
    key                  = "aws-simple-bastion-with-vpc/terraform.tfstate"
    encrypt              = true
    kms_key_id           = "cdfaf0c9-cd2f-4217-8b32-e1b030f38c50"
    workspace_key_prefix = "dev:"

    # DynamoDB lock table
    dynamodb_table = "dev-tf-remote-state-lock"
  }
}
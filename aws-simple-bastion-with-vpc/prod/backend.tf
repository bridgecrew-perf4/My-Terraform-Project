terraform {
  backend "s3" {
    # S3 state bucket
    region               = "us-west-2"
    profile              = "sso_poweruser"
    session_name         = "terraform"
    bucket               = "prod-us-west-2-my-terraform-backend-files"
    key                  = "aws-simple-bastion-with-vpc/terraform.tfstate"
    encrypt              = true
    kms_key_id           = "433aa9f4-63c7-4fb2-aeba-5177b53ee7cc"
    workspace_key_prefix = "prod:"

    # DynamoDB lock table
    dynamodb_table = "prod-tf-remote-state-lock"
  }
}
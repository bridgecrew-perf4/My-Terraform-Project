terraform {
  backend "s3" {
    # S3 state bucket
    region               = "us-west-2"
    profile              = "sso_poweruser"
    session_name         = "terraform"
    bucket               = "cert-us-west-2-my-terraform-backend-files"
    key                  = "aws-simple-bastion-with-vpc/terraform.tfstate"
    encrypt              = true
    kms_key_id           = "255c4667-df89-40c1-9241-4bcac3fe5c76"
    workspace_key_prefix = "cert:"

    # DynamoDB lock table
    dynamodb_table = "cert-tf-remote-state-lock"
  }
}
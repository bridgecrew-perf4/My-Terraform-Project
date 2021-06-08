terraform {
  backend "s3" {
    # S3 state bucket
    region               = "us-west-2"
    profile              = "sso_poweruser"
    session_name         = "terraform"
    bucket               = "cert-us-west-2-terraform-state-20210515"
    key                  = "aws-iam-service-user-group/terraform.tfstate"
    encrypt              = true
    kms_key_id           = "8c79578e-91d2-461e-acf4-b68f23b84719"
    workspace_key_prefix = "cert:"

    # DynamoDB lock table
    dynamodb_table = "cert-tf-remote-state-lock"
  }
}
terraform {
  backend "s3" {
    # S3 state bucket
    region               = "us-west-2"
    profile              = "sso_poweruser"
    session_name         = "terraform"
    bucket               = "prod-us-west-2-terraform-state-20210515"
    key                  = "aws-s3-backend-storage/terraform.tfstate"
    encrypt              = true
    kms_key_id           = "8c97e9b0-7491-47fe-83d2-878db0064d20"
    workspace_key_prefix = "prod:"

    # DynamoDB lock table
    dynamodb_table = "prod-tf-remote-state-lock"
  }
}
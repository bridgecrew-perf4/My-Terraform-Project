terraform {
  backend "s3" {
    # S3 state bucket
    region               = "us-west-2"
    profile              = "sso_poweruser"
    session_name         = "terraform"
    bucket               = "dev-us-west-2-terraform-state-20210515"
    key                  = "aws-jenkins-service-role/terraform.tfstate"
    encrypt              = true
    kms_key_id           = "2a77097c-c08b-457b-9866-f61570ea83c7"
    workspace_key_prefix = "dev:"

    # DynamoDB lock table
    dynamodb_table = "dev-tf-remote-state-lock"
  }
}
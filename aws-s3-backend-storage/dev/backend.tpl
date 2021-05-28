terraform {
  backend "s3" {
    # S3 state bucket
    region               = "${region}"
    profile              = "${profile}"
    session_name         = "${session_name}"
    bucket               = "${bucket}"
    key                  = "${key}"
    encrypt              = "${encrypt}"
    kms_key_id           = "${kms_key_id}"
    workspace_key_prefix = "${workspace_key_prefix}"

    # DynamoDB lock table
    dynamodb_table = "${dynamodb_table}"
  }
}
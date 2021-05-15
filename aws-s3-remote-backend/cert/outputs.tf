/*
Variables used with the main Terraform template.
*/

# S3 state bucket arn
output "s3_bucket_arn" {
  value       = module.s3.bucket_id
  description = "The ARN of the S3 bucket"
}

# KMS key id for state bucket
output "kms_key_id" {
  value       = module.s3.kms_key_id
  description = "The key used to encrypt the remote state bucket"
}

# DynamoDB lock table name
output "dynamodb_table_name" {
  value       = module.dynamo.dynamodb_table
  description = "The name of the DynamoDB table"
}

# Terraform IAM service role
output "terraform_role" {
  value       = module.iam.terraform_role
  description = "Name of the Terraform IAM service role"
}
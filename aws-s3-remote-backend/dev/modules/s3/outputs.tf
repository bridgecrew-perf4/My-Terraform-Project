/*
Outputs from the S3 Terraform module.
*/

# S3 bucket id
output "bucket_id" {
  value       = aws_s3_bucket.state.id
  description = "Name of the remote state S3 bucket"
}

# AWS KMS key id
output "kms_key_id" {
  value       = aws_kms_key.this.id
  description = "The key used to encrypt the remote state S3 bucket"
}
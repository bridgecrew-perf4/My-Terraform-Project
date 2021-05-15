/*
Variables used with the IAM Terraform template.
*/

variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment name"
}

variable "s3_bucket" {
  type        = string
  default     = null
  description = "Name of the S3 bucket"
}

variable "kms_key" {
  type        = string
  default     = null
  description = "The key used to encrypt the remote state S3 bucket"
}

variable "dynamodb_table" {
  type        = string
  default     = null
  description = "Name of DynamoDB table"
}
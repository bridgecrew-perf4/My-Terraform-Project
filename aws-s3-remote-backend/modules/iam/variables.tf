/*
Variables used with the IAM Terraform template.
*/

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment name"
}

variable "s3_bucket" {
  type        = string
  default     = "terraform-state"
  description = "Name of the S3 bucket"
}

variable "kms_key" {
  type        = string
  default     = "terraform-state"
  description = "The key used to encrypt the remote state S3 bucket"
}
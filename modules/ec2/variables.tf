/*
Variables used with the AWS EC2 Terraform module.
*/

variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment name"
}

variable "ami" {
  type        = string
  default     = null
  description = "Amazon Machine Instance identifier"
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "AWS ID of VPC subnet"
}
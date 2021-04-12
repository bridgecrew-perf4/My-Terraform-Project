/*
Variables used with the AWS VPC Terraform module.
*/

variable "vpc_cidr_block" {
  type        = string
  default     = null
  description = "CIDR block for the VPC"
}

variable "subnet_cidr_block" {
  type        = string
  default     = null
  description = "CIDR block for the subnet"
}
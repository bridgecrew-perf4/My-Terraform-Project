/*
Variables used with the AWS VPC Terraform module.
*/

variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment name"
}

variable "availability_zone" {
  type        = string
  default     = null
  description = "AWS availability zone"
}

variable "vpc_cidr" {
  type        = string
  default     = null
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr" {
  type        = string
  default     = null
  description = "CIDR block for the public subnet"
}

variable "private_subnet_cidr" {
  type        = string
  default     = null
  description = "CIDR block for the private subnet"
}

variable "my_ip_address" {
  type        = string
  default     = null
  description = "My public IP address"
}
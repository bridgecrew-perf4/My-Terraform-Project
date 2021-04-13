/*
Variables used with the main Terraform template.
*/

variable "environment" {
  type = string
  default = null
  description = "Deployment environment name"
}

variable "profile" {
  type        = string
  default     = null
  description = "AWS profile name"
}

variable "region" {
  type = string
  default = null
  description = "AWS region"
}

variable "availability_zone" {
  type = string
  default = null
  description = "AWS availability zone"
}

variable "ami" {
  type        = string
  default     = null
  description = "Amazon Machine Instance identifier"
}

variable "vpc_cidr" {
  type        = string
  default     = null
  description = "CIDR block for the VPC"
}

variable "public_subnet_a_cidr" {
  type        = string
  default     = null
  description = "CIDR block for the public subnet"
}

variable "private_subnet_a_cidr" {
  type = string
  default = null
  description = "CIDR block for the private subnet"
}
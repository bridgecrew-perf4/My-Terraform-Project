/*
Variables used with the AWS EC2 Terraform module.
*/

variable "owner" {
  type        = string
  default     = null
  description = "The OS user who should be given ownership over the certificate files."
}

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

variable "key_name" {
  type        = string
  default     = null
  description = "SSH key name"
}

variable "public_key" {
  type        = string
  default     = null
  description = "SSH public key"
}

variable "ami" {
  type        = string
  default     = null
  description = "Amazon Machine Instance identifier"
}

variable "instance_type" {
  type        = string
  default     = null
  description = "EC2 instance type"
}

variable "public_subnet_id" {
  type        = string
  default     = null
  description = "AWS ID of VPC public subnet"
}

variable "private_subnet_id" {
  type        = string
  default     = null
  description = "AWS ID of VPC private subnet"
}

variable "bastion_sg" {
  type        = string
  default     = null
  description = "Security group for Bastion EC2 instance"
}

variable "private_sg" {
  type        = string
  default     = null
  description = "SSH security group for private instances"
}
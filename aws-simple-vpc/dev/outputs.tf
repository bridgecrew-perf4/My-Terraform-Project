/*
Outputs from the main Terraform module.
*/

# Output VPC id
output "aws_vpc_id" {
  value       = module.vpc.aws_vpc_id
  description = "AWS ID of the VPC"
}

# Output all public subnets
output "public_subnets" {
  value = module.vpc.public_subnets
  description = "AWS ID of public subnets in the VPC"
}

# Output all private subnets
output "private_subnets" {
  value = module.vpc.private_subnets
  description = "AWS ID of private subnets in the VPC"
}
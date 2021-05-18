/*
Outputs from the VPC Terraform module.
*/

# Output VPC id
output "aws_vpc_id" {
  value       = aws_vpc.my_vpc.id
  description = "AWS ID of the VPC"
}

# Output all public subnets
output "public_subnets" {
  value       = aws_subnet.public.*.id
  description = "AWS ID of public subnets in the VPC"
}

# Output all private subnets
output "private_subnets" {
  value       = aws_subnet.private.*.id
  description = "AWS ID of private subnets in the VPC"
}
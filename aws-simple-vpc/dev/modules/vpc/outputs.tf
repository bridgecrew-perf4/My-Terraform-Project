/*
Outputs from the VPC Terraform module.
*/

output "aws_vpc_id" {
  description = "AWS ID of the VPC."
  value       = aws_vpc.my_vpc.id
}
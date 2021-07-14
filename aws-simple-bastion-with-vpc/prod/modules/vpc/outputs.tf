/*
Outputs from the VPC Terraform module.
*/

output "aws_vpc_id" {
  description = "AWS ID of the VPC."
  value       = aws_vpc.my_vpc.id
}

output "aws_public_subnet_id" {
  description = "AWS ID of the subnet."
  value       = aws_subnet.public_subnet.id
}

output "aws_private_subnet_id" {
  description = "AWS ID of the subnet."
  value       = aws_subnet.private_subnet.id
}

output "bastion_sg" {
  description = "SSH security group for the bastion host"
  value       = aws_security_group.bastion_sg.id
}

output "private_sg" {
  description = "SSH security group for private instances"
  value       = aws_security_group.private_sg.id
}
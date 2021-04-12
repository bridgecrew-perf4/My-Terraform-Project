output "aws_vpc_id" {
  description = "AWS ID of the VPC."
  value       = aws_vpc.main.id
}

output "aws_public_subnet_id_a" {
  description = "AWS ID of the subnet."
  value       = aws_subnet.public_subnet_a.id
}

output "aws_private_subnet_id_a" {
  description = "AWS ID of the subnet."
  value       = aws_subnet.private_subnet_a.id
}
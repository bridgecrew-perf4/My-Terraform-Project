output "bastion_public_ip" {
  description = "The public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the private instance"
  value       = aws_instance.private.public_ip
}
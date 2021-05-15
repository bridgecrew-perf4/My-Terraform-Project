/*
Outputs from the main Terraform module.
*/

output "bastion_public_ip" {
  description = "The public IP address of the bastion host"
  value       = module.ec2.bastion_public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the private instance"
  value       = module.ec2.instance_private_ip
}
output "instance_ip_addr" {
  description = "The private IP address of the main server instance."
  value       = module.ec2.instance_ip_addr
}
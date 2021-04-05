output "instance_ip_addr" {
  description = "The private IP address of the main server instance."
  value       = aws_instance.example.private_ip
}
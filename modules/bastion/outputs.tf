output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_eip" {
  description = "The Elastic IP of the bastion host"
  value       = aws_eip.bastion_eip.public_ip
}
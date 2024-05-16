output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.bastion.bastion_public_ip
}

output "master_private_ip" {
  description = "Private IP address of the master node"
  value       = module.ec2.master_private_ip
}
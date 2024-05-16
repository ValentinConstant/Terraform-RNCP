output "master_private_ip" {
  description = "Private IP address of the master node"
  value       = aws_instance.master.private_ip
}

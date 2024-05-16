output "kubeconfig" {
  description = "Path to the kubeconfig file"
  value       = local_file.kubeconfig.filename
}

output "master_private_ip" {
  description = "Private IP address of the master node"
  value       = aws_instance.master.private_ip
}

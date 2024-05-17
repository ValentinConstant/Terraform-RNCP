output "master_private_ip" {
  description = "Private IP address of the master node"
  value       = aws_instance.master.private_ip
}

output "master_node" {
  description = "ID of the master node"
  value       = aws_instance.master.id
}

output "workers_asg" {
  description = "ID of the workers nodes"
  value       = aws_autoscaling_group.k3s_workers.id
}

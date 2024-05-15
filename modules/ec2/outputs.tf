output "worker_private_ips" {
  value = aws_autoscaling_group.k3s_workers.instances[*].private_ip
}

output "worker_instance_ids" {
  value = aws_autoscaling_group.k3s_workers.instances[*].id
}

output "master_private_ip" {
  value = aws_instance.master.private_ip
}

output "master_instance_id" {
  value = aws_instance.master.id
}

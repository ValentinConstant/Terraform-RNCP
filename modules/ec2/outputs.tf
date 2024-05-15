data "aws_instances" "workers" {
  filter {
    name   = "tag:Name"
    values = ["k3s-worker"]
  }
}

output "worker_private_ips" {
  value = data.aws_instances.workers.private_ips
}

output "worker_instance_ids" {
  value = data.aws_instances.workers.ids
}

output "master_private_ip" {
  value = aws_instance.master.private_ip
}

output "master_instance_id" {
  value = aws_instance.master.id
}

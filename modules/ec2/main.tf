resource "aws_instance" "master" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  user_data = <<-EOF
  #!/bin/bash
  curl -sfL https://get.k3s.io | sh -
  EOF

  tags = {
    Name = "k3s-master"
  }
}

resource "aws_instance" "worker" {
  count         = var.worker_count
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = element(var.subnet_ids, count.index % length(var.subnet_ids))

  user_data = <<-EOF
  #!/bin/bash
  K3S_URL="https://${aws_instance.master.private_ip}:6443"
  K3S_TOKEN="REPLACE_WITH_ACTUAL_TOKEN"
  curl -sfL https://get.k3s.io | K3S_URL=${K3S_URL} K3S_TOKEN=${K3S_TOKEN} sh -
  EOF

  tags = {
    Name = "k3s-worker-${count.index}"
  }
}
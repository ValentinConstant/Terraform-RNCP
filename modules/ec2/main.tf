data "aws_autoscaling_group" "workers" {
  name = aws_autoscaling_group.k3s_workers.name
}

resource "aws_instance" "master" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = element(var.subnet_ids, 0)
  vpc_security_group_ids = [var.security_group_id]

  user_data = templatefile("${path.module}/user_data_master.sh", {
    K3S_TOKEN = var.k3s_token
  })

  tags = {
    Name = "k3s-master"
  }
}

resource "aws_launch_template" "k3s_worker" {
  name_prefix   = "k3s-worker-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  user_data = templatefile("${path.module}/user_data_worker.sh", {
    MASTER_PRIVATE_IP = aws_instance.master.private_ip,
    K3S_URL   = var.k3s_url,
    K3S_TOKEN = var.k3s_token
  })

  lifecycle {
    create_before_destroy = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
    }
  }
}

resource "aws_autoscaling_group" "k3s_workers" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  launch_template {
    id      = aws_launch_template.k3s_worker.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "k3s-worker"
    propagate_at_launch = true
  }
}
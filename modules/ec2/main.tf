resource "aws_instance" "master" {
  ami                   = var.ami
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_id             = var.master_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile  = var.iam_instance_profile

  user_data = file("${path.module}/user_data_master.sh")

  tags = {
    Name = "k3s-master"
  }

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = true
  }
}

resource "aws_launch_template" "k3s_worker" {
  name_prefix           = "k3s-worker-"
  image_id              = var.ami
  instance_type         = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(file("${path.module}/user_data_worker.sh"))

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type           = "gp2"
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  depends_on = [aws_instance.master]
}

resource "aws_autoscaling_group" "k3s_workers" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  launch_template {
    id      = aws_launch_template.k3s_worker.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.worker_subnet_ids

  tag {
    key                 = "Name"
    value               = "k3s-worker"
    propagate_at_launch = true
  }

  depends_on = [aws_instance.master]
}
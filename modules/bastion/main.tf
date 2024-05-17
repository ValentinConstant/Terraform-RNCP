resource "aws_instance" "bastion" {
  ami                   = var.ami
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_id             = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile  = var.iam_instance_profile

  user_data = file("${path.module}/user_data_bastion.sh")

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_instance" "bastion" {
  ami                   = var.ami
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_id             = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = false
  iam_instance_profile  = var.iam_instance_profile

  user_data = file("${path.module}/user_data_bastion.sh")

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  domain = "vpc"

  tags = {
    Name = "bastion-eip"
  }
}

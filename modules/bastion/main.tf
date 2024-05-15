resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  # associate_public_ip_address = true
  vpc_security_group_ids = [var.security_group_id]

  user_data = file("${path.module}/user_data_bastion.sh")

  tags = {
    Name = "bastion-host"
  }
}
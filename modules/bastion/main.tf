resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  # Update the package list and install necessary packages
  sudo apt-get update
  sudo apt-get install -y curl

  # Install Helm
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  EOF

  tags = {
    Name = "bastion-host"
  }
}
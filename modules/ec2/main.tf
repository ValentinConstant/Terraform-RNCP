resource "aws_instance" "master" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  user_data = file("${path.module}/user_data_master.sh")

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

  user_data = file("${path.module}/user_data_worker.sh")

  tags = {
    Name = "k3s-worker-${count.index}"
  }
}
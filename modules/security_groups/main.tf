resource "aws_security_group" "eks" {
  name        = "${var.cluster_name}-eks-sg"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow all traffic within VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

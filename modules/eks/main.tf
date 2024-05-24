resource "aws_eks_cluster" "kbnhvn-cluster" {
  
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = [
      var.private_subnet_1,
      var.private_subnet_2,
      var.public_subnet_1,
      var.public_subnet_2
    ]
    endpoint_private_access = false
    endpoint_public_access = true
  }

  depends_on = [var.cluster_policy]
}


resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = var.cluster_name
  node_group_name = "private-nodes"
  node_role_arn   = var.nodes_role_arn

  subnet_ids = [
    var.private_subnet_1,
    var.private_subnet_2
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = [var.instance_type]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.max_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }


  depends_on = [
    var.workers_policy,
    var.cni_policy,
    var.ec2_container_registry,
  ]
}
resource "aws_eks_cluster" "kbnhvn-cluster" {
  
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = [
      module.vpc.aws_subnet.private-eu-west-3a.id,
      module.vpc.aws_subnet.private-eu-west-3b.id,
      module.vpc.aws_subnet.public-eu-west-3a.id,
      module.vpc.aws_subnet.public-eu-west-3b.id
    ]
    endpoint_private_access = false
    endpoint_public_access = true
  }

  depends_on = [module.iam.cluster_policy]
}


resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = var.cluster_name
  node_group_name = "private-nodes"
  node_role_arn   = var.nodes_role_arn

  subnet_ids = [
    module.vpc.aws_subnet.private-eu-west-3a.id,
    module.vpc.aws_subnet.private-eu-west-3b.id
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
    module.iam.workers_policy,
    module.iam.cni_policy,
    module.iam.ec2_container_registry,
  ]
}
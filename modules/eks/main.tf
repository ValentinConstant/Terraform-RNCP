module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids         = var.subnets
  vpc_id          = var.vpc_id

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    use_custom_launch_template = false
  }

  eks_managed_node_groups = {
    eks_nodes = {
      desired_size = var.desired_capacity
      max_size     = var.max_capacity
      min_size     = var.min_capacity

      instance_type = var.instance_type

    }
  }

  tags = var.tags

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access = true
}

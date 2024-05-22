provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "./modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  cluster_name    = var.cluster_name

}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  cluster_name = var.cluster_name
  environment = var.environment
}

module "iam" {
  source = "./modules/iam"
  s3_buckets = [
    module.s3.etcd_backup_bucket,
    module.s3.postgres_backup_bucket,
    module.s3.elasticsearch_backup_bucket
  ]
}

module "s3" {
  source      = "./modules/s3"
  prefix      = var.prefix
  environment = var.environment
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  subnets         = module.vpc.private_subnet_ids
  vpc_id          = module.vpc.vpc_id
  desired_capacity = var.desired_capacity
  max_capacity     = var.max_capacity
  min_capacity     = var.min_capacity
  instance_type    = var.instance_type
  key_name         = var.key_name
  node_role_arn    = module.iam.eks_role_arn

  tags = {
    Environment = "dev"
    Name        = var.cluster_name
  }
}

module "alb" {
  source   = "./modules/alb"
  vpc_id   = module.vpc.vpc_id
  subnets  = module.vpc.public_subnet_ids
  cert_arn = data.aws_acm_certificate.cert.arn
  environment = var.environment
  security_group_id = module.security_groups.alb_sg_id

}

data "aws_acm_certificate" "cert" {
  domain       = var.domain_name
  types       = ["IMPORTED"]
  most_recent = true
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-kbnhvn"
    key    = "primary/terraform.tfstate"
    region = "eu-west-3"
  }
}

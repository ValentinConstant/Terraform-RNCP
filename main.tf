provider "aws" {
  region = var.region
}

data "aws_secretsmanager_secret_version" "jenkins_admin_password" {
  secret_id = "jenkins/admin_password"
}

locals {
  jenkins_admin_password = jsondecode(data.aws_secretsmanager_secret_version.jenkins_admin_password.secret_string).password
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

module "vpc" {
  source  = "./modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  environment = var.environment

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

module "traefik" {
  source   = "./modules/traefik"
  cert_arn = data.aws_acm_certificate.cert.arn
}

module "jenkins" {
  source               = "./modules/jenkins"
  jenkins_admin_password = local.jenkins_admin_password
}

data "aws_acm_certificate" "cert" {
  domain       = var.domain_name
  types       = ["IMPORTED"]
  most_recent = true
}


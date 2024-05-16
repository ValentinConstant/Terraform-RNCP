provider "aws" {
  region = var.region
}

provider "kubernetes" {
  config_path = "${path.module}/modules/ec2/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/modules/ec2/kubeconfig"
  }
}

data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret_version" "k3s_token" {
  secret_id = "k3s/token"
}

data "aws_secretsmanager_secret_version" "jenkins_admin_password" {
  secret_id = "jenkins/admin_password"
}

locals {
  k3s_token = jsondecode(data.aws_secretsmanager_secret_version.k3s_token.secret_string).token
  jenkins_admin_password = jsondecode(data.aws_secretsmanager_secret_version.jenkins_admin_password.secret_string).password
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs            = var.azs
}

module "iam" {
  source = "./modules/iam"
  region = var.region
  elasticsearch_bucket = var.elasticsearch_bucket
  postgres_bucket = var.postgres_bucket
  etcd_bucket = var.etcd_bucket
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "s3" {
  source = "./modules/s3"
  elasticsearch_bucket = var.elasticsearch_bucket
  postgres_bucket = var.postgres_bucket
  etcd_bucket = var.etcd_bucket
}

module "bastion" {
  source         = "./modules/bastion"
  ami            = var.ami
  instance_type  = var.bastion_instance_type
  key_name       = var.key_name
  subnet_id      = element(module.vpc.public_subnet_ids, 0)
  security_group_id = module.security_groups.bastion_sg_id
  iam_instance_profile = module.iam.bastion_profile_name
}

module "ec2" {
  source              = "./modules/ec2"
  ami                 = var.ami
  instance_type       = var.instance_type
  key_name            = var.key_name
  master_subnet_id    = element(module.vpc.private_subnet_ids, 0)
  worker_subnet_ids   = module.vpc.private_subnet_ids
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  security_group_id   = module.security_groups.ec2_sg_id
  iam_instance_profile = module.iam.ec2_instance_profile_name
  k3s_token           = local.k3s_token
}

resource "local_file" "kubeconfig" {
  content  = templatefile("${path.module}/templates/kubeconfig.tpl", {
    server   = "${module.ec2.master_private_ip}",
    token    = local.k3s_token
  })
  filename = "${path.module}/kubeconfig"
}

module "jenkins" {
  source               = "./modules/jenkins"
  master_private_ip    = module.ec2.master_private_ip
  jenkins_admin_password = local.jenkins_admin_password

  # depends_on = [module.ec2]
}
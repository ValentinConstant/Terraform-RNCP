provider "aws" {
  region = var.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

data "aws_secretsmanager_secret_version" "github_pat" {
  secret_id = "github/pat"
}

data "aws_secretsmanager_secret_version" "postgres_credentials" {
  secret_id = "postgres/credentials"
}

data "aws_secretsmanager_secret_version" "jenkins_admin_password" {
  secret_id = "jenkins/admin_password"
}

data "aws_secretsmanager_secret_version" "k3s_token" {
  secret_id = "k3s/token"
}

locals {
  github_pat             = jsondecode(data.aws_secretsmanager_secret_version.github_pat.secret_string).token
  github_user            = jsondecode(data.aws_secretsmanager_secret_version.github_pat.secret_string).username
  postgres_user          = jsondecode(data.aws_secretsmanager_secret_version.postgres_credentials.secret_string).username
  postgres_password      = jsondecode(data.aws_secretsmanager_secret_version.postgres_credentials.secret_string).password
  jenkins_admin_password = jsondecode(data.aws_secretsmanager_secret_version.jenkins_admin_password.secret_string).password
  k3s_token              = jsondecode(data.aws_secretsmanager_secret_version.k3s_token.secret_string).token
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs            = var.azs
}

module "ec2" {
  source           = "./modules/ec2"
  ami              = "ami-0a91cd140a1fc148a"  # Changez ceci selon votre région
  instance_type    = var.instance_type
  key_name         = var.key_name
  subnet_ids       = module.vpc.private_subnet_ids
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size
  k3s_url          = "https://${module.ec2.master_private_ip}:6443"
  k3s_token        = local.k3s_token
}

module "bastion" {
  source         = "./modules/bastion"
  ami            = "ami-0a91cd140a1fc148a"  # Changez ceci selon votre région
  instance_type  = var.bastion_instance_type
  key_name       = var.key_name
  subnet_id      = element(module.vpc.public_subnet_ids, 0)
}

module "jenkins" {
  source         = "./modules/jenkins"
  master_private_ip = module.ec2.master_private_ip
  jenkins_admin_password = local.jenkins_admin_password
}

module "prometheus" {
  source         = "./modules/prometheus"
  master_private_ip = module.ec2.master_private_ip
}

module "grafana" {
  source         = "./modules/grafana"
  master_private_ip = module.ec2.master_private_ip
}

module "backup" {
  source              = "./modules/backup"
  region              = var.region
  postgres_bucket     = "your-postgres-backup-bucket"
  elasticsearch_bucket = "your-elasticsearch-backup-bucket"
  etcd_bucket         = "your-etcd-backup-bucket"
  postgres_user       = local.postgres_user
  postgres_password   = local.postgres_password
  postgres_service_name = var.postgres_service_name
  postgres_namespace  = var.postgres_namespace
  elasticsearch_service_name = var.elasticsearch_service_name
  elasticsearch_namespace = var.elasticsearch_namespace
  etcd_endpoints      = var.etcd_endpoints
  etcd_cert           = var.etcd_cert
  etcd_key            = var.etcd_key
  etcd_ca_cert        = var.etcd_ca_cert
  aws_access_key_id   = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
}

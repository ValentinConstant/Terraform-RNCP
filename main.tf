provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

module "vpc" {
  source  = "./modules/vpc"
  # version = "3.10.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags = {
    Name = var.vpc_name
  }
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  cluster_name = var.cluster_name
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
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  desired_capacity = var.desired_capacity
  max_capacity     = var.max_capacity
  min_capacity     = var.min_capacity
  instance_type    = var.instance_type
  key_name         = var.key_name
  node_role_arn    = module.iam.node_role_arn

  tags = {
    Environment = "dev"
    Name        = var.cluster_name
  }
}

module "alb" {
  source   = "./modules/alb"
  vpc_id   = module.vpc.vpc_id
  subnets  = module.vpc.public_subnets
  cert_arn = aws_acm_certificate.cert.arn
  environment = var.environment
  security_group_id = 
}

module "traefik" {
  source   = "./modules/traefik"
  cert_arn = aws_acm_certificate.cert.arn
}

module "jenkins" {
  source               = "./modules/jenkins"
  jenkins_admin_password = var.jenkins_admin_password
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  depends_on = [aws_route53_record.cert_validation]
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      type    = dvo.resource_record_type
      record  = dvo.resource_record_value
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

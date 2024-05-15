variable "region" {
  description = "AWS region to deploy resources"
  default     = "eu-west-3"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnets"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
  description = "Availability Zones"
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
}

variable "private_key_path" {
  description = "Path to the private key for SSH access"
}

variable "github_pat" {
  description = "GitHub Personal Access Token for accessing private repos"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "postgres_service_name" {
  description = "Kubernetes service name for the PostgreSQL StatefulSet"
  type        = string
}

variable "postgres_namespace" {
  description = "Kubernetes namespace for the PostgreSQL StatefulSet"
  type        = string
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
}

variable "elasticsearch_service_name" {
  description = "Kubernetes service name for the Elasticsearch StatefulSet"
  type        = string
}

variable "elasticsearch_namespace" {
  description = "Kubernetes namespace for the Elasticsearch StatefulSet"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS access key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
}
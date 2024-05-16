variable "region" {
  description = "The AWS region to deploy in"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnets"
  type        = list(string)
}

variable "azs" {
  description = "A list of availability zones"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for the master and worker nodes"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "desired_capacity" {
  description = "Desired capacity for the worker node auto-scaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum size for the worker node auto-scaling group"
  type        = number
}

variable "min_size" {
  description = "Minimum size for the worker node auto-scaling group"
  type        = number
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "elasticsearch_bucket" {
  description = "Name of the S3 bucket for Elasticsearch backups"
  type        = string
}

variable "postgres_bucket" {
  description = "Name of the S3 bucket for PostgreSQL backups"
  type        = string
}

variable "etcd_bucket" {
  description = "Name of the S3 bucket for ETCD backups"
  type        = string
}

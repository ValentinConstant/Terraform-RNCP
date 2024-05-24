variable "prefix" {
  description = "Prefix for the S3 buckets"
  type        = string
}

variable "environment" {
  description = "Environment for tagging purposes"
  type        = string
}

variable "private_subnet_1" {
  description = "ID of private subnet 1"
  type        = string
}

variable "private_subnet_2" {
  description = "ID of private subnet 2"
  type        = string
}

variable "private_subnet_3" {
  description = "ID of private subnet 3"
  type        = string
}

variable "efs-mount-sg" {
  description = "ID of EFS SG"
  type        = string
}


variable "region" {
  description = "AWS region"
  type        = string
}

variable "postgres_bucket" {
  description = "S3 bucket for PostgreSQL backups"
  type        = string
}

variable "elasticsearch_bucket" {
  description = "S3 bucket for Elasticsearch backups"
  type        = string
}

variable "etcd_bucket" {
  description = "S3 bucket for etcd backups"
  type        = string
}

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

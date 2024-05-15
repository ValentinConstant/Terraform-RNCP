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

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
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

variable "etcd_endpoints" {
  description = "etcd endpoints"
  type        = string
}

variable "etcd_cert" {
  description = "etcd client certificate"
  type        = string
}

variable "etcd_key" {
  description = "etcd client key"
  type        = string
}

variable "etcd_ca_cert" {
  description = "etcd CA certificate"
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

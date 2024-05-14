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

variable "postgres_host" {
  description = "PostgreSQL host"
  type        = string
}

variable "postgres_db" {
  description = "PostgreSQL database"
  type        = string
}

variable "elasticsearch_host" {
  description = "Elasticsearch host"
  type        = string
}

variable "etcd_endpoints" {
  description = "etcd endpoints"
  type        = string
}

variable "etcd_cert" {
  description = "etcd certificate"
  type        = string
}

variable "etcd_key" {
  description = "etcd key"
  type        = string
}

variable "etcd_ca_cert" {
  description = "etcd CA certificate"
  type        = string
}
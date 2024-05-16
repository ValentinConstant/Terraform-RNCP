variable "master_private_ip" {
  description = "The private IP address of the K3s master node"
  type        = string
}

variable "jenkins_admin_password" {
  description = "Password for Jenkins admin account"
  type        = string
}


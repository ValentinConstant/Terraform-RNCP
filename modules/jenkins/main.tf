provider "kubernetes" {
  config_path = "${path.module}/../../kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/../../kubeconfig"
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.1.16"

  set {
    name  = "master.adminPassword"
    value = var.jenkins_admin_password
  }

  set {
    name  = "controller.jenkinsUrl"
    value = "http://${var.master_private_ip}:8080"
  }

  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"
  }
}

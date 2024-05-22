resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = "default"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "3.5.17"

  set {
    name  = "master.adminPassword"
    value = var.jenkins_admin_password
  }

  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.installPlugins[0]"
    value = "kubernetes:1.30.1"
  }

  set {
    name  = "controller.installPlugins[1]"
    value = "workflow-aggregator:2.6"
  }

  set {
    name  = "controller.installPlugins[2]"
    value = "git:4.7.1"
  }

  set {
    name  = "controller.installPlugins[3]"
    value = "configuration-as-code:1.51"
  }

  set {
    name  = "controller.installPlugins[4]"
    value = "docker-workflow:1.26"
  }
}
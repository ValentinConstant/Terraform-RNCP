resource "kubernetes_config_map" "jenkins_casc" {
  metadata {
    name      = "jenkins-casc"
    namespace = "jenkins"
  }

  data = {
    "jenkins.yaml" = file("${path.module}/casc_configs/jenkins.yaml")
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "jenkins"

  set {
    name  = "master.jenkinsUrl"
    value = "http://${var.master_private_ip}:8080"
  }

  set {
    name  = "master.adminPassword"
    value = var.jenkins_admin_password
  }

  set {
    name  = "master.installPlugins"
    value = "configuration-as-code:1.51,job-dsl:1.77"
  }

  set {
    name  = "master.CasC.configScripts"
    value = "jenkins-casc=/var/jenkins_home/casc_configs/jenkins.yaml"
  }

  set {
    name  = "master.yamlConfig"
    value = <<-EOT
    persistence:
      enabled: true
      storageClass: standard
      size: 8Gi
      annotations: {}
      accessMode: ReadWriteOnce
    EOT
  }

  values = [file("${path.module}/casc_configs/jenkins.yaml")]
}
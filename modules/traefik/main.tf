resource "helm_release" "traefik" {
  name       = "traefik"
  namespace  = "kube-system"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "10.3.0"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "HTTP"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = "https"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = var.cert_arn
  }
}

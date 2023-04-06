resource "helm_release" "ingress_nginx_controller" {
  name        = var.nginx_ic_release_name
  repository  = var.nginx_ic_repository
  chart       = var.nginx_ic_chart
  version     = var.nginx_ic_chart_version
  namespace   = var.nginx_ic_release_namespace
  description = "Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer"

  set {
    name  = "nameOverride"
    value = var.nginx_ic_name_override
  }

  set {
    name  = "fullnameOverride"
    value = var.nginx_ic_name_override
  }

  set {
    name  = "controller.kind"
    value = var.nginx_ic_controller_kind
  }

  set {
    name  = "controller.image.tag"
    value = var.nginx_ic_controller_image_tag
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name  = "controller.metrics.enabled"
    value = var.nginx_ic_metrics_enabled
  }
}

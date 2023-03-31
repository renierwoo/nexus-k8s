resource "helm_release" "prometheus" {
  name        = var.prometheus_release_name
  repository  = var.prometheus_repository
  chart       = var.prometheus_chart
  version     = var.prometheus_chart_version
  namespace   = var.prometheus_release_namespace
  description = "Prometheus monitoring system for Kubernetes"

  set {
    name  = "server.image.tag"
    value = var.prometheus_server_image_tag
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = "false"
  }

  # set {
  #   name  = "server.persistentVolume.storageClass"
  #   value = var.prometheus_server_storageClass
  # }
}

resource "helm_release" "grafana" {
  name        = var.grafana_release_name
  repository  = var.grafana_repository
  chart       = var.grafana_chart
  version     = var.grafana_chart_version
  namespace   = var.grafana_release_namespace
  description = "Grafana monitoring system for Kubernetes"

  set {
    name  = "image.tag"
    value = var.grafana_server_image_tag
  }

  set {
    name  = "admin.existingSecret"
    value = kubernetes_secret.grafana.metadata[0].name
  }

  values = [
    templatefile("${path.module}/artifacts/values.yaml", {
      domain = var.grafana_domain
    })
  ]

  depends_on = [kubernetes_secret.grafana]
}

resource "helm_release" "kube_prometheus_stack" {
  name        = var.kps_release
  repository  = var.kps_repository
  chart       = var.kps_chart
  version     = var.kps_chart_version
  namespace   = var.kps_release_namespace
  description = "Kube Prometheus Stack monitoring system for Kubernetes"

  set {
    name  = "grafana.admin.existingSecret"
    value = kubernetes_secret.grafana.metadata[0].name
  }

  set {
    name  = "prometheusOperator.admissionWebhooks.patch.enabled"
    value = "false"
  }

  set {
    name  = "grafana.grafana.ini.server.domain"
    value = var.grafana_domain
  }

  set {
    name  = "grafana.grafana.ini.security.content_security_policy"
    value = "true"
  }

  set {
    name  = "grafana.grafana.ini.security.content_security_policy_template"
    value = "\"\"\"default-src 'self'; script-src 'self' 'strict-dynamic' $NONCE; script-src-elem 'self' 'unsafe-inline'; object-src 'none'; font-src 'self' https://fonts.gstatic.com/; img-src 'self'; style-src 'self' 'strict-dynamic' $NONCE; style-src-elem 'self' 'unsafe-inline'; base-uri 'self'; frame-ancestors 'none'; block-all-mixed-content;\"\"\""
  }

  depends_on = [kubernetes_secret.grafana]
}


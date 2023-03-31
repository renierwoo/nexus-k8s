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
    name  = "admin.userKey"
    value = kubernetes_secret.grafana.data["admin-user"]
  }

  set {
    name  = "admin.passwordKey"
    value = kubernetes_secret.grafana.data["admin-password"]
  }

  set {
    name = "cookie_secure"
    value = "true"
  }

  set {
    name = "cookie_samesite"
    value = "strict"
  }

  set {
    name = "login_cookie_name"
    value = "__Secure-grafana_session"
  }

  set {
    name = "hide_version"
    value = "true"
  }

  set {
    name = "enforce_domain"
    value = "true"
  }

  set {
    name = "content_security_policy"
    value = "true"
  }

  set {
    name = "content_security_policy_template"
    value = "default-src 'self'; script-src 'self' 'strict-dynamic' 'nonce-$${nonce}'; object-src 'none'; font-src 'self' https://fonts.gstatic.com/; img-src 'self'; style-src 'self' 'nonce-$${nonce}'; base-uri 'self'; frame-ancestors 'none'; block-all-mixed-content;"
  }
}


grafana_release_name = "grafana"
grafana_repository = "https://grafana.github.io/helm-charts"
grafana_chart = "grafana"
grafana_chart_version = "6.52.4"
grafana_release_namespace = "monitoring"
grafana_server_image_tag = "9.4.3"
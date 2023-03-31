resource "random_password" "grafana" {
  length  = 128
  special = false
  #override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "grafana" {
  metadata {
    name      = "grafana"
    namespace = var.grafana_release_namespace
  }

  data = {
    admin-user     = "renierwoo"
    admin-password = random_password.grafana.result
  }
}

resource "kubernetes_secret" "grafana_tls" {
  metadata {
    name      = "grafana-tls"
    namespace = var.grafana_release_namespace
  }

  type = "kubernetes.io/tls"

  data = {
    # "tls.key" = file("${path.module}/artifacts/wootechspace.com.key")
    "tls.key" = var.domain_tls_key
    # "tls.crt" = file("${path.module}/artifacts/wootechspace.com.pem")
    "tls.crt" = var.domain_tls_crt
  }
}

resource "random_password" "prometheus" {
  length  = 128
  special = false
  #override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = var.prometheus_namespace_name
  }

  data = {
    admin-user     = "renierwoo"
    admin-password = random_password.prometheus.result
  }

  depends_on = [kubernetes_namespace.prometheus]
}

resource "kubernetes_secret" "prometheus_tls" {
  metadata {
    name      = "prometheus-tls"
    namespace = var.prometheus_namespace_name
  }

  type = "kubernetes.io/tls"

  data = {
    # "tls.key" = file("${path.module}/artifacts/wootechspace.com.key")
    "tls.key" = var.domain_tls_key
    # "tls.crt" = file("${path.module}/artifacts/wootechspace.com.pem")
    "tls.crt" = var.domain_tls_crt
  }
}

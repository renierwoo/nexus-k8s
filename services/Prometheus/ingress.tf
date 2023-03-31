resource "kubernetes_ingress_v1" "prometheus" {
  metadata {
    name      = var.prometheus_release_name
    namespace = var.prometheus_namespace_name
    annotations = {
      # "nginx.ingress.kubernetes.io/ssl-certificate" = "prometheus-tls"
      # "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = [
        var.domain
      ]
      secret_name = kubernetes_secret.prometheus_tls.metadata.0.name
    }
    rule {
      host = var.prometheus_domain
      http {
        path {
          backend {
            service {
              name = "prometheus"
              port {
                number = 80
              }
            }
          }
          # path = "/prometheus/?(.*)"
          # path = "/prometheus(/|$)(.*)"
          path      = "/"
          path_type = "Prefix"
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = var.grafana_release_name
    namespace = var.grafana_release_namespace
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
      secret_name = kubernetes_secret.grafana_tls.metadata.0.name
    }
    rule {
      host = var.grafana_domain
      http {
        path {
          backend {
            service {
              name = "grafana-server"
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

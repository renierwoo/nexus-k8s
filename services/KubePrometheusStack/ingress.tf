resource "kubernetes_ingress_v1" "kube_prometheus_stack" {
  metadata {
    name      = var.kps_release
    namespace = var.kps_namespace
    annotations = {
      # "nginx.ingress.kubernetes.io/ssl-certificate" = "grafana-tls"
      # "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
      # "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
      # "nginx.ingress.kubernetes.io/use-regex" = "true"
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
              name = "grafana"
              port {
                number = 80
              }
            }
          }
          # path = "/grafana/?(.*)"
          # path = "/grafana(/|$)(.*)"
          path      = "/"
          path_type = "Prefix"
        }
      }
    }
  }
}

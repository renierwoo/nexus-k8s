resource "kubernetes_deployment" "wireguard_deployment" {
  metadata {
    name      = "wireguard-server"
    namespace = var.tools_namespace_name
    labels = {
      app = "wireguard-server"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wireguard-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "wireguard-server"
        }
      }

      spec {
        security_context {
          run_as_non_root = true
          sysctl {
            name  = "net.ipv4.ip_forward"
            value = "1"
          }
        }

        container {
          name              = "wireguard-server"
          image             = "wootechspace/wireguard-server:1.0.1-alpine"
          image_pull_policy = "Always"

          security_context {
            capabilities {
              drop = ["ALL"]
              add  = ["NET_ADMIN", "NET_RAW"]
            }

            allow_privilege_escalation = false
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "256Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "64Mi"
            }
          }

          liveness_probe {
            exec {
              command = ["/bin/sh", "-c", "ip link show wg0"]
            }

            initial_delay_seconds = 5
            period_seconds        = 10
          }

          volume_mount {
            name       = "wireguard-server-config"
            mount_path = "/etc/wireguard"
            read_only  = true
          }

          env {
            name  = "TZ"
            value = "UTC"
          }

          env {
            name  = "PUID"
            value = "1000"
          }

          env {
            name  = "PGID"
            value = "1000"
          }

          port {
            container_port = var.wireguard_server["listen_port"]
            protocol       = "UDP"
          }
        }

        volume {
          name = "wireguard-server-config"

          secret {
            secret_name  = kubernetes_secret.wireguard_secrets.metadata[0].name
            default_mode = "0400"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.tools,
    kubernetes_secret.wireguard_secrets
  ]
}

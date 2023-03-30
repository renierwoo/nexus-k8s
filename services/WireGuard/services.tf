resource "kubernetes_service" "wireguard_service" {
  metadata {
    name      = "wireguard-server-service"
    namespace = var.tools_namespace_name
  }

  spec {
    selector = {
      app = "wireguard-server"
    }

    port {
      name        = "wireguard-server-service"
      port        = var.wireguard_server["listen_port"]
      target_port = var.wireguard_server["listen_port"]
      node_port   = var.wireguard_server["listen_port"]
      protocol    = "UDP"
    }

    type                    = "NodePort"
    external_traffic_policy = "Local"
  }

  depends_on = [
    kubernetes_namespace.tools,
    kubernetes_secret.wireguard_secrets
  ]
}

resource "kubernetes_secret" "wireguard_secrets" {
  metadata {
    name      = "wireguard-server-secrets"
    namespace = var.tools_namespace_name
  }

  data = {
    "wg0.conf" = <<-EOF
      [Interface]
      PrivateKey = ${var.wireguard_server["private_key"]}
      Address = ${var.wireguard_server["ip_address"]}
      DNS = ${var.wireguard_server["dns"]}
      MTU = ${var.wireguard_server["mtu"]}
      ListenPort = ${var.wireguard_server["listen_port"]}
      PostUp = ${var.wireguard_server["post_up"]}
      PostDown = ${var.wireguard_server["post_down"]}

      ${join("\n", [
        for wireguard-peer in var.wireguard_peers :
          "[Peer]\n# ${wireguard-peer.comment}\nPublicKey = ${wireguard-peer.public_key}\nAllowedIPs = ${wireguard-peer.allowed_ips}\n"
      ])}
    EOF
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.tools]
}

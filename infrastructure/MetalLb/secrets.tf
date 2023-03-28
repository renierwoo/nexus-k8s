resource "random_password" "metal_lb_memberlist" {
  length           = 128
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "metal_lb_memberlist" {
  metadata {
    name      = "metallb-memberlist"
    namespace = kubernetes_namespace.metal_lb.metadata[0].name
  }

  data = {
    secretkey = random_password.metal_lb_memberlist.result
  }
}

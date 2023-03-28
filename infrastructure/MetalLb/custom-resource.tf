resource "null_resource" "metallb_custom_resources" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {
    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
    }

    inline = [
      "echo Checking if the MetalLB CRDs are installed.",
      "if kubectl get crd | grep metallb; then",
        "echo MetalLB CRDs are installed.",
      "else",
        "echo MetalLB CRDs are not installed. Installing them now.",
        "cat <<EOF | kubectl apply -f -",
        templatefile(("${path.module}/artifacts/ipaddresspool.yaml"), { host = var.connection.host }),
        "EOF",
        "cat <<EOF | kubectl apply -f -",
        templatefile(("${path.module}/artifacts/l2advertisement.yaml"), { host = var.connection.host }),
        "EOF",
        "echo MetalLB CRDs installed.",
      "fi"
    ]
  }

  depends_on = [helm_release.metal_lb]
}

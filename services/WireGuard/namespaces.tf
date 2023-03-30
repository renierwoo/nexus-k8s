resource "kubernetes_namespace" "tools" {
  metadata {
    annotations = {
      name = var.tools_namespace_name
    }

    labels = {
      "kubernetes.io/metadata.name" = var.tools_namespace_name
    }

    name = var.tools_namespace_name
  }
}

resource "kubernetes_namespace" "metal_lb" {
  metadata {
    annotations = {
      name = var.metal_lb_annotation_name
    }

    labels = {
      "kubernetes.io/metadata.name" = var.metal_lb_label_k8s_name
    }

    name = var.metal_lb_namespace_name
  }
}

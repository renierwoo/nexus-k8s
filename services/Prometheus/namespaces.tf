resource "kubernetes_namespace" "prometheus" {
  metadata {
    annotations = {
      name = var.prometheus_annotation_name
    }

    labels = {
      "kubernetes.io/metadata.name" = var.prometheus_label_k8s_name
    }

    name = var.prometheus_namespace_name
  }
}

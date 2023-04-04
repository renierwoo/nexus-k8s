resource "kubernetes_namespace" "kube_prometheus_stack" {
  metadata {
    annotations = {
      name = var.kps_annotation
    }

    labels = {
      "kubernetes.io/metadata.name" = var.kps_label_k8s
    }

    name = var.kps_namespace
  }
}

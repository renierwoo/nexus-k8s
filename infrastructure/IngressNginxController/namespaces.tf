resource "kubernetes_namespace" "ingress_nginx_controller" {
  metadata {
    annotations = {
      name = var.nginx_ic_annotation_name
    }

    labels = {
      "kubernetes.io/metadata.name" = var.nginx_ic_label_k8s_name
    }

    name = var.nginx_ic_namespace_name
  }
}

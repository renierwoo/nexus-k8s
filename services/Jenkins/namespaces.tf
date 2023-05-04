resource "kubernetes_namespace_v1" "devops_tools" {
  metadata {
    annotations = {
      name = var.jenkins_controller_release_namespace
    }

    labels = {
      "kubernetes.io/metadata.name" = "${var.jenkins_controller_release_namespace}"
    }

    name = var.jenkins_controller_release_namespace
  }
}

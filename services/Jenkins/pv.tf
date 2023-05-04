resource "kubernetes_storage_class_v1" "jenkins_controller" {
  metadata {
    name      = "jenkins-controller-pv"
    namespace = var.jenkins_controller_release_namespace
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_persistent_volume_v1" "jenkins_controller" {
  metadata {
    name      = "jenkins-controller-pv"
    namespace = var.jenkins_controller_release_namespace
  }

  spec {
    storage_class_name = kubernetes_storage_class_v1.jenkins_controller.metadata.0.name

    capacity = {
      storage = "20Gi"
    }

    access_modes = ["ReadWriteOnce"]

    hostpath {
      path = "/mnt/jenkins-controller-volume"
    }

    persistent_volume_reclaim_policy = "Retain"
  }
}

resource "kubernetes_storage_class_v1" "jenkins_controller" {
  metadata {
    name = "jenkins-controller-pv"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_persistent_volume_v1" "jenkins_controller" {
  metadata {
    name = "jenkins-controller-pv"

    labels = {
      type = "local"
    }
  }

  spec {
    storage_class_name = kubernetes_storage_class_v1.jenkins_controller.metadata.0.name

    capacity = {
      storage = "20Gi"
    }

    access_modes = ["ReadWriteOnce"]

    persistent_volume_source {
      host_path {
        path = "/mnt/jenkins-controller-volume"
      }
    }

    persistent_volume_reclaim_policy = "Retain"
  }
}

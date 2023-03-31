resource "kubernetes_persistent_volume_v1" "prometheus" {
  metadata {
    name = "prometheus-pv"
  }

  spec {
    storage_class_name = kubernetes_storage_class.prometheus.metadata[0].name
    capacity = {
      storage = "10Gi"
    }

    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      local {
        path = "/mnt/data/prometheus"
      }
    }

    volume_mode = "Filesystem"
  }
}

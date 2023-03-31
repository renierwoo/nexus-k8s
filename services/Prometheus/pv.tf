resource "kubernetes_persistent_volume_v1" "prometheus" {
  metadata {
    name = var.prometheus_peristent_volume_name
  }

  spec {
    storage_class_name = kubernetes_storage_class.prometheus.metadata[0].name
    capacity = {
      storage = "20Gi"
    }

    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      local {
        path = "/mnt"
      }
    }

    volume_mode = "Filesystem"

    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = [var.node_name]
          }
        }
      }
    }
  }
}

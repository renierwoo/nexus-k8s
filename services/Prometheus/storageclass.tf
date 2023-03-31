resource "kubernetes_storage_class" "prometheus" {
  metadata {
    name = var.prometheus_server_storageClass
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type                   = "ext4"
    fstype                 = "ext4"
    blockSize              = "4096"
    dataBlockAllocType     = "zeroed"
    metadataBlockAllocType = "zeroed"
  }

  reclaim_policy         = "Retain"
  allow_volume_expansion = true
}

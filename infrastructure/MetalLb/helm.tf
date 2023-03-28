resource "helm_release" "metal_lb" {
  name        = var.metal_lb_release_name
  repository  = var.metal_lb_repository
  chart       = var.metal_lb_chart
  version     = var.metal_lb_chart_version
  namespace   = var.metal_lb_release_namespace
  description = "MetalLB network load-balancer implementation for Kubernetes"

  set {
    name  = "controller.image.tag"
    value = var.metal_lb_controller_image_tag
  }
}

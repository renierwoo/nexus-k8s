module "Setup" {
  source = "./infrastructure/Setup"

  hostname = var.hostname
  domain   = var.domain

  connection  = var.connection
  private_key = var.private_key
}

module "Kubeadm" {
  source = "./infrastructure/Kubeadm"

  connection  = var.connection
  private_key = var.private_key

  depends_on = [module.Setup]
}

module "Calico" {
  source = "./infrastructure/Calico"

  connection  = var.connection
  private_key = var.private_key

  depends_on = [module.Kubeadm]
}

module "metal_lb" {
  source = "./infrastructure/MetalLb"

  metal_lb_release_name      = var.metal_lb_release_name
  metal_lb_repository        = var.metal_lb_repository
  metal_lb_chart             = var.metal_lb_chart
  metal_lb_chart_version     = var.metal_lb_chart_version
  metal_lb_release_namespace = var.metal_lb_release_namespace

  metal_lb_annotation_name = var.metal_lb_annotation_name
  metal_lb_label_k8s_name  = var.metal_lb_label_k8s_name
  metal_lb_namespace_name  = var.metal_lb_namespace_name

  metal_lb_controller_image_tag = var.metal_lb_controller_image_tag

  connection  = var.connection
  private_key = var.private_key
}

module "IngressNginxController" {
  source = "./infrastructure/IngressNginxController"

  nginx_ic_name_override     = var.nginx_ic_name_override
  nginx_ic_release_name      = var.nginx_ic_release_name
  nginx_ic_repository        = var.nginx_ic_repository
  nginx_ic_chart             = var.nginx_ic_chart
  nginx_ic_chart_version     = var.nginx_ic_chart_version
  nginx_ic_release_namespace = var.nginx_ic_release_namespace

  nginx_ic_annotation_name = var.nginx_ic_annotation_name
  nginx_ic_label_k8s_name  = var.nginx_ic_label_k8s_name
  nginx_ic_namespace_name  = var.nginx_ic_namespace_name

  nginx_ic_controller_kind                          = var.nginx_ic_controller_kind
  nginx_ic_controller_image_tag                     = var.nginx_ic_controller_image_tag
  nginx_ic_controller_replicaCount                  = var.nginx_ic_controller_replicaCount
  nginx_ic_controller_terminationGracePeriodSeconds = var.nginx_ic_controller_terminationGracePeriodSeconds
  nginx_ic_controller_enableLatencyMetrics          = var.nginx_ic_controller_enableLatencyMetrics
  nginx_ic_prometheus_create                        = var.nginx_ic_prometheus_create
  nginx_ic_prometheus_port                          = var.nginx_ic_prometheus_port
  nginx_ic_prometheus_scheme                        = var.nginx_ic_prometheus_scheme
}

module "Prometheus" {
  source = "./services/Prometheus"

  prometheus_release_name      = var.prometheus_release_name
  prometheus_repository        = var.prometheus_repository
  prometheus_chart             = var.prometheus_chart
  prometheus_chart_version     = var.prometheus_chart_version
  prometheus_release_namespace = var.prometheus_release_namespace

  prometheus_annotation_name = var.prometheus_annotation_name
  prometheus_label_k8s_name  = var.prometheus_label_k8s_name
  prometheus_namespace_name  = var.prometheus_namespace_name

  prometheus_server_image_tag = var.prometheus_server_image_tag

  domain            = var.domain
  prometheus_domain = var.prometheus_domain
  domain_tls_key    = var.domain_tls_key
  domain_tls_crt   = var.domain_tls_crt
}

module "WireGuard" {
  source = "./services/WireGuard"

  tools_namespace_name = var.tools_namespace_name
  wireguard_server     = var.wireguard_server
  wireguard_peers      = var.wireguard_peers

  domain           = var.domain
  wireguard_domain = var.wireguard_domain
}

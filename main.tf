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

  depends_on = [module.Calico]
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

  nginx_ic_controller_kind      = var.nginx_ic_controller_kind
  nginx_ic_controller_image_tag = var.nginx_ic_controller_image_tag
  nginx_ic_metrics_enabled      = var.nginx_ic_metrics_enabled

  nginx_ic_controller_mirror_registry        = var.nginx_ic_controller_mirror_registry
  nginx_ic_controller_image                  = var.nginx_ic_controller_image
  nginx_ic_controller_digest                 = var.nginx_ic_controller_digest
  nginx_ic_admissionWebhooks_mirror_registry = var.nginx_ic_admissionWebhooks_mirror_registry
  nginx_ic_admissionWebhooks_image           = var.nginx_ic_admissionWebhooks_image
  nginx_ic_admissionWebhooks_digest          = var.nginx_ic_admissionWebhooks_digest

  depends_on = [module.metal_lb]
}

# module "KubePrometheusStack" {
#   source = "./services/KubePrometheusStack"

#   kps_annotation = var.kps_annotation
#   kps_label_k8s  = var.kps_label_k8s
#   kps_namespace  = var.kps_namespace

#   kps_release           = var.kps_release
#   kps_repository        = var.kps_repository
#   kps_chart             = var.kps_chart
#   kps_chart_version     = var.kps_chart_version
#   kps_release_namespace = var.kps_release_namespace

#   domain             = var.domain
#   grafana_domain     = var.grafana_domain
#   grafana_admin_user = var.grafana_admin_user
#   domain_tls_key     = var.domain_tls_key
#   domain_tls_crt     = var.domain_tls_crt

#   depends_on = [module.IngressNginxController]
# }

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
  domain_tls_crt    = var.domain_tls_crt

  depends_on = [module.IngressNginxController]
}

module "Grafana" {
  source = "./services/Grafana"

  grafana_release_name      = var.grafana_release_name
  grafana_repository        = var.grafana_repository
  grafana_chart             = var.grafana_chart
  grafana_chart_version     = var.grafana_chart_version
  grafana_release_namespace = var.grafana_release_namespace

  grafana_server_image_tag = var.grafana_server_image_tag

  domain             = var.domain
  grafana_domain     = var.grafana_domain
  grafana_admin_user = var.grafana_admin_user
  # grafana_csp_policy = var.grafana_csp_policy
  domain_tls_key = var.domain_tls_key
  domain_tls_crt = var.domain_tls_crt

  depends_on = [module.Prometheus]
}

module "WireGuard" {
  source = "./services/WireGuard"

  tools_namespace_name = var.tools_namespace_name
  wireguard_server     = var.wireguard_server
  wireguard_peers      = var.wireguard_peers

  domain           = var.domain
  wireguard_domain = var.wireguard_domain

  depends_on = [module.IngressNginxController]
}

module "Jenkins" {
  source = "./services/Jenkins"

  domain                               = var.domain
  jenkins_controller_domain            = var.jenkins_controller_domain
  domain_tls_key                       = var.domain_tls_key
  domain_tls_crt                       = var.domain_tls_crt
  jenkins_controller_release_name      = var.jenkins_controller_release_name
  jenkins_controller_repository        = var.jenkins_controller_repository
  jenkins_controller_chart             = var.jenkins_controller_chart
  jenkins_controller_chart_version     = var.jenkins_controller_chart_version
  jenkins_controller_release_namespace = var.jenkins_controller_release_namespace
  jenkins_controller_image_tag         = var.jenkins_controller_image_tag
  jenkins_controller_admin_user        = var.jenkins_controller_admin_user
  jenkins_controller_admin_password    = var.jenkins_controller_admin_password

  depends_on = [module.IngressNginxController]
}

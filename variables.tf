variable "connection" {
  sensitive = true
  type = object({
    host = string
    type = string
    user = string
    # private_key = string
  })
  description = "The connection information for the remote-exec provisioners."
}

variable "private_key" {
  type        = string
  description = "The SSH private key used for connecting to the VPS"
  sensitive   = true
}

variable "domain" {
  type        = string
  description = "The domain use for services on the VPS"
}

variable "grafana_domain" {
  type        = string
  description = "The domain use for grafana service"
}

variable "hostname" {
  type        = string
  description = "The hostname of the VPS"
}

##############################
### Kubeconfig's variables ###
##############################
# # Config for Terraform Local
# variable "kubeconfig_path" {
#   type        = string
#   # default     = "~/.kube/config"
#   description = "Location of the kubeconfig file belonging to the Kubernetes API server."
#   sensitive   = true
# }

# variable "kubeconfig_context" {
#   type        = string
#   description = "Context to choose from the kubeconfig file belonging to the Kubernetes API server."
# }

# variable "kubeconfig_cluster" {
#   type        = string
#   description = "Cluster name to choose from the kubeconfig file belonging to the Kubernetes API server."
# }

# variable "kubeconfig_user" {
#   type        = string
#   description = "User name to choose from the kubeconfig file belonging to the Kubernetes API server."
# }

# Config for Terraform Cloud
variable "host" {
  type        = string
  description = "The hostname (in form of URI) of the Kubernetes API."
  sensitive   = true
}

variable "client_certificate" {
  type        = string
  description = "PEM-encoded client certificate for TLS authentication."
  sensitive   = true
}

variable "client_key" {
  type        = string
  description = "PEM-encoded client certificate key for TLS authentication."
  sensitive   = true
}

variable "cluster_ca_certificate" {
  type        = string
  description = "PEM-encoded root certificates bundle for TLS authentication."
  sensitive   = true
}

# variable "config_context" {
#   type        = string
#   description = "Context to choose from the config file."
#   sensitive   = true
# }

# variable "config_context_auth_info" {
#   type        = string
#   description = "Authentication info context of the kube config (name of the kubeconfig user, --user flag in kubectl)."
#   sensitive   = true
# }

# variable "config_context_cluster" {
#   type        = string
#   description = "Cluster context of the kube config (name of the kubeconfig cluster, --cluster flag in kubectl)."
#   sensitive   = true
# }

#########################
### MetalLB variables ###
#########################

variable "metal_lb_annotation_name" {}

variable "metal_lb_label_k8s_name" {}

variable "metal_lb_namespace_name" {}

variable "metal_lb_release_name" {}

variable "metal_lb_repository" {}

variable "metal_lb_chart" {}

variable "metal_lb_chart_version" {}

variable "metal_lb_release_namespace" {}

variable "metal_lb_controller_image_tag" {}

#####################################################
### Kubernetes NGINX Ingress Controller variables ###
#####################################################

variable "nginx_ic_annotation_name" {}

variable "nginx_ic_label_k8s_name" {}

variable "nginx_ic_namespace_name" {}

variable "nginx_ic_name_override" {}

variable "nginx_ic_release_name" {}

variable "nginx_ic_repository" {}

variable "nginx_ic_chart" {}

variable "nginx_ic_chart_version" {}

variable "nginx_ic_release_namespace" {}

variable "nginx_ic_controller_kind" {}

variable "nginx_ic_controller_image_tag" {}

variable "nginx_ic_controller_replicaCount" {}

variable "nginx_ic_controller_terminationGracePeriodSeconds" {}

variable "nginx_ic_controller_enableLatencyMetrics" {}

variable "nginx_ic_prometheus_create" {}

variable "nginx_ic_prometheus_port" {}

variable "nginx_ic_prometheus_scheme" {}

############################
### Prometheus variables ###
############################

variable "prometheus_annotation_name" {}

variable "prometheus_label_k8s_name" {}

variable "prometheus_namespace_name" {}

variable "prometheus_release_name" {}

variable "prometheus_repository" {}

variable "prometheus_chart" {}

variable "prometheus_chart_version" {}

variable "prometheus_release_namespace" {}

variable "prometheus_server_image_tag" {}

variable "prometheus_server_storageClass" {}

variable "prometheus_domain" {}

variable "domain_tls_key" {}

variable "domain_tls_crt" {}

###########################
### WireGuard variables ###
###########################

variable "tools_namespace_name" {}

variable "wireguard_server" {}

variable "wireguard_peers" {}

variable "wireguard_domain" {}

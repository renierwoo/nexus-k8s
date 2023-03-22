#################################################################
### Kubernetes NGINX Ingress Controller Namespace's variables ###
#################################################################

variable "nginx_ic_annotation_name" {
  type        = string
  default     = "ingress-nginx"
  description = "Metadata namespace annotations."
}

variable "nginx_ic_label_k8s_name" {
  type        = string
  default     = "ingress-nginx"
  description = "Metadata namespace labels."
}

variable "nginx_ic_namespace_name" {
  type        = string
  default     = "ingress-nginx"
  description = "Metadata namespace name."
}

##################################################################
### Kubernetes NGINX Ingress Controller Helm Chart's variables ###
##################################################################

variable "nginx_ic_name_override" {
  type        = string
  description = "Name Override."
}

variable "nginx_ic_release_name" {
  type        = string
  description = "Release name."
}

variable "nginx_ic_repository" {
  type        = string
  default     = "https://kubernetes.github.io/ingress-nginx"
  description = "Repository URL where to locate the requested chart."
}

variable "nginx_ic_chart" {
  type        = string
  description = "Chart name to be installed."
}

variable "nginx_ic_chart_version" {
  type        = string
  description = "Specify the exact chart version to install."
}

variable "nginx_ic_release_namespace" {
  type        = string
  default     = "default"
  description = "The namespace to install the release into."
}

variable "nginx_ic_controller_kind" {
  type        = string
  default     = "deployment"
  description = "The kind of the Ingress Controller installation - deployment or daemonset."
}

variable "nginx_ic_controller_image_tag" {
  type        = string
  description = "The tag of the Ingress Controller image."
}

variable "nginx_ic_controller_replicaCount" {
  type        = string
  default     = "1"
  description = "The number of replicas of the Ingress Controller deployment."
}

variable "nginx_ic_controller_terminationGracePeriodSeconds" {
  type        = string
  default     = "30"
  description = "The termination grace period of the Ingress Controller pod."
}

variable "nginx_ic_controller_enableLatencyMetrics" {
  type        = string
  default     = "false"
  description = "Enable collection of latency metrics for upstreams. Requires prometheus.create."
}

variable "nginx_ic_prometheus_create" {
  type        = string
  default     = "false"
  description = "Expose NGINX or NGINX Plus metrics in the Prometheus format."
}

variable "nginx_ic_prometheus_port" {
  type        = string
  default     = "10254"
  description = "Configures the port to scrape the metrics."
}

variable "nginx_ic_prometheus_scheme" {
  type        = string
  default     = "http"
  description = "Configures the HTTP scheme to use for connections to the Prometheus endpoint."
}

###################################################
### Kube Prometheus Stack Namespace's variables ###
###################################################

variable "kps_annotation" {
  type        = string
  default     = "monitoring"
  description = "Metadata namespace annotations."
}

variable "kps_label_k8s" {
  type        = string
  default     = "monitoring"
  description = "Metadata namespace labels."
}

variable "kps_namespace" {
  type        = string
  default     = "monitoring"
  description = "Metadata namespace name."
}

####################################################
### Kube Prometheus Stack Helm Chart's variables ###
####################################################

variable "kps_release" {
  type        = string
  description = "Release name."
}

variable "kps_repository" {
  type        = string
  description = "Repository URL where to locate the requested chart."
}

variable "kps_chart" {
  type        = string
  description = "Chart name to be installed."
}

variable "kps_chart_version" {
  type        = string
  description = "Specify the exact chart version to install."
}

variable "kps_release_namespace" {
  type        = string
  description = "The namespace to install the release into."
}

variable "domain" {
  type        = string
  description = "The domain for the naked site."
}

variable "grafana_domain" {
  type        = string
  description = "The domain for the grafana site."
}

variable "grafana_admin_user" {
  type        = string
  sensitive   = true
  description = "The grafana admin user."
}

variable "domain_tls_key" {
  type        = string
  sensitive   = true
  description = "The domain tls key."
}

variable "domain_tls_crt" {
  type        = string
  sensitive   = true
  description = "The domain tls certificate."
}

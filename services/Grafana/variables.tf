##################################
# Grafana Helm Chart's variables #
##################################

variable "grafana_release_name" {
  type        = string
  description = "Release name."
}

variable "grafana_repository" {
  type        = string
  description = "Repository URL where to locate the requested chart."
}

variable "grafana_chart" {
  type        = string
  description = "Chart name to be installed."
}

variable "grafana_chart_version" {
  type        = string
  description = "Specify the exact chart version to install."
}

variable "grafana_release_namespace" {
  type        = string
  description = "The namespace to install the release into."
}

variable "grafana_server_image_tag" {
  type        = string
  description = "The tag of the Prometheus image."
}

variable "domain" {
  type        = string
  description = "The domain for the naked site."
}

variable "grafana_domain" {
  type        = string
  description = "The domain for the grafana site."
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

variable "grafana_admin_user" {
  type        = string
  sensitive   = true
  description = "The grafana admin user."
}

variable "grafana_csp_policy" {
  type        = string
  description = "The Grafana content security policy."
}

####################################
# Prometheus Namespace's variables #
####################################

variable "prometheus_annotation_name" {
  type        = string
  default     = "monitoring"
  description = "Metadata namespace annotations."
}

variable "prometheus_label_k8s_name" {
  type        = string
  default     = "monitoring"
  description = "Metadata namespace labels."
}

variable "prometheus_namespace_name" {
  type        = string
  default     = "monitoring"
  description = "Metadata namespace name."
}

#####################################
# Prometheus Helm Chart's variables #
#####################################

variable "prometheus_release_name" {
  type        = string
  description = "Release name."
}

variable "prometheus_repository" {
  type        = string
  description = "Repository URL where to locate the requested chart."
}

variable "prometheus_chart" {
  type        = string
  description = "Chart name to be installed."
}

variable "prometheus_chart_version" {
  type        = string
  description = "Specify the exact chart version to install."
}

variable "prometheus_release_namespace" {
  type        = string
  description = "The namespace to install the release into."
}

variable "prometheus_server_image_tag" {
  type        = string
  description = "The tag of the Prometheus image."
}

variable "domain" {
  type        = string
  description = "The domain for the naked site."
}

variable "prometheus_domain" {
  type        = string
  description = "The domain for the prometheus site."
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

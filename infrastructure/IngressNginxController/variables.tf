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

variable "nginx_ic_controller_mirror_registry" {
  type        = string
  description = "The mirror registry of the Ingress Controller image."
}

variable "nginx_ic_controller_image" {
  type        = string
  description = "The name of the Ingress Controller image."
}

variable "nginx_ic_controller_digest" {
  type        = string
  description = "The digest of the Ingress Controller image."
}

variable "nginx_ic_metrics_enabled" {
  type        = string
  default     = "false"
  description = "Expose NGINX metrics in the Prometheus format."
}

variable "nginx_ic_admissionWebhooks_mirror_registry" {
  type        = string
  default     = "false"
  description = "The mirror registry of the admissionWebhooks image."
}

variable "nginx_ic_admissionWebhooks_image" {
  type        = string
  default     = "false"
  description = "The name of the admissionWebhooks image."
}

variable "nginx_ic_admissionWebhooks_digest" {
  type        = string
  default     = "false"
  description = "The digest of the admissionWebhooks image."
}

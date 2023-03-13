variable "connection" {}

#####################################
### MetalLB Namespace's variables ###
#####################################

variable "metal_lb_annotation_name" {
  type        = string
  default     = "metallb-system"
  description = "Metadata namespace annotations."
}

variable "metal_lb_label_k8s_name" {
  type        = string
  default     = "metallb-system"
  description = "Metadata namespace labels."
}

variable "metal_lb_namespace_name" {
  type        = string
  default     = "metallb-system"
  description = "Metadata namespace name."
}

######################################
### MetalLB Helm Chart's variables ###
######################################

variable "metal_lb_release_name" {
  type        = string
  description = "Release name."
}

variable "metal_lb_repository" {
  type        = string
  description = "Repository URL where to locate the requested chart."
}

variable "metal_lb_chart" {
  type        = string
  description = "Chart name to be installed."
}

variable "metal_lb_chart_version" {
  type        = string
  description = "Specify the exact chart version to install."
}

variable "metal_lb_release_namespace" {
  type        = string
  description = "The namespace to install the release into."
}

variable "metal_lb_controller_image_tag" {
  type        = string
  description = "The tag of the Ingress Controller image."
}

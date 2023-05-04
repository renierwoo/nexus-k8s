variable "domain" {
  type        = string
  description = "The domain for the naked site."
}

variable "jenkins_controller_domain" {
  type        = string
  description = "The domain for the Jenkins site."
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

variable "jenkins_controller_release_name" {
  type        = string
  sensitive   = true
  description = "Release name."
}

variable "jenkins_controller_repository" {
  type        = string
  sensitive   = true
  description = "Repository URL where to locate the requested chart."
}

variable "jenkins_controller_chart" {
  type        = string
  sensitive   = true
  description = "Chart name to be installed."
}

variable "jenkins_controller_chart_version" {
  type        = string
  sensitive   = true
  description = "Specify the exact chart version to install."
}

variable "jenkins_controller_release_namespace" {
  type        = string
  sensitive   = true
  description = "The namespace to install the release into."
}

variable "jenkins_controller_image_tag" {
  type        = string
  sensitive   = true
  description = "The tag of the Jenkins Controller image."
}

variable "jenkins_controller_admin_user" {
  type        = string
  sensitive   = true
  description = "The Jenkins Controller admin user."
}

variable "jenkins_controller_admin_password" {
  type        = string
  sensitive   = true
  description = "The Jenkins Controller admin password."
}

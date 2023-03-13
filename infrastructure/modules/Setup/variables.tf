variable "connection" {}

variable "hostname" {
  type        = string
  description = "The hostname of the VPS"
}

variable "domain" {
  type        = string
  description = "The domain use for services on the VPS"
}

variable "old_package_versions" {
  type = list(string)
  default = [
    "docker",
    "docker-engine",
    "docker.io",
    "containerd",
    "runc"
  ]
  description = "Old packages to remove from the system"
}

variable "packages_apt_https" {
  type = list(string)
  default = [
    "ca-certificates",
    "curl",
    "gnupg",
    "lsb-release"
  ]
  description = "Packages to rallow apt to use a repository over HTTPS"
}

variable "packages_for_docker" {
  type = list(string)
  default = [
    "docker-ce",
    "docker-ce-cli",
    "containerd.io",
    "docker-buildx-plugin",
    "docker-compose-plugin"
  ]
  description = "Required packages for Docker Engine"
}

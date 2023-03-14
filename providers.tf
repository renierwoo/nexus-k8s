##########################
### Required providers ###
##########################

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

###########################
### Provider's settings ###
###########################

provider "null" {
  # Configuration options
}

provider "kubernetes" {
  host                     = var.host
  client_certificate       = base64decode(var.client_certificate)
  client_key               = base64decode(var.client_key)
  cluster_ca_certificate   = base64decode(var.cluster_ca_certificate)
  # config_context           = var.config_context
  # config_context_auth_info = var.config_context_auth_info
  # config_context_cluster   = var.config_context_cluster
  # config_path              = var.kubeconfig_path
  # config_context           = var.kubeconfig_context
  # config_context_cluster   = var.kubeconfig_cluster
  # config_context_auth_info = var.kubeconfig_user
}

provider "helm" {
  kubernetes {
    host                     = var.host
    client_certificate       = base64decode(var.client_certificate)
    client_key               = base64decode(var.client_key)
    cluster_ca_certificate   = base64decode(var.cluster_ca_certificate)
    # config_context           = var.config_context
    # config_context_auth_info = var.config_context_auth_info
    # config_context_cluster   = var.config_context_cluster
    # config_path    = var.kubeconfig_path
    # config_context = var.kubeconfig_context
  }
}

provider "kubectl" {
  host                     = var.host
  client_certificate       = base64decode(var.client_certificate)
  client_key               = base64decode(var.client_key)
  cluster_ca_certificate   = base64decode(var.cluster_ca_certificate)
  # config_context           = var.config_context
  # config_context_auth_info = var.config_context_auth_info
  # config_context_cluster   = var.config_context_cluster
  # config_path              = var.kubeconfig_path
  # config_context           = var.kubeconfig_context
  # config_context_cluster   = var.kubeconfig_cluster
  # config_context_auth_info = var.kubeconfig_user
}

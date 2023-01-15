terraform {
  required_providers {
    contabo = {
      source  = "contabo/contabo"
      version = ">= 0.1.17"
    }
  }
}

provider "contabo" {
  oauth2_client_id     = var.client_id
  oauth2_client_secret = var.client_secret
  oauth2_user          = var.username
  oauth2_pass          = var.password
}
terraform {
  required_version = ">= 1.8.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6.12"
    }
    # kubernetes = {
    #   source = "hashicorp/kubernetes"
    #   version = "~>2.35.1"
    # }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.19.0"
    }
  }
}

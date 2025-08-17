terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "YOUR_ORG"
    workspaces { name = "gke-iac-v1" }
  }

  backend "local" {
    path = "terraform.tfstate"
  }

  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
  }
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("${path.module}/orbital-hawk-415317-d91c6087b44a.json")
  project     = var.project_id
  region      = "europe-west4"
  zone        = "europe-west4-a"
}

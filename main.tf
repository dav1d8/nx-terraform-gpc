terraform {
  backend "gcs" {
    bucket = "terraform-state-345678976543"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.60.2"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_service_account" "default" {
  account_id   = "service-account-id-nx"
  display_name = "Service Account (nx)"
}

resource "google_container_cluster" "primary" {
  name     = "nx-cluster"
  location = var.region

  initial_node_count       = 1
  remove_default_node_pool = true
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "nx-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_locations = [var.zone]

  node_config {
    machine_type = "e2-small"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    disk_size_gb = 16
  }
}
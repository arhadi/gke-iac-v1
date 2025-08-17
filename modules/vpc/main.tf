resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "gke_primary" {
  name          = "${var.network_name}-primary-${var.region}"
  ip_cidr_range = var.primary_cidr
  network       = google_compute_network.vpc.id
  region        = var.region
  project       = var.project_id

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.services_cidr
  }
}
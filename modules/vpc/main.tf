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
  range_name    = "gke-pods"
  ip_cidr_range = "10.10.32.0/19"
}

secondary_ip_range {
  range_name    = "gke-services"
  ip_cidr_range = "10.10.64.0/22"
}
}
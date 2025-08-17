resource "google_container_cluster" "autopilot" {
  name             = var.cluster_name
  location         = var.region
  project          = var.project_id
  enable_autopilot = true

  network    = var.network
  subnetwork = var.subnetwork

  release_channel {
    channel = var.release_channel
  }

  ip_allocation_policy {
    services_secondary_range_name = var.services_range_name
    cluster_secondary_range_name  = var.pods_range_name
  }
}


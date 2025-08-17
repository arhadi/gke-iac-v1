output "network_self_link" { value = google_compute_network.vpc.self_link }
output "subnet_name" { value = google_compute_subnetwork.gke_primary.name }
output "pods_range_name" { value = "pods-range" }
output "services_range_name" { value = "services-range" }

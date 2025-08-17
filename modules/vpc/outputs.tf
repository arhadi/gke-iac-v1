output "vpc_id" {
  description = "The ID of the VPC"
  value       = google_compute_network.vpc.id
}

output "subnet_id" {
  description = "The ID of the primary GKE subnet"
  value       = google_compute_subnetwork.gke_primary.id
}

output "pods_range_name" {
  description = "The name of the secondary IP range for GKE Pods"
  value       = google_compute_subnetwork.gke_primary.secondary_ip_range[0].range_name
}

output "services_range_name" {
  description = "The name of the secondary IP range for GKE Services"
  value       = google_compute_subnetwork.gke_primary.secondary_ip_range[1].range_name
}

output "name" {
  description = "The name of the VPC"
  value       = google_compute_network.vpc.name
}

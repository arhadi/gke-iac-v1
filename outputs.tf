output "vpc_name" {
  description = "The name of the created VPC"
  value       = module.vpc.name
}

output "gke_cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = module.gke.endpoint
}

output "project_id" {
  description = "The project id"
  value       = var.project_id
}
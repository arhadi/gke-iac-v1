variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "network" {
  type        = string
  description = "The VPC network ID where GKE will run"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork ID where GKE will run"
}

variable "pods_range_name" {
  type        = string
  description = "Secondary IP range name for pods"
}

variable "services_range_name" {
  type        = string
  description = "Secondary IP range name for services"
}

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "Region for the GKE cluster"
}

variable "release_channel" {
  type        = string
  description = "Release channel for GKE (e.g. RAPID, REGULAR, STABLE)"
  default     = "REGULAR"
}

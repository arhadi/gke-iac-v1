variable "project_id" { type = string }
variable "region" { type = string default = "asia-southeast2" }
variable "network_name" { type = string default = "vpc-gke-prod-01" }
variable "credentials_json" { type = string sensitive = true }
variable "cluster_name" { type = string default = "gke-prod-autopilot-01" }
variable "primary_cidr" { type = string default = "10.10.10.0/24" }
variable "pods_cidr" { type = string default = "10.10.100.0/20" }
variable "services_cidr" { 
    type = string 
    default = "10.10.200.0/24" 
    }

module "vpc" {
  source       = "./modules/vpc"
  project_id   = var.project_id
  network_name = var.network_name
  region       = var.region

  primary_cidr   = var.primary_cidr
  pods_cidr      = var.pods_cidr
  services_cidr  = var.services_cidr
}

module "gke" {
  source       = "./modules/gke"
  project_id   = var.project_id
  region       = var.region

  cluster_name = var.cluster_name
  network      = module.vpc.network_self_link
  subnetwork   = module.vpc.subnet_name

  pods_range_name     = module.vpc.pods_range_name
  services_range_name = module.vpc.services_range_name
}
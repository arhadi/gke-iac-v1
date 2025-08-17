module "gke" {
  source = "./modules/gke"

  project_id          = var.project_id
  region              = var.region
  cluster_name        = var.cluster_name
  release_channel     = var.release_channel

  network             = module.vpc.vpc_id
  subnetwork          = module.vpc.subnet_id
  pods_range_name     = module.vpc.pods_range_name
  services_range_name = module.vpc.services_range_name
}

module "vpc" {
  source     = "./modules/vpc"
  project_id = var.project_id
  region     = var.region

  network_name  = var.network_name
  primary_cidr  = var.primary_cidr
  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr
}
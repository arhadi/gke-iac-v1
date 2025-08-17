variable "project_id" { type = string }
resource "google_project_service" "enable" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com"
  ])
  project             = var.project_id
  service             = each.key
  disable_on_destroy  = false
}
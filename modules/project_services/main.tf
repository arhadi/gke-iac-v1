variable "project_id" { type = string }

resource "google_project_service" "enable" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com"
  ])
  project = var.project_id
  service = each.value
}
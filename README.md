# gke-iac-v1

GKE IaC v1
=======

Infrastructure-as-Code (IaC) for a **GKE Autopilot** cluster on a **custom VPC** using **Terraform Cloud/Enterprise (TFE)** (or local Terraform).

## What this project does

- Enables required GCP APIs (Compute, Container, IAM, Service Usage)
- Creates a **custom VPC** and a **regional GKE-ready subnet** with **secondary ranges** for Pods/Services
- Deploys a **GKE Autopilot** cluster attached to that network
- Designed to run on **Terraform Cloud/Enterprise** with a remote backend (configurable)

```
modules/
├─ project_services/     # enable GCP APIs
├─ vpc/                  # VPC + subnetwork + secondary ranges
└─ gke/                  # Autopilot GKE cluster
```

---

## Prerequisites

1) **GCP project**: create or choose one (example `gke-iac-v1`) and link billing.
2) **Service Account for Terraform** (recommended name: `terraform@<project-id>.iam.gserviceaccount.com`)
   ```bash
   gcloud iam service-accounts create terraform      --description="Terraform automation SA"      --display-name="Terraform"
   ```
3) **Roles** *(for lab ease, Owner; for prod, least-privilege)*
   - Quick path (lab/dev):
     ```bash
     gcloud projects add-iam-policy-binding <project-id>        --member="serviceAccount:terraform@<project-id>.iam.gserviceaccount.com"        --role="roles/owner"
     ```
   - Least-privilege combo:
     - roles/compute.networkAdmin
     - roles/container.admin
     - roles/serviceusage.serviceUsageAdmin
     - roles/iam.serviceAccountUser
4) **Service Account key** (JSON):
   ```bash
   gcloud iam service-accounts keys create terraform-key.json      --iam-account terraform@<project-id>.iam.gserviceaccount.com
   ```

> **Security tip:** Prefer short-lived workload identity or OIDC where possible. Treat the JSON key as a secret.

---

## Using Terraform Cloud / Enterprise (recommended)

This repo is pre-wired for a **remote backend** in `backend.tf`:

```hcl
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"   # change to your TFE hostname if self-hosted
    organization = "YOUR_ORG"
    workspaces { name = "gke-iac-v1" }
  }
}
```

### 1) Create a workspace in TFC/TFE
- Organization: `YOUR_ORG`
- Workspace: `gke-iac-v1`

### 2) Set workspace variables
Set the following (Workspace → Variables):

- Terraform variables (plain):
  - `project_id` = your GCP project id (e.g., `gke-iac-v1`)
  - `region`     = your region (e.g., `asia-southeast2`)
  - (optional) adjust `network_name`, CIDRs, and `cluster_name`

- Terraform variable (sensitive):
  - `credentials_json` = **contents** of your `terraform-key.json` (paste the entire JSON)

No environment variables are required if you set `credentials_json` above.

### 3) Connect VCS or Upload
- Connect this repo to the workspace, or upload the configuration

### 4) Run
- Queue a **Plan**, review the changes
- **Apply** to create:
  - enabled APIs
  - VPC + subnetwork with secondary ranges
  - GKE Autopilot cluster

### 5) Accessing the cluster
- Fetch credentials (local machine with gcloud installed):
  ```bash
  gcloud container clusters get-credentials gke-prod-autopilot-01     --region=$(terraform output -raw region 2>/dev/null || echo "asia-southeast2")     --project=<project-id>
  kubectl get nodes
  ```
  > You can also read the endpoint output from the workspace run or `modules/gke` outputs.

---

## Running locally (alternative)

If you don’t want to use TFE for testing:

1) Export credentials:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/absolute/path/terraform-key.json"
   ```

2) Copy `terraform.tfvars.example` to `terraform.tfvars` and edit values:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3) Init & apply:
   ```bash
   terraform init
   terraform plan -out tfplan
   terraform apply tfplan
   ```

---

## Network & IP plan (defaults)

- VPC name: `vpc-gke-prod-01`
- Region: `asia-southeast2` (changeable)
- Subnets inside `10.10.0.0/16`:
  - Primary subnet: `10.10.10.0/24`
  - Pods secondary range: `10.10.100.0/20`
  - Services secondary range: `10.10.200.0/24`

You can change these via variables in `variables.tf` or your `terraform.tfvars`.

---

## Deleting the default VPC (optional)

Terraform cannot delete already-existing default resources unless imported. Use one of:
- **Import then destroy** (see `modules/defaults/README.md` template we shared earlier), or
- One-time **gcloud helper** on your workstation/runner:
  ```bash
  gcloud compute firewall-rules delete default-allow-ssh default-allow-rdp default-allow-icmp --quiet || true
  gcloud compute networks delete default --quiet || true
  ```

Ensure your custom VPC and routes exist before removing the default VPC.

---

## Files of note

- `backend.tf`: Remote backend configuration (TFC/TFE)
- `providers.tf`: Google provider with `credentials_json` input
- `variables.tf`: All main variables, including network and cluster names/CIDRs
- `project_services.tf`: Enables GCP APIs via the `project_services` module
- `main.tf`: Wires `vpc` and `gke` modules

### Modules
- `modules/project_services`: Enables required APIs
- `modules/vpc`: Creates VPC/subnet and secondary ranges
- `modules/gke`: Creates the Autopilot cluster

---

## Troubleshooting

- **API not enabled**: First run enables them. If you see API errors, re-run after enable completes.
- **Insufficient permissions**: Ensure the service account has the roles listed above.
- **CIDR conflicts**: Adjust the `primary_cidr`, `pods_cidr`, `services_cidr` so they don’t overlap.
- **Regional constraints**: Ensure the `region` you choose supports Autopilot.

---

## Next steps

- Add private control-plane access or authorized networks as needed
- Add Workload Identity, release-channel pinning, logging/monitoring customization
- Add Cloud NAT / Cloud Router if you plan to run private nodes with egress needs
- Add additional clusters by reusing the `gke` module with new subnets and ranges

---

© Your Team
>>>>>>> 6264544 (Initial commit)

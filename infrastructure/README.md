```bash
# ─────────────────────────────────────────────
# GCP + Milvus Architecture Terraform Template
# Structure: Best Practices with Modules & Environments
# ─────────────────────────────────────────────

# Folder structure overview:
# /infrastructure
# ├── main.tf
# ├── variables.tf
# ├── outputs.tf
# ├── backend.tf
# ├── terraform.tfvars (not committed)
# ├── modules/
# │   ├── storage/
# │   │   ├── main.tf
# │   │   ├── variables.tf
# │   │   └── outputs.tf
# │   ├── cloud_run/
# │   ├── api_gateway/
# │   ├── vertex_ai/
# │   └── pubsub/
# └── envs/
#     ├── dev/
#     │   └── terraform.tfvars
#     └── prod/
#         └── terraform.tfvars

# ─── infrastructure/main.tf ───
provider "google" {
  project = var.project_id
  region  = var.region
}

module "storage" {
  source     = "./modules/storage"
  bucket_name = var.bucket_name
}

module "cloud_run" {
  source           = "./modules/cloud_run"
  service_name     = var.service_name
  container_image  = var.container_image
}

module "vertex_ai" {
  source         = "./modules/vertex_ai"
  display_name   = var.model_name
  container_uri  = var.model_container_uri
}

module "api_gateway" {
  source        = "./modules/api_gateway"
  api_name      = var.api_name
  cloud_run_url = module.cloud_run.url
}

module "pubsub" {
  source = "./modules/pubsub"
  topic_name = var.pubsub_topic_name
}

# Milvus is handled externally on Zilliz Cloud
output "milvus_endpoint" {
  value = "https://in03-6a5922b5751eff6.serverless.gcp-us-west1.cloud.zilliz.com"
}

# ─── infrastructure/variables.tf ───
variable "project_id" {}
variable "region" { default = "us-west1" }
variable "bucket_name" {}
variable "service_name" {}
variable "container_image" {}
variable "model_name" {}
variable "model_container_uri" {}
variable "api_name" {}
variable "pubsub_topic_name" {}

# ─── infrastructure/backend.tf ───
terraform {
  backend "gcs" {
    bucket  = "your-tfstate-bucket"
    prefix  = "terraform/state"
  }
}

# ─── Example: infrastructure/envs/dev/terraform.tfvars ───
project_id           = "my-legal-search-dev"
bucket_name          = "legal-docs-dev"
service_name         = "doc-nlp-service"
container_image      = "gcr.io/my-legal-search/doc-nlp:latest"
model_name           = "legal-model-dev"
model_container_uri  = "gcr.io/my-legal-search/models/legal-qa"
api_name             = "legal-api"
pubsub_topic_name    = "doc-events"

```
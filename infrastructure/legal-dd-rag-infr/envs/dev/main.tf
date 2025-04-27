module "identity" {
  source = "../../modules/identity"
  environment = var.environment
  tags        = local.tags
}

module "networking" {
  source = "../../modules/networking"
  environment = var.environment
  tags        = local.tags
}

module "storage_queue" {
  source = "../../modules/storage_queue"
  environment = var.environment
  tags        = local.tags
}

module "compute_lambdas" {
  source = "../../modules/compute/lambdas"
  environment = var.environment
  tags        = local.tags
  pdf_extractor_image_uri = "<REPLACE_WITH_ECR_IMAGE_URI>"
  sqs_queue_arn = module.storage_queue.ingest_fifo_queue_arn
}

module "compute_stepfunctions" {
  source = "../../modules/compute/stepfunctions"
  environment = var.environment
  tags        = local.tags
}

module "api_gateway" {
  source = "../../modules/api_gateway"
  environment = var.environment
  tags        = local.tags
}

module "observability" {
  source = "../../modules/observability"
  environment = var.environment
  tags        = local.tags
}

# Load shared locals
locals {
  project     = "legal-dd"
  owner       = "guimo@gmail.com"
  cost_center = "CC-00001-LDD"
}

module "security" {
  source = "../../modules/security"
  environment = var.environment
  tags        = local.tags
}

module "optional_addons_sagemaker" {
  source = "../../modules/optional_addons/sagemaker"
  environment = var.environment
  tags        = local.tags
  pipeline_role_arn = module.security.sagemaker_pipeline_role_arn
  pipeline_display_name = "Legal-DD-Retrain-Pipeline"
  pipeline_name = "legal-dd-retrain-pipeline"
  pipeline_definition_json = "{\"Version\":\"2020-12-01\",\"Metadata\":{},\"PipelineDefinition\":{}}"
}

module "optional_addons_cloudfront_spa" {
  source = "../../modules/optional_addons/cloudfront_spa"
  environment = var.environment
  tags        = local.tags
}

module "optional_addons_budget_alerts" {
  source = "../../modules/optional_addons/budget_alerts"
  environment = var.environment
  tags        = local.tags
}

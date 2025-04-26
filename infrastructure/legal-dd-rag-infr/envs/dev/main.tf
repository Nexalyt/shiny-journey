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

module "compute_eks" {
  source = "../../modules/compute/eks"
  environment = var.environment
  tags        = local.tags
}

module "compute_lambdas" {
  source = "../../modules/compute/lambdas"
  environment = var.environment
  tags        = local.tags
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

module "security" {
  source = "../../modules/security"
  environment = var.environment
  tags        = local.tags
}

module "optional_addons_sagemaker" {
  source = "../../modules/optional_addons/sagemaker"
  environment = var.environment
  tags        = local.tags
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

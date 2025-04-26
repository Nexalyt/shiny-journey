module "lambdas" {
  source = "./lambdas"

  environment = var.environment
  tags        = var.tags

  # Add any other variables needed for Lambda deployment
}
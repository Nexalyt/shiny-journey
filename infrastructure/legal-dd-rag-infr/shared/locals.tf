locals {
  project     = "legal-dd"
  owner       = "guimo@gmail.com" # Update as needed
  cost_center = "CC-00001-LDD"           # Update as needed
  environment = var.environment

  tags = {
    Environment = local.environment
    Project     = local.project
    Owner       = local.owner
    CostCenter  = local.cost_center
  }

  # Resource name suffixing
  name_suffix = "-${local.environment}"
}

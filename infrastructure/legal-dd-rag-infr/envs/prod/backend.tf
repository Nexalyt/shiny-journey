terraform {
  backend "s3" {
    bucket         = "tfstate-prod-legal-dd"
    key            = "state/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tfstate-lock-prod-legal-dd"
    encrypt        = true
  }
}

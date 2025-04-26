terraform {
  backend "s3" {
    bucket         = "tfstate-dev-legal-dd"
    key            = "state/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tfstate-lock-dev-legal-dd"
    encrypt        = true
  }
}

variable "aws_region" {
  description = "AWS region to deploy resources in."
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
  default     = "prod"
}

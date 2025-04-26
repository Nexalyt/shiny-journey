variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
}

variable "lambda_s3_bucket" {
  description = "S3 bucket for Lambda deployment packages."
  type        = string
  default     = null
}

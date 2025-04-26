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

variable "pdf_extractor_image_uri" {
  description = "ECR image URI for the PDF extraction Lambda."
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue to trigger the Lambda."
  type        = string
}

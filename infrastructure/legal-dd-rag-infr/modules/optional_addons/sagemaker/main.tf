variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
}

variable "pipeline_role_arn" {
  description = "IAM role ARN for SageMaker pipeline execution."
  type        = string
}

variable "pipeline_definition_s3_uri" {
  description = "S3 URI for the SageMaker pipeline definition JSON."
  type        = string
}

variable "pipeline_name" {
  description = "Name for the SageMaker pipeline."
  type        = string
  default     = "legal-dd-retrain-pipeline"
}

resource "aws_sagemaker_pipeline" "retrain" {
  name     = var.pipeline_name
  role_arn = var.pipeline_role_arn
  pipeline_definition_s3_location = var.pipeline_definition_s3_uri
  tags     = var.tags
}

output "sagemaker_pipeline_name" {
  value = aws_sagemaker_pipeline.retrain.name
}

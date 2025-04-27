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

variable "pipeline_definition_json" {
  description = "JSON definition for the SageMaker pipeline."
  type        = string
  default     = "{\"Version\":\"2020-12-01\",\"Metadata\":{},\"PipelineDefinition\":{}}"
}

variable "pipeline_name" {
  description = "Name for the SageMaker pipeline."
  type        = string
  default     = "legal-dd-retrain-pipeline"
}

variable "pipeline_display_name" {
  description = "Display name for the SageMaker pipeline."
  type        = string
  default     = "Legal-DD-Retrain-Pipeline"
}

resource "aws_sagemaker_pipeline" "retrain" {
  pipeline_name         = var.pipeline_name
  pipeline_display_name = var.pipeline_display_name
  role_arn              = var.pipeline_role_arn
  pipeline_definition   = var.pipeline_definition_json
  tags                  = var.tags
}

output "sagemaker_pipeline_name" {
  value = aws_sagemaker_pipeline.retrain.pipeline_name
}

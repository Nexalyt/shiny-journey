output "sagemaker_pipeline_role_arn" {
  description = "IAM role ARN for SageMaker pipeline execution."
  value       = aws_iam_role.sagemaker_pipeline.arn
}
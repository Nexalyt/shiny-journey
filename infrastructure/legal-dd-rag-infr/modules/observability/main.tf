resource "aws_cloudwatch_log_group" "api" {
  name = "/aws/legal-dd/api${var.environment}"
  retention_in_days = 30
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "lambdas" {
  name = "/aws/legal-dd/lambdas${var.environment}"
  retention_in_days = 30
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "eks" {
  name = "/aws/legal-dd/eks${var.environment}"
  retention_in_days = 30
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "stepfunctions" {
  name = "/aws/legal-dd/stepfunctions${var.environment}"
  retention_in_days = 30
  tags = var.tags
}

# Placeholder for X-Ray/OTEL instrumentation
# resource "aws_xray_group" "main" { ... }

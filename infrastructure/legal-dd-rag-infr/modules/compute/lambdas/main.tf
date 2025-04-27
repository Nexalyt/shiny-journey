# Lambda code packaging example for Terraform/OpenTofu
# This assumes you have built and zipped your Lambda code and uploaded it to S3.
# You can automate this with a Makefile or CI/CD pipeline.

# Example for NLP Lambda
# resource "aws_lambda_function" "nlp" {
#   function_name = "legal-dd-nlp${var.environment}"
#   handler       = "main.handler"
#   runtime       = "python3.11"
#   role          = "arn:aws:iam::123456789012:role/LambdaNlpRole" # Replace with actual role
#   s3_bucket     = var.lambda_s3_bucket
#   s3_key        = "nlp-lambda.zip"
#   tags          = merge(var.tags, { Name = "legal-dd-nlp${var.environment}" })
# }

# Repeat for other Lambda functions (search, notify, etc.)
# resource "aws_lambda_function" "search" {
#   function_name = "legal-dd-search${var.environment}"
#   handler       = "main.handler"
#   runtime       = "python3.11"
#   role          = "arn:aws:iam::123456789012:role/LambdaSearchRole" # Placeholder
#   s3_bucket     = var.lambda_s3_bucket
#   s3_key        = "search-lambda.zip"
#   tags          = merge(var.tags, { Name = "legal-dd-search${var.environment}" })
# }

# resource "aws_lambda_function" "notify" {
#   function_name = "legal-dd-notify${var.environment}"
#   handler       = "main.handler"
#   runtime       = "python3.11"
#   role          = "arn:aws:iam::123456789012:role/LambdaNotifyRole" # Placeholder
#   s3_bucket     = var.lambda_s3_bucket
#   s3_key        = "notify-lambda.zip"
#   tags          = merge(var.tags, { Name = "legal-dd-notify${var.environment}" })
# }

resource "aws_lambda_function" "pdf_extractor" {
  function_name = "pdf-extractor-${var.environment}"
  package_type  = "Image"
  image_uri     = var.pdf_extractor_image_uri
  role          = aws_iam_role.lambda_exec.arn
  timeout       = 900 # 15 minutes (Lambda max)
  memory_size   = 1024
  architectures = ["arm64"]

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  tags = merge(var.tags, {
    Service = "pdf-extractor"
    Environment = title(var.environment)
  })
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.pdf_extractor.arn
  batch_size       = 1
  enabled          = true
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_sqs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaSQSQueueExecutionRole"
}

output "pdf_extractor_lambda_arn" {
  value = aws_lambda_function.pdf_extractor.arn
}

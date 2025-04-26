resource "aws_lambda_function" "nlp" {
  function_name = "legal-dd-nlp${var.environment}"
  handler       = "main.handler"
  runtime       = "python3.11"
  role          = "arn:aws:iam::123456789012:role/LambdaNlpRole" # Placeholder
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = "nlp-lambda.zip"
  tags          = merge(var.tags, { Name = "legal-dd-nlp${var.environment}" })
}

resource "aws_lambda_function" "search" {
  function_name = "legal-dd-search${var.environment}"
  handler       = "main.handler"
  runtime       = "python3.11"
  role          = "arn:aws:iam::123456789012:role/LambdaSearchRole" # Placeholder
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = "search-lambda.zip"
  tags          = merge(var.tags, { Name = "legal-dd-search${var.environment}" })
}

resource "aws_lambda_function" "notify" {
  function_name = "legal-dd-notify${var.environment}"
  handler       = "main.handler"
  runtime       = "python3.11"
  role          = "arn:aws:iam::123456789012:role/LambdaNotifyRole" # Placeholder
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = "notify-lambda.zip"
  tags          = merge(var.tags, { Name = "legal-dd-notify${var.environment}" })
}

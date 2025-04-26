resource "aws_s3_bucket" "raw_docs" {
  bucket = "legal-dd-raw-docs${var.environment}"
  force_destroy = true
  tags = merge(var.tags, { Name = "legal-dd-raw-docs${var.environment}" })
}

resource "aws_s3_bucket" "processed_md" {
  bucket = "legal-dd-processed-md${var.environment}"
  force_destroy = true
  tags = merge(var.tags, { Name = "legal-dd-processed-md${var.environment}" })
}

resource "aws_sqs_queue" "ingest_fifo" {
  name                        = "legal-dd-ingest-fifo${var.environment}.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.ingest_dlq.arn
    maxReceiveCount     = 5
  })
  tags = merge(var.tags, { Name = "legal-dd-ingest-fifo${var.environment}" })
}

resource "aws_sqs_queue" "ingest_dlq" {
  name       = "legal-dd-ingest-dlq${var.environment}"
  tags       = merge(var.tags, { Name = "legal-dd-ingest-dlq${var.environment}" })
}

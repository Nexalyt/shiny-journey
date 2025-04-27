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

resource "aws_s3_bucket_lifecycle_configuration" "raw_docs_lifecycle" {
  bucket = aws_s3_bucket.raw_docs.id

  rule {
    id     = "transition-to-ia-and-expire"
    status = "Enabled"
    filter {
      prefix = ""
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    expiration {
      days = 180
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "processed_md_lifecycle" {
  bucket = aws_s3_bucket.processed_md.id

  rule {
    id     = "transition-to-ia-and-expire"
    status = "Enabled"
    filter {
      prefix = ""
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    expiration {
      days = 180
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
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

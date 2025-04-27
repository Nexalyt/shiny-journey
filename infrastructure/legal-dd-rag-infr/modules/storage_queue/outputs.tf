output "raw_docs_bucket" {
  value = aws_s3_bucket.raw_docs.bucket
}

output "processed_md_bucket" {
  value = aws_s3_bucket.processed_md.bucket
}

output "ingest_fifo_queue_url" {
  value = aws_sqs_queue.ingest_fifo.url
}

output "ingest_fifo_queue_arn" {
  value = aws_sqs_queue.ingest_fifo.arn
}

output "ingest_dlq_url" {
  value = aws_sqs_queue.ingest_dlq.url
}

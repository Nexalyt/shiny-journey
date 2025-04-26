resource "aws_kms_key" "s3" {
  description = "KMS key for S3 bucket encryption (${var.environment})"
  enable_key_rotation = true
  tags = merge(var.tags, { Name = "legal-dd-s3-kms${var.environment}" })
}

resource "aws_kms_key" "secrets" {
  description = "KMS key for Secrets Manager (${var.environment})"
  enable_key_rotation = true
  tags = merge(var.tags, { Name = "legal-dd-secrets-kms${var.environment}" })
}

resource "aws_secretsmanager_secret" "milvus_api_key" {
  name = "legal-dd-milvus-api-key${var.environment}"
  kms_key_id = aws_kms_key.secrets.id
  tags = var.tags
}

resource "aws_secretsmanager_secret" "virustotal_key" {
  name = "legal-dd-virustotal-key${var.environment}"
  kms_key_id = aws_kms_key.secrets.id
  tags = var.tags
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "legal-dd-db-credentials${var.environment}"
  kms_key_id = aws_kms_key.secrets.id
  tags = var.tags
}

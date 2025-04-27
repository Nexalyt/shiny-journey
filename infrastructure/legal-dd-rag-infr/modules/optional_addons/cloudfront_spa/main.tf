variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
}

variable "spa_bucket_name" {
  description = "S3 bucket name for SPA hosting."
  type        = string
  default     = "legal-dd-spa"
}

resource "aws_s3_bucket" "spa" {
  bucket = var.spa_bucket_name
  tags = var.tags
}

resource "aws_s3_bucket_acl" "spa" {
  bucket = aws_s3_bucket.spa.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "spa" {
  bucket = aws_s3_bucket.spa.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "spa_policy" {
  bucket = aws_s3_bucket.spa.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = ["s3:GetObject"],
      Resource  = "${aws_s3_bucket.spa.arn}/*"
    }]
  })
}

resource "aws_cloudfront_distribution" "spa" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  origin {
    domain_name = aws_s3_bucket.spa.bucket_regional_domain_name
    origin_id   = "spaS3Origin"
    s3_origin_config {
      origin_access_identity = ""
    }
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "spaS3Origin"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  price_class = "PriceClass_100"
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  tags = var.tags
}

output "spa_bucket_name" {
  value = aws_s3_bucket.spa.bucket
}

output "spa_cloudfront_domain" {
  value = aws_cloudfront_distribution.spa.domain_name
}

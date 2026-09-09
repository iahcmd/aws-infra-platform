# ──────────────────────────────────────────────────────────────
# S3 Storage Module
# Creates encrypted S3 buckets with versioning, lifecycle rules,
# and public access block enforced.
# ──────────────────────────────────────────────────────────────

resource "aws_s3_bucket" "this" {
  bucket_prefix = "${var.project_name}-${var.environment}-${var.bucket_purpose}-"
  force_destroy = var.environment != "prod"

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.bucket_purpose}"
    Environment = var.environment
    Purpose     = var.bucket_purpose
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "transition-and-expire"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = var.expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

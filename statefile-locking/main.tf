resource "aws_s3_bucket" "statefile" {
  bucket = "statefile"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  count  = true ? 1 : 0
  bucket = aws_s3_bucket.statefile.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "tfstate_lifecycle" {
  bucket = aws_s3_bucket.statefile.id

  rule {
    id     = "lifecycle-rules"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = var.s3_lifecycle_transition_days.noncurrent_days
    }

    transition {
      days          = var.s3_lifecycle_transition_days.standard_ia_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.s3_lifecycle_transition_days.glacier_days
      storage_class = "GLACIER"
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.s3_lifecycle_transition_days.abort_days
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_encryption" {
  bucket = aws_s3_bucket.statefile.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
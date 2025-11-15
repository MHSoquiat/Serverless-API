provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "statefile" {
  bucket = "statefile-soki-11"

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
      noncurrent_days = 30
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
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
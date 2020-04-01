resource "aws_kms_key" "s3_encryption_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "delivery_bucket" {
  bucket = "endava-med-iam-file-delivery-bucket"
  acl    = "private"
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
      enabled = true
  }
  
  logging {
      target_bucket = aws_s3_bucket.audit_log_bucket.id
      target_prefix = "delivery_bucket/"
  }
  
  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_delivery_bucket" {
  bucket = aws_s3_bucket.delivery_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "audit_log_bucket" {
  bucket = "endava-med-bucket-log-audit"
  acl    = "log-delivery-write"
  region = var.region

  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_log_bucket" {
  bucket = aws_s3_bucket.audit_log_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
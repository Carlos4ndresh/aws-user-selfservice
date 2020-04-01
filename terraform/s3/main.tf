resource "aws_s3_bucket" "delivery_bucket" {
  bucket = "endava-med-iam-file-delivery-bucket"
  acl    = "private"
  region = var.region

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
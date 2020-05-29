output "delivery_bucket" {
    value = aws_s3_bucket.delivery_bucket.bucket_regional_domain_name
}


output "log_bucket" {
    value = aws_s3_bucket.audit_log_bucket.bucket_regional_domain_name
}

output "log_bucket_name" {
    value = aws_s3_bucket.audit_log_bucket.bucket
}
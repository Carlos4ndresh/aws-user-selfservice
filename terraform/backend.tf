terraform {
    backend "s3" {
        encrypt = true
        bucket = "terraform-state-bucket"
        key    = "iam_tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-lock"
    }
    required_version = "~>0.12"
}
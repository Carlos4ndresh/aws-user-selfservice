terraform {
    backend "s3" {
        bucket = "terraform-endava-med-state-bucket"
        key    = "iam_tfstate"
        region = "us-east-1"

    }
    required_version = "~>0.12"
}
terraform {
    backend "s3" {
        encrypt = true
        # bucket = "terraform-endava-med-state-bucket"
        bucket = "terraform-endava-med-state-bucket-test"
        key    = "iam_tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-endava-med-lock"
    }
    required_version = "~>0.12"
}
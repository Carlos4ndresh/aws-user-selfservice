variable "region" {
    type = string
    default = "us-east-1"
    description = "AWS Region"
}

variable user_names {}

variable "provisioner" {
  description = "Value to use in Provisioner tags"
  type        = string
  default     = "Terraform"
}

variable "repo_name" {
  type = string
  default = "aws-iam-infra-selfservice"
}

variable "repo_branch" {
  type = string
  default = "master"
}
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

variable "owner" {
  type = string
  default = "carlos.herrera"
}

variable "project" {
  type = string
  default = "infrastructure management"
}

variable "env" {
  type = string
  default = "production"
}

variable "key_pair" {
  type = string
  default = "ec2bastionkey"
}

variable "scheduler_tag" {
  type = string
  default = "MED-OfficeHours"
}
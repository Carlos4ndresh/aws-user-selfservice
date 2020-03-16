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
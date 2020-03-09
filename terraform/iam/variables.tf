variable "provisioner" {
  description = "Value to use in Provisioner tags"
  type        = string
  default     = "Terraform"
}

variable "user_names" {
  description = "A nested map of users and properties.  The outer keys are usernames, and the inner properties map is documented in the User Properties section."
  type = map(object({
    force_destroy        = bool
    email_address        = string
    group_memberships    = list(string)
    tags                 = map(string)
  }))
}

output "user_ids" {
    value = module.iam.user_ids
}

output "user_arns" {
    value = module.iam.user_arns
}

output "user_groups" {
    value = module.iam.user_groups
}

output "ec2_bastion_dns" {
    value = module.ec2.ec2_dns_name
}

# output "user_password" {
#   value = module.iam.user_password
# }
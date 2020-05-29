output "user_ids" {
    value = module.iam.user_ids
}

output "user_arns" {
    value = module.iam.user_arns
}

output "user_groups" {
    value = module.iam.user_groups
}

output "s3_log_bucket" {
    value = module.s3_resources.log_bucket
}

output "cloudformation_output" {
    value = module.cf_stack.instance_scheduler_outputs
}

output "mailer_sqs_arn" {
    value = module.sqs_resources.mailer_queue_arn
}

output "mailer_sqs_role_arn" {
    value = module.iam.mailer_sqs_role_arn
}
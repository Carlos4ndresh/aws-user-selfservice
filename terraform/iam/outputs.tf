output "user_creation_lambda_role" {
    value = aws_iam_role.user_creation_lambda_role.arn
}

output "user_ids" {
  value = {
    for user_name in aws_iam_user.non_privileged_user:
    user_name.name => user_name.unique_id
  }
}

output "user_arns" {
  value = {
    for user_name in aws_iam_user.non_privileged_user:
    user_name.name => user_name.arn
  }
}
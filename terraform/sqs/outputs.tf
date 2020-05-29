output "mailer_queue_arn" {
    value = aws_sqs_queue.cloudcustodian_mailer_queue.arn
}
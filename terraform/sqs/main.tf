resource "aws_sqs_queue" "cloudcustodian_mailer_queue" {
    name = "cloudcustodian_mailer_queue"
    delay_seconds = 90
    message_retention_seconds = 86400
    receive_wait_time_seconds = 10

    tags = {
        env = var.env,
        owner = var.owner,
        project = var.project,
        provisioner = var.provisioner        
    }

}
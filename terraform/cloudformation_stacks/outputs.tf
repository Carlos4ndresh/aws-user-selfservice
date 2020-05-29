output "instance_scheduler_outputs" {
    value = aws_cloudformation_stack.instance_scheduler_stack.*.outputs
}
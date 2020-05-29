output "ec2_dns_name" {
    value = aws_instance.ec2_bastion.public_dns
}
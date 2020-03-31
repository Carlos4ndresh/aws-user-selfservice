output "vpc_id" {
    value = aws_vpc.ec2_bastion_vpc.id
}

output "subnet_id" {
    value = aws_subnet.ec2_bastion_subnet.id
}

output "internet_gw_id" {
    value = aws_internet_gateway.bastion_vpc_gateway
}

output "security_group_id" {
    value = aws_security_group.allow_ssh.id
}
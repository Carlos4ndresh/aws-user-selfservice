resource "aws_vpc" "ec2_bastion_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}

resource "aws_subnet" "ec2_bastion_subnet" {
  vpc_id     = aws_vpc.ec2_bastion_vpc.id
  cidr_block = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}

resource "aws_internet_gateway" "bastion_vpc_gateway" {
  vpc_id = aws_vpc.ec2_bastion_vpc.id

  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}


resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.ec2_bastion_vpc.main_route_table_id

  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}

resource "aws_route_table_association" "ec2_subnet_main_route_association" {
  subnet_id      = aws_subnet.ec2_bastion_subnet.id
  route_table_id = aws_vpc.ec2_bastion_vpc.main_route_table_id
}

resource "aws_route" "internet_route" {
  route_table_id            = aws_vpc.ec2_bastion_vpc.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  depends_on                = [aws_route_table_association.ec2_subnet_main_route_association]
  gateway_id = aws_internet_gateway.bastion_vpc_gateway.id
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic from mentors"
  vpc_id      = aws_vpc.ec2_bastion_vpc.id

  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


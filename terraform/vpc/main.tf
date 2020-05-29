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

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.ec2_bastion_vpc.id
  cidr_block = "172.16.200.0/24"
  availability_zone = "us-east-1c"

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

resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.ec2_bastion_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastion_vpc_gateway.id
  }

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

resource "aws_route_table_association" "public_subnet_main_route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.custom_route_table.id
}

resource "aws_route" "internet_route" {
  route_table_id            = aws_default_route_table.default_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  depends_on                = [aws_nat_gateway.nat_gw_for_packagedownload]
  nat_gateway_id = aws_nat_gateway.nat_gw_for_packagedownload.id
}

resource "aws_eip" "nat_gateway_elastic_ip" {
  vpc      = true
  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}

resource "aws_nat_gateway" "nat_gw_for_packagedownload" {
  allocation_id = aws_eip.nat_gateway_elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id
}
  
resource "aws_security_group" "bastion_sg"{
  name = "bastion-ssm-sg"
  vpc_id = aws_vpc.ec2_bastion_vpc.id
  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}

resource "aws_security_group" "host_sg"{
  name = "host-ssm-sg"
  vpc_id = aws_vpc.ec2_bastion_vpc.id
  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}

resource "aws_security_group" "endpoints_sg"{
  name = "endpoints-ssm-sg"
  vpc_id = aws_vpc.ec2_bastion_vpc.id
  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }
}

#=============================================================================#
#                    BASTION SECURITY GROUP ROLES
#=============================================================================#


resource "aws_security_group_rule" "allow_bastion_443_from_endpoints" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = aws_security_group.endpoints_sg.id
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "allow_bastion_443_to_endpoints" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = aws_security_group.endpoints_sg.id
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "allow_bastion_80_to_natgateway" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.bastion_sg.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_bastion_ssh_to_host" {
  type = "egress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = aws_security_group.host_sg.id
  security_group_id = aws_security_group.bastion_sg.id
}

#=============================================================================#
#                    HOST SECURITY GROUP ROLES
#=============================================================================#

resource "aws_security_group_rule" "allow_host_ssh_from_bastion" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id = aws_security_group.host_sg.id
}

#=============================================================================#
#                    ENDPOINTS SECURITY GROUP ROLES
#=============================================================================#

resource "aws_security_group_rule" "allow_endpoints_443_from_bastion" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id = aws_security_group.endpoints_sg.id
}

resource "aws_security_group_rule" "allow_endpoints_443_to_bastion" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id = aws_security_group.endpoints_sg.id
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id            = aws_vpc.ec2_bastion_vpc.id
  service_name      = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.ec2_bastion_subnet.id]
  security_group_ids = [ aws_security_group.endpoints_sg.id ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.ec2_bastion_vpc.id
  service_name      = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.ec2_bastion_subnet.id]
  security_group_ids = [ aws_security_group.endpoints_sg.id ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.ec2_bastion_vpc.id
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.ec2_bastion_subnet.id]
  security_group_ids = [ aws_security_group.endpoints_sg.id ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "codecommit_git_endpoint" {
  vpc_id            = aws_vpc.ec2_bastion_vpc.id
  service_name      = "com.amazonaws.us-east-1.git-codecommit"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.ec2_bastion_subnet.id]
  security_group_ids = [ aws_security_group.endpoints_sg.id ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "codecommit_api_endpoint" {
  vpc_id            = aws_vpc.ec2_bastion_vpc.id
  service_name      = "com.amazonaws.us-east-1.codecommit"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.ec2_bastion_subnet.id]
  security_group_ids = [ aws_security_group.endpoints_sg.id ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "cloudwatch_logs_endpoint" {
  vpc_id            = aws_vpc.ec2_bastion_vpc.id
  service_name      = "com.amazonaws.us-east-1.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.ec2_bastion_subnet.id]
  security_group_ids = [ aws_security_group.endpoints_sg.id ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "kms_logs_endpoint" {
  vpc_id            = aws_vpc.ec2_bastion_vpc.id
  service_name      = "com.amazonaws.us-east-1.kms"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.ec2_bastion_subnet.id]
  security_group_ids = [ aws_security_group.endpoints_sg.id ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.ec2_bastion_vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "s3_endpoint_association" {
  route_table_id  = aws_default_route_table.default_route_table.default_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
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


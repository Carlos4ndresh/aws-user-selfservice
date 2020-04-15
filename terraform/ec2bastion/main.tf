data "aws_ami" "ubuntu_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.tpl")
}

resource "aws_instance" "ec2_bastion" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  vpc_security_group_ids = [var.security_group_id,]
  key_name = var.key_pair
  iam_instance_profile = var.instance_profile.name
  user_data = data.template_file.user_data.rendered
  associate_public_ip_address = true
  subnet_id = var.subnet_id

  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env,
    name = "CodeCommitBastion"
  }
}


resource "aws_ssm_document" "mentors_session_manager_preferences" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = <<DOC
{
    "schemaVersion": "1.0",
    "description": "Document to hold regional settings for Session Manager",
    "sessionType": "Standard_Stream",
    "inputs": {
        "s3BucketName": "",
        "s3KeyPrefix": "",
        "s3EncryptionEnabled": "false",
        "cloudWatchLogGroupName": "",
        "cloudWatchEncryptionEnabled": ""
    }
}
DOC
}
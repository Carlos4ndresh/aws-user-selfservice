provider "aws" {
    region = var.region
    version = "~>2.0"
}


module "iam" {
    source = "./iam/"   
    user_names = var.user_names
    provisioner = var.provisioner
}

module "lambda" {
    source = "./lambda"
    user_creation_lambda_role = module.iam.user_creation_lambda_role
    provisioner = var.provisioner
}

module "vpc" {
    source = "./vpc"
    project = var.project
    provisioner = var.provisioner
    owner = var.owner
    env = var.env
}

module "ec2" {
    source = "./ec2bastion"
    project = var.project
    provisioner = var.provisioner
    owner = var.owner
    env = var.env
    key_pair = var.key_pair
    security_group_id = var.security_group_id
}
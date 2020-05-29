provider "aws" {
    region = var.region
    version = "~>2.0"
}


module "iam" {
    source = "./iam/"   
    user_names = var.user_names
    provisioner = var.provisioner
    owner = var.owner
    env = var.env
    project = var.project
    rideshare_responsible = var.rideshare_responsible
}

module "cf_stack" {
    source = "./cloudformation_stacks"
    project = var.project
    provisioner = var.provisioner
    owner = var.owner
    env = var.env
}


module "s3_resources" {
    source = "./s3"
    project = var.project
    provisioner = var.provisioner
    owner = var.owner
    env = var.env
    region = var.region
}

module "sqs_resources" {
    source = "./sqs"
    project = var.project
    provisioner = var.provisioner
    owner = var.owner
    env = var.env
}
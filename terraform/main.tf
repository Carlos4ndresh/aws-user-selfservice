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
# AWS IAM GITOPS AND USER SELFSERVICE

This repo contains Terraform Files for managing IAM Users/Groups/Roles & Policies.

Also, Lambda Functions and infrastructure to support a self-service IAM User creation with administative approval.  

## Resource Modules present

The following modules are part of this respository and can be included in the main.tf execution, their outputs and variables are not fully documented but, they are easily readable:

- cloudformation_stacks: CloudFormation stack for creating AWS Instance Scheduler resources
- ec2bastion: EC2 bastion with exclusive access through AWS Systems Manager - Session Manager
- iam: IAM resources, users/roles/policies/groups/attachments
- s3: s3 resources for log delivery
- lambda: a starter lambda for IAM user self-service
- sqs: sqs resources for cloudcustodian
- vpc: vpc resources, including usage for ec2 bastion

## Usage of Terraform to Create IAM Users

Inside the root folder there's a **terraform.tfvars** file that contains the user list in the form:

    "user.name" = {
        force_destroy = true
        email_address = "user.name@mymail.com"
        group_memberships = [ "non_privileged_users", "interns" ]
        tags = {
            mytagname = mytagvalue
        }
    }

### Users

These are inside a `user_names` block that must be respected. Once the terraform stack runs, additional users will be created; with their corresponding group association. Currently, no auto-generated passwords are in place; probably in the future.

### Groups/Roles/Policies

To create groups or roles, you must edit the corresponding terraform files.

For policies creation, besides that, you must create the .json file inside the `terraform/iam/policies`folder.

## Continuous Integration

This repository is automatically build and deployed by AWS CodePipeline and CodeBuild; in the root directory you can find the *buildspec.yml* file that controls this repo's pipeline

## Disclaimer

- The serverless selfservice app is due to be developed
- You'll need to know terraform to use this repo, using TF modules, variables and experience with AWS IAM and other services.

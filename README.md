# AWS IAM GITOPS AND USER SELFSERVICE

This repo contains Terraform Files for managing IAM Users/Groups/Roles & Policies.

Also, Lambda Functions and infrastructure to support a self-service IAM User creation with administative approval.  

## Usage of Terraform to Create IAM Users

Inside the *terraform/iam* folder there's a **terraform.tfvars** file that contains the user list in the form:

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

## Disclaimer

This last part is pending to be developed, there is only a lambda function developed that creates instantly the user, which is just a temporary feature.

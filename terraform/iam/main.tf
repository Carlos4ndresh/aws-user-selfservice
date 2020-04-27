# Group Creation

resource "aws_iam_group" "interns" {
  name = "interns"
}

resource "aws_iam_group" "mentors" {
    name = "mentors"
}

resource "aws_iam_group" "interns-devops" {
    name = "interns-devops"
}

resource "aws_iam_group" "developers" {
    name = "developers"
}

resource "aws_iam_group" "developers_routrip" {
    name = "developers-routrip"
}

resource "aws_iam_group" "non_privileged" {
    name = "non_privileged_users"
}

resource "aws_iam_group" "qa_engineers" {
    name = "qa_engineers"
}

resource "aws_iam_group" "devops_engineers" {
    name = "devops_engineers"
}

resource "aws_iam_group" "junior_j2_developers" {
  name = "junior_j2_developers"
}

# Policy Creation

resource "aws_iam_policy" "UserSelfManagement" {
  name        = "IAMUser_SelfManagement"
  path        = "/"
  description = "Password and account Policy for non-administrator users, interns and mentors"

  policy = file("${path.module}/policies/Non_PrivilegedUsers_IAM_SelfManagement.json")

}

resource "aws_iam_policy" "UserMFASelfmanagement" {
  name        = "IAMUser_MFASelfManagement"
  path        = "/"
  description = "MFA Policy for non-administrator users, interns and mentors"

  policy = file("${path.module}/policies/Non_PrivilegedUsers_MFA_Policy.json")
}

resource "aws_iam_policy" "user_creation_lambda_execution_policy" {
  name        = "user_creation_lambda_execution_policy"
  path        = "/"
  description = "Lambda execution policy for the user creation lambda function"

  policy = file("${path.module}/policies/user_creation_lambda_iam_policy.json")
}

resource "aws_iam_policy" "Interns_CodeCommit_Policy" {
  name        = "Interns_CodeCommit_Policy"
  path        = "/"
  description = "CodeCommit Policy for non devops interns"

  policy = file("${path.module}/policies/Interns_CodeCommit_Policy.json")
}

resource "aws_iam_policy" "EC2_CodeCommit_Policy" {
  name        = "EC2_CodeCommit_Policy"
  path        = "/"
  description = "CodeCommit Policy for interns mentors"

  policy = file("${path.module}/policies/EC2_CodeCommit_Policy.json")
}

resource "aws_iam_policy" "Interns_Devops_SNS_SQS_Permissions" {
  name        = "Interns_Devops_SNS_SQS_Permissions"
  path        = "/"
  description = "Policy for devops interns to be able to create sns topics"

  policy = file("${path.module}/policies/Interns_Devops_SNS_SQS_Permissions.json")
}

resource "aws_iam_policy" "Interns_Devops_IAM_Permissions" {
  name        = "Interns_Devops_IAM_Permissions"
  path        = "/"
  description = "Policy for devops interns to be able to use basic IAM"

  policy = file("${path.module}/policies/Interns_Devops_IAM_Permissions.json")
}

resource "aws_iam_policy" "routrip_developers_CodeCommit_Policy" {
  name        = "Routrip_Developers_CodeCommit_Policy"
  path        = "/"
  description = "Policy for the developer group of projecet route trip"

  policy = file("${path.module}/policies/Routrip_Developers_CodeCommit_Policy.json")
}

resource "aws_iam_policy" "EC2_CloudWatchLogs_Policy" {
  name        = "EC2_CloudWatchLogs_Policy"
  path        = "/"
  description = "Policy for the EC2 access to put logs on cloudwatch"

  policy = file("${path.module}/policies/EC2_CloudWatchLogs_policy.json")
}

resource "aws_iam_policy" "Mentors_SSM_SessionManager_Policy" {
  name        = "Mentors_SSM_SessionManager_Policy"
  path        = "/"
  description = "Policy for giving SSM Session Manager Access to mentors"

  policy = file("${path.module}/policies/Mentors_SSM_SessionManager_policy.json")
}

data "aws_iam_policy" "AWSCodeCommitFullAccess" {
  arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

data "aws_iam_policy" "AWSSSMManagedInstanceCorePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "Interns_EC2_Project_Policy" {
  name        = "Interns_EC2_Project_Policy"
  path        = "/"
  description = "Policy for the creation of resources for the internship project 2020-i"

  policy = file("${path.module}/policies/Interns_EC2_Project_policy.json")
}

resource "aws_iam_policy" "Interns_Lambda_Project_policy" {
  name        = "Interns_Lambda_Project_policy"
  path        = "/"
  description = "Policy for the creation of resources for the internship project 2020-i"

  policy = file("${path.module}/policies/Interns_Lambda_Project_policy.json")
}


## Temporary policies

resource "aws_iam_policy" "Interns_Terraform_Workshop_policy" {
  name        = "Interns_Terraform_Workshop_policy"
  path        = "/"
  description = "Terraform Workshop Temporary Policy for interns"

  policy = file("${path.module}/policies/Interns_Terraform_Workshop_policy.json")
}

resource "aws_iam_policy" "Temporary_Try_Permissions_Policy" {
  name        = "Temporary_Try_Permissions_Policy"
  path        = "/"
  description = "LambdaWorkshop Temporary Policy for interns"

  policy = file("${path.module}/policies/Temporary_Try_Permissions_Policy.json")
}


# Role Creation

resource "aws_iam_role" "user_creation_lambda_role" {
  name = "user_creation_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
      env = var.env,
      Provisioner = var.provisioner,
      owner = var.owner,
      project = var.project
  }
}

resource "aws_iam_role" "EC2_CodeCommit_ReadOnly_role" {
  name = "EC2_CodeCommit_ReadOnly_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      env = var.env,
      Provisioner = var.provisioner,
      owner = var.owner,
      project = var.project
  }
}

# Temporary role creation

resource "aws_iam_role" "InternsLambdaWorkshopRole" {
  name = "Interns_LambdaWorkshop_Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
      env = var.env,
      Provisioner = var.provisioner,
      owner = var.owner,
      project = var.project
  }

}

# Policy Attachment section

resource "aws_iam_role_policy_attachment" "Mentors_CodeCommit_readonly_role_attachment" {
  role       =  aws_iam_role.EC2_CodeCommit_ReadOnly_role.name
  policy_arn = aws_iam_policy.EC2_CodeCommit_Policy.arn
}

resource "aws_iam_role_policy_attachment" "SystemsManager_InstanceCore_Attachment" {
  role       =  aws_iam_role.EC2_CodeCommit_ReadOnly_role.name
  policy_arn =  data.aws_iam_policy.AWSSSMManagedInstanceCorePolicy.arn
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogs_EC2_Attachment" {
  role       =  aws_iam_role.EC2_CodeCommit_ReadOnly_role.name
  policy_arn =  aws_iam_policy.EC2_CloudWatchLogs_Policy.arn
}

resource "aws_iam_role_policy_attachment" "user_creation_lambda_role_attachment" {
  role       =  aws_iam_role.user_creation_lambda_role.name
  policy_arn =  aws_iam_policy.user_creation_lambda_execution_policy.arn
}

resource "aws_iam_group_policy_attachment" "RoutripDevelopersAttachment" {
  group      = aws_iam_group.developers_routrip.id
  policy_arn = aws_iam_policy.routrip_developers_CodeCommit_Policy.arn
}

resource "aws_iam_group_policy_attachment" "NonPrivilegedAttachment" {
    group = aws_iam_group.non_privileged.id
    policy_arn = aws_iam_policy.UserSelfManagement.arn
}

resource "aws_iam_group_policy_attachment" "NonPrivilegedMFAAttachment" {
    group = aws_iam_group.non_privileged.id
    policy_arn = aws_iam_policy.UserMFASelfmanagement.arn
}

resource "aws_iam_group_policy_attachment" "CodeCommitFullAccessAttachment_DevOps" {
  group      = aws_iam_group.devops_engineers.id
  policy_arn = data.aws_iam_policy.AWSCodeCommitFullAccess.arn
}

resource "aws_iam_group_policy_attachment" "CodeCommitFullAccessAttachment_DevOpsInterns" {
  group      = aws_iam_group.interns-devops.id
  policy_arn = data.aws_iam_policy.AWSCodeCommitFullAccess.arn
}

resource "aws_iam_group_policy_attachment" "Interns_Devops_SNS_SQS_Attachment" {
  group      = aws_iam_group.interns-devops.id
  policy_arn = aws_iam_policy.Interns_Devops_SNS_SQS_Permissions.arn
}


resource "aws_iam_group_policy_attachment" "Interns_Devops_IAM_Permissions_Attachment" {
  group      = aws_iam_group.interns-devops.id
  policy_arn = aws_iam_policy.Interns_Devops_IAM_Permissions.arn
}

resource "aws_iam_group_policy_attachment" "CodeCommitRestrictedAttachment_Interns" {
  group      = aws_iam_group.interns.id
  policy_arn = aws_iam_policy.Interns_CodeCommit_Policy.arn
}

resource "aws_iam_group_policy_attachment" "SystemManager_Mentors" {
  group      = aws_iam_group.mentors.id
  policy_arn = aws_iam_policy.Mentors_SSM_SessionManager_Policy.arn
}

# Temporary attachments

resource "aws_iam_group_policy_attachment" "Temporary_Try_Permissions_J2_Attachment" {
  group      = aws_iam_group.junior_j2_developers.id
  policy_arn = aws_iam_policy.Temporary_Try_Permissions_Policy.arn
}

resource "aws_iam_group_policy_attachment" "Temporary_TerraformWorkshop_Interns_Attachment" {
  group      = aws_iam_group.interns-devops.id
  policy_arn = aws_iam_policy.Interns_Terraform_Workshop_policy.arn
}

resource "aws_iam_group_policy_attachment" "Temporary_TerraformWorkshop_Speakers_Attachment" {
  group      = aws_iam_group.devops_engineers.id
  policy_arn = aws_iam_policy.Interns_Terraform_Workshop_policy.arn
}


# Users creation (testing)

resource "aws_iam_user" "non_privileged_user" {
  for_each = var.user_names

  name          = each.key
  force_destroy = each.value["force_destroy"]

  tags = merge(each.value["tags"], { Provisioner : var.provisioner, EmailAddress : each.value["email_address"] })
}

resource "aws_iam_user_group_membership" "group_membership" {
  for_each = var.user_names

  user   = each.key
  groups = each.value["group_memberships"]

  depends_on = [ aws_iam_user.non_privileged_user ]
}

# Profiles

## EC2 Instance Profiles
resource "aws_iam_instance_profile" "ec2_codecommit_instance_profile" {
  name = "ec2_codecommit_instance_profile"
  role = aws_iam_role.EC2_CodeCommit_ReadOnly_role.name
}


## User's profiles and autopassword generation (testing)

# resource "aws_iam_user_login_profile" "user_logins" {
#   for_each = var.user_names
#   user    = each.key
#   pgp_key = "keybase:carlosandresh"
#   password_length = 20
#   password_reset_required = true
# }


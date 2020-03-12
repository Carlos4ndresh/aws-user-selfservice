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

resource "aws_iam_group" "non_privileged" {
    name = "non_privileged_users"
}

resource "aws_iam_group" "qa_engineers" {
    name = "qa_engineers"
}

resource "aws_iam_group" "devops_engineers" {
    name = "devops_engineers"
}

# Policy Creation

resource "aws_iam_policy" "UserSelfManagement" {
  name        = "IAMUser_SelfManagement"
  path        = "/"
  description = "Password and account Policy for non-administrator users, interns and mentors"

  policy = file("./iam/policies/Non_PrivilegedUsers_IAM_Selfmanagement.json")

}

resource "aws_iam_policy" "UserMFASelfmanagement" {
  name        = "IAMUser_MFASelfManagement"
  path        = "/"
  description = "MFA Policy for non-administrator users, interns and mentors"

  policy = file("./iam/policies/Non_PrivilegedUsers_MFA_Policy.json")
}

resource "aws_iam_policy" "user_creation_lambda_execution_policy" {
  name        = "user_creation_lambda_execution_policy"
  path        = "/"
  description = "Lambda execution policy for the user creation lambda function"

  policy = file("./iam/policies/user_creation_lambda_iam_policy.json")
}

resource "aws_iam_policy" "Interns_CodeCommit_Policy" {
  name        = "Interns_CodeCommit_Policy"
  path        = "/"
  description = "CodeCommit Policy for non devops interns"

  policy = file("./iam/policies/Interns_CodeCommit_Policy.json")
}

data "aws_iam_policy" "AWSCodeCommitFullAccess" {
  arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

## Temporary policies
resource "aws_iam_policy" "temporary_circleciworkshop_policy" {
  name        = "temporary_circleciworkshop_policy"
  path        = "/"
  description = "Temporary permissions for the CircleCI workshop. Responsible: william.munoz"

  policy = file("./iam/policies/Temporary_CircleCIWorkshop_Services.json")
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
}


# Policy Attachment section

resource "aws_iam_role_policy_attachment" "user_creation_lambda_role_attachment" {
  role       =  aws_iam_role.user_creation_lambda_role.name
  policy_arn =  aws_iam_policy.user_creation_lambda_execution_policy.arn
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

resource "aws_iam_group_policy_attachment" "CodeCommitRestrictedAttachment_Interns" {
  group      = aws_iam_group.interns.id
  policy_arn = aws_iam_policy.Interns_CodeCommit_Policy.arn
}

## Temporary policies attachment

# resource "aws_iam_group_policy_attachment" "TemporaryCircleCIPolicyAttachmentInterns" {
#     group = aws_iam_group.interns-devops.id
#     policy_arn = aws_iam_policy.temporary_circleciworkshop_policy.arn
# }

resource "aws_iam_group_policy_attachment" "TemporaryCircleCIPolicyAttachmentDevOps" {
    group = aws_iam_group.devops_engineers.id
    policy_arn = aws_iam_policy.temporary_circleciworkshop_policy.arn
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

## User's profiles and autopassword generation (testing)

# resource "aws_iam_user_login_profile" "user_logins" {
#   for_each = var.user_names
#   user    = each.key
#   pgp_key = "keybase:carlosandresh"
#   password_length = 20
#   password_reset_required = true
# }


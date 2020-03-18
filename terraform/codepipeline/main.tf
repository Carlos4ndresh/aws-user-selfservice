resource "aws_iam_role" "terraform_iam_codebuild_role" {
  name = "terraform_iam_codebuild_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "terraform_iam_codebuild_role_policy" {
  name = "terraform-iam-codebuild-role-policy"
  role = aws_iam_role.terraform_iam_codebuild_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "FullIAMAccess",
      "Action": "iam:*",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "S3CodePipelineAccess",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject",
        "s3:ListBucket",
        "s3:DeleteObject",
        "s3:PutBucketAcl",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "CodeBuildFullAccessOnSelf",
      "Action": "codebuild:*",
      "Effect": "Allow",
      "Resource": "${aws_codebuild_project.terraform_iam_codebuild_project.id}"
    },
    {
      "Sid": "CloudwatchLogsManagement",
      "Action": [
        "logs:CreateLogDelivery",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DeleteLogDelivery",
        "logs:DeleteLogGroup",
        "logs:DeleteLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "KMSFullAccess",
      "Action": [
        "kms:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:kms:us-east-1:446416709302:key/a622e642-62a5-425f-9e29-701275844430"
    },
    {
      "Sid": "DynamoDBLockAccess",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:DeleteItem",
        "dynamodb:UpdateItem"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:us-east-1:446416709302:table/terraform-endava-med-lock"
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "terraform_iam_codebuild_project" {
  name          = "terraform_iam_codebuild_project"
  description   = "Codebuild project to run terraform IAM related code"
  build_timeout = "60"
  service_role  = aws_iam_role.terraform_iam_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

  tags = {
    Provisioner = var.provisioner,
    env = "Production"
  }
}

resource "aws_s3_bucket" "terraform_iam_artifact_bucket" {
  bucket = "terraform-iamusers-med-artifact-bucket"
  acl    = "private"
  force_destroy = true

  tags = {
    Provisioner        = var.provisioner
    Environment = "Production"
  }
}

resource "aws_kms_key" "artifact_encryption_key" {
  description             = "KMS key for artifact encryption"
  deletion_window_in_days = 10
  tags = {
    Provisioner = var.provisioner
    Environment = "Production"
    KeyName = "Artifact Encryption Key"
  }

}


resource "aws_codepipeline" "terraform_iam_codepipeline" {
  name     = "terraform_iam_codepipeline"
  role_arn = var.codepipeline_terraform_role.arn

  artifact_store {
    location = aws_s3_bucket.terraform_iam_artifact_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.artifact_encryption_key.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        RepositoryName = var.repo_name
        BranchName = var.repo_branch
      }
    }
  }

  stage {
    name = "Build_Create_Infra"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terraform_iam_codebuild_project.name
      }
    }
  }
}
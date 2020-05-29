resource "aws_lambda_function" "submitUserCreation" {
  filename         = "../functions/submitUserCreation.zip"
  function_name    = "submitUserCreation"
  role             = var.user_creation_lambda_role
  handler          = "submitUserCreation.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("../functions/submitUserCreation.zip")
  runtime          = "python3.8"

  environment {
    variables = {
      env = "production",
      owner = "cherrera",
      project = "infrastructure management",
      provisioner = var.provisioner
    }
  }
}
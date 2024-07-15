provider "aws" {
  region = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
}

# Create a new IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "teraform_aws_lambda_role"
  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Sid": ""
    }
  ]
}
EOF
}

#IAM policy for the Lambda function
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
  role       = aws_iam_role.lambda_role.name
}

# Generate an archive from content, a file, or a directory of files
#data "archive_file" "lambda_zip" {
#  type        = "zip"
#  source_dir  = "${path.module}/src"
#  output_path = "${path.module}/aws-lambda-springboot.zip"
#}

# Create a new Lambda function
resource "aws_lambda_function" "terraform_lambda_func"{
  function_name = "terraform_lambda_function"
  role = aws_iam_role.lambda_role.arn
  handler = "com.gary.StreamLambdaHandler::handleRequest"
  runtime = "java17"
  filename = "${path.module}/target/aws-lambda-springboot-1.0-SNAPSHOT-lambda-package.zip"
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

# outputs
output "terraform_aws_role_output" {
  value = aws_iam_role.lambda_role.name
}
output "terraform_aws_role_arn_output" {
  value = aws_iam_role.lambda_role.arn
}
output "terraform_logging_arn_output" {
  value = aws_iam_policy.iam_policy_for_lambda.arn
}
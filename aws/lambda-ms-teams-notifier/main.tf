/*--------------------------------------------------------------
  This file includes main features of the module
  @maintainer:  nora.schille@codecamp-n.com

  some help: https://advancedweb.hu/how-to-define-lambda-code-with-terraform/
--------------------------------------------------------------*/
/*--------------------------------------------------------------
   zip the code
--------------------------------------------------------------*/
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/tmp/lambda_zip.zip"
  source_dir  = "${path.module}/src"
}

/*--------------------------------------------------------------
   lambda function
--------------------------------------------------------------*/
resource "aws_lambda_function" "ms-teams-notifier" {
  count = var.enabled ? 1 : 0
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = join("-", [ var.project, "ms-teams-notifier"])
  role             = aws_iam_role.ms-teams-notifier[0].arn
  description      = "Streams your CW alarm messages to MS Teams"
  handler          = "ms-teams-notifier.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  publish          = true
  memory_size      = "128"
  timeout          = "3"

  environment {
    variables = {
      WEBHOOK_URL = var.webhook_url
    }
  }
}

/*--------------------------------------------------------------
   lambda roles and policies
--------------------------------------------------------------*/
resource "aws_iam_role" "ms-teams-notifier" {
  count = var.enabled ? 1 : 0
  name = join("-", [var.project, "lambda", "ms-teams-notifier", "role"])
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ms-teams-notifier" {
  count = var.enabled ? 1 : 0
  name = join("-", [var.project, "lambda", "ms-teams-notifier", "policy"])
  policy = <<EOF
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

resource "aws_iam_policy_attachment" "ms-teams-notifier" {
  count = var.enabled ? 1 : 0
  name       = "ms-teams-notifier-policy"
  roles      = [aws_iam_role.ms-teams-notifier[0].name]
  policy_arn = aws_iam_policy.ms-teams-notifier[0].arn
}

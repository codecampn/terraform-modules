/*--------------------------------------------------------------
  This file includes main features of the module
  @maintainer:  nora.schille@codecamp-n.com
--------------------------------------------------------------*/
locals {
  stack_name = join("-", ["fargate-service-trigger", var.stage])
}

data "aws_caller_identity" "current" {}

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
resource "aws_lambda_function" "trigger" {
  count            = var.enabled ? 1 : 0
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = join("-", [var.project, local.stack_name])
  role             = aws_iam_role.trigger[0].arn
  description      = "triggered start or stop of fargate services"
  handler          = "fargate-service-trigger.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  publish          = true
  memory_size      = "128"
  timeout          = "3"

  environment {
    variables = {
      ECS_CLUSTER       = var.ecs_cluster
      ECS_SERVICE_NAMES = "${jsonencode(var.ecs_service_names)}"
    }
  }
}

/*--------------------------------------------------------------
   lambda roles and policies
--------------------------------------------------------------*/
resource "aws_iam_role" "trigger" {
  count              = var.enabled ? 1 : 0
  name               = join("-", [var.project, "lambda", local.stack_name, "role"])
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

# only describe dev resources
resource "aws_iam_policy" "trigger" {
  count  = var.enabled ? 1 : 0
  name   = join("-", [var.project, "lambda", local.stack_name, "policy"])
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
    },
    {
      "Sid": "ECSServicePolicy",
      "Effect": "Allow",
      "Action": [
        "ecs:describeServices",
        "ecs:updateServices",
      ],
      "Resource": "${join(":", ["arn:aws:ecs", var.region, data.aws_caller_identity.current.account_id, "cluster/${var.ecs_cluster}"])}"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "trigger" {
  count      = var.enabled ? 1 : 0
  name       = local.stack_name
  roles      = [aws_iam_role.trigger[0].name]
  policy_arn = aws_iam_policy.trigger[0].arn
}

resource "aws_lambda_permission" "start" {
  count         = var.enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start[0].arn
}

resource "aws_lambda_permission" "stop" {
  count         = var.enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop[0].arn
}

/*--------------------------------------------------------------
   cloudwatch event
--------------------------------------------------------------*/
resource "aws_cloudwatch_event_rule" "start" {
  count       = var.enabled ? 1 : 0
  name        = join("-", [var.project, local.stack_name])
  description = "triggers start of ECS fargate services"

  schedule_expression = var.start_scheduled_expression
  is_enabled          = var.start_trigger_enabled
}

resource "aws_cloudwatch_event_target" "start" {
  count     = var.enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.start[0].name
  target_id = "StartECSFargateServices"
  arn       = aws_lambda_function.trigger[0].arn
  input     = "{\"status\":\"start\"}"
}

resource "aws_cloudwatch_event_rule" "stop" {
  count       = var.enabled ? 1 : 0
  name        = join("-", [var.project, local.stack_name])
  description = "triggers stop of ECS fargate services"

  schedule_expression = var.stop_scheduled_expression
  is_enabled          = var.stop_trigger_enabled
}

resource "aws_cloudwatch_event_target" "stop" {
  count     = var.enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.stop[0].name
  target_id = "StopECSFargateServices"
  arn       = aws_lambda_function.trigger[0].arn
  input     = "{\"status\":\"stop\"}"
}

/*--------------------------------------------------------------
  This file includes main features of the module
  @maintainer:  stefan.blos@codecamp-n.com

  helpful links:
    - https://medium.com/hackernoon/serverless-password-protecting-a-static-website-in-an-aws-s3-bucket-bfaaa01b8666

--------------------------------------------------------------*/

/*--------------------------------------------------------------
   Zip the code of the Lambda function
--------------------------------------------------------------*/
data "archive_file" "auth_function" {
    type        = "zip"
    output_path = "/tmp/auth-function.zip"
    source_dir  = "github.com/codecampn/terraform-modules/blob/master/lambda-edge-auth/src/auth-function"
}

/*--------------------------------------------------------------
   Lambda function
--------------------------------------------------------------*/
resource "aws_lambda_function" "auth_function" {
    provider         = aws.us_east_1
    filename         = data.archive_file.auth_function.output_path
    function_name    = var.function_name
    role             = aws_iam_role.lambda-at-edge.arn
    publish          = true
    handler          = "auth_function.handler"
    runtime          = "nodejs12.x"
    source_code_hash = filebase64sha256(data.archive_file.basic_auth.output_path)

    environment {
        variables = {
            authUser = var.username
            authPass = var.password
        }
    }
}

/*--------------------------------------------------------------
   Provider with necessary info
--------------------------------------------------------------*/
provider "aws" {
    alias = "us_east_1"
    region = "us-east-1"  
    profile = var.aws_profile_name
    shared_credentials_file = var.aws_credentials_path
}

/*--------------------------------------------------------------
   IAM role
--------------------------------------------------------------*/
resource "aws_iam_role" "lambda-at-edge" {
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          Effect : "Allow",
          Action : "sts:AssumeRole"
          Principal : {
            "Service" : [
              "lambda.amazonaws.com",
              "edgelambda.amazonaws.com"
            ]
          }
        }
      ]
    }
  )
}
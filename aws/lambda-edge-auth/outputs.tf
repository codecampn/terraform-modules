/*--------------------------------------------------------------
   ARN of the Lambda
--------------------------------------------------------------*/
output "lambda_arn" {
  value = aws_lambda_function.auth_function[0].arn
}

/*--------------------------------------------------------------
   Name of the Lambda
--------------------------------------------------------------*/
output "lambda_name" {
  value = aws_lambda_function.auth_function[0].function_name
}
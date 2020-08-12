output "lambda_arn" {
  value = var.enabled ? aws_lambda_function.ms-teams-notifier[0].arn : "n/a"
}
output "lambda_name" {
  value = var.enabled ? aws_lambda_function.ms-teams-notifier[0].function_name : "n/a"
}
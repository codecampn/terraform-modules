module "aws-lambda-fargate-service-trigger" {
  source                     = "../aws/lambda-fargate-service-trigger"
  project                    = "test"
  stage                      = "test"
  region                     = "us-east-1"
  ecs_cluster                = "test_cluster"
  ecs_service_names          = ["test_service_name"]
  start_scheduled_expression = "cron(0 4 * * ? *)"
  stop_scheduled_expression  = "cron(0 20 * * ? *)"
}

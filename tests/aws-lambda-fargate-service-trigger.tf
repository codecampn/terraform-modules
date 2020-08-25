module "aws-lambda-fargate-service-trigger" {
  source                     = "../aws/aws-lambda-fargate-service-trigger"
  project                    = "test"
  stage                      = "test"
  ecs_cluster                = "test_cluster"
  ecs_service_names          = ["test_service_name"]
  start_scheduled_expression = "cron(0 4 * * ? *)"
  stop_scheduled_expression  = "cron(0 20 * * ? *)"
}

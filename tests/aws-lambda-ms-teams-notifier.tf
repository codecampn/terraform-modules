module "aws-lambda-ms-teams-notifier" {
  source = "../aws/lambda-ms-teams-notifier"
  project = "test"
  webhook_url = "test"
}
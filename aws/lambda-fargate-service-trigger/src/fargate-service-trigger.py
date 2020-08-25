import boto3
import logging
import os

client = boto3.client("ecs")

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
  logger.info("Event: " + str(event))
  status = event.get("status", "")
  ecs_service_names = json.loads(os.environ.get("ECS_SERVICE_NAMES"))
  if status == "" or status or not ecs_service_names:
    logger.info("nothing to do here")
    return

  desired_count = 0
  if status == "start":
    desired_count = 1

  if ecs_service_names:
    for service in ecs_service_names:
      try:
        logger.info("{0} is updated to desiredCount={1}".format(service, str(desired_count)))
        response = client.update_service(
          cluster=os.environ.get("ECS_CLUSTER"),
          service=service,
          desiredCount=desired_count
        )
      except Exception as exc:
        logger.error("Error in updating service with desiredCount={0} with message {1}".format(str(desired_count), str(exc)))
  else:
    logger.info("no service to update")
    return

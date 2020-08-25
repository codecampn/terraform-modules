# Terraform Module: ECS Fargate Start-Stop Trigger
## Table of Contents

1. [Scope](#scope)
2. [Used Services & Features](#services-and-features)
3. [Usage](#usage)
4. [Input](#input)
5. [Output](#output)
6. [Additional](#additional)
7. [Roadmap](#roadmap)
    
## Scope
This stack enabels start and/or stop triggers for ECS Fargate services mainly focused on adjusting the `desired count` property.

    
## Used Services & Features
* Cloudwacth Eventrule
* AWS Lambda including IAM Role and Policy and Trigger Permission
* Python 3.8 (no external libs used)

## Usage
```
module "ecs_fargate_service_trigger" {
    source = "git::https://github.com/codecampn/terraform-modules.git//aws/ecs-fargate-service-trigger"
    enabled = true
    
    project = "some-project"
    stage = "dev"
    ecs_resource_suffix = "*-dev"
    start_scheduled_expression = "cron(0 4 * * ? *)" # UTC; CEST(UTC +2): 6:00 
    start_trigger_enabled = true
    stop_scheduled_expression = "cron(0 20 * * ? *)" # UTC; CEST(UTC +2): 22:00 
    stop_trigger_enabled = true
  }
```

## Input
Variable | Description | Default Value
--- | --- | ---
project | the unique prefix you use for your lambda's function name, f.e. the project name | n/a
enabled | true, if the module shall be enabled | true
stage | the stage this stack is deployed to | n/a 
ecs_resource_suffix | the resource namimg suffix for policy attachement; '*' if all resources in ECS can be accessed through lambda | "*"
ecs_cluster | ECS cluster name | n/a
ecs_service_names | array of services which need to be updated | n/a
start_scheduled_expression | the cron job expression for starting ECS Fargate services | n/a
start_trigger_enabled | true, if  CW Event rule (trigger) for starting ECS Fargate services is enabled | true
stop_scheduled_expression | the cron job expression for stopping ECS Fargate services | n/a
stop_trigger_enabled |  true, if  CW Event rule (trigger) for stopping ECS Fargate services is enabled | true

## Output
Output | Description 
--- | --- 

## Additional
n/a

## Roadmap
These things can be improved/done:
* input of variable ECS service's `desired count` property

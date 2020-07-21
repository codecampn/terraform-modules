# Terraform Module: MS Teams Notifier

## Table of Contents

1. [Scope](#scope)
2. [Used Services & Features](#services-and-features)
3. [Usage](#usage)
4. [Input](#input)
5. [Output](#output)
6. [Additional](#additional)
7. [Roadmap](#roadmap)
    
## Scope
This function is just a notifier which pushes Cloudwatch Alarms messages (triggered via SNS) to MS Teams by using the channel's hook url.
    
## Used Services & Features
* AWS Lambda including IAM Role and Policy
* Python 3.8 (no external libs used)

## Usage
```
module "ms-team-notifier-lambda" {
    source = "git@github.com:codecampn/terraform-modules-aws-lambda-ms-teams-notifier.git"
    enabled = true
    
    project = "some-project"
    # hook for ms teams channel
    webhook_url = "<your teams channel hook url"
  }
```

## Input
Variable | Description | Default Value
--- | --- | ---
project | the unique prefix you use for your lambda's function name, f.e. the project name | n/a
enabled | true, if the module shall be enabled | true
webhook_url | the ms teams connector used for pushing messages | n/a 

## Output
Output | Description 
--- | --- 
ms-teams-notifier-lambda-arn | ARN of the lambda created

## Additional
* supported by:
  * [AWS Guide](https://aws.amazon.com/premiumsupport/knowledge-center/sns-lambda-webhooks-chime-slack-teams/)
  * [MS Teams Webhooks with Python](https://medium.com/@sebastian.phelps/aws-cloudwatch-alarms-on-microsoft-teams-9b5239e23b64)
* [MS Teams Connectors](https://docs.microsoft.com/de-de/microsoftteams/platform/webhooks-and-connectors/what-are-webhooks-and-connectors) 
* [MS Teams Message Card Playground](https://messagecardplayground.azurewebsites.net/)
 
## Roadmap
These things can be improved/done:
* enhance message output pushed to MS Teams: 
  * add link to alarm
  * enhance formatting

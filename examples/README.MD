# Terraform Module: my-fancy-module

## Table of Contents

1. [Scope](#scope)
2. [Used Services & Features](#services-and-features)
3. [Usage](#usage)
4. [Input](#input)
5. [Output](#output)
6. [Additional](#additional)
7. [Roadmap](#roadmap)

## Scope

This module is just a placeholder which dos nothing except of make headache because it have crazy circle dependency.

## Used Services & Features & Provider

- Written for AWS
- AWS Lambda including IAM Role and Policy

## Usage

```javascript
module "my-fancy-module" {
    source = "git@github.com:codecampn/aws/my-fancy-module.git"
    prefix = "some-fancy-project"
  }
```

## Input

| Variable | Description                              | Default Value |
| -------- | ---------------------------------------- | ------------- |
| prefix   | he unique prefix you use for your module | n/a           |
| .....    | .....                                    | true          |
| .....    | .....                                    | n/a           |

## Output

| Output | Description |
| ------ | ----------- |
| name   | .....       |

## Additional

- supported by:
  - [AWS Guide](https://aws.amazon.com/premiumsupport/knowledge-center/sns-lambda-webhooks-chime-slack-teams/)
  - [MS Teams Webhooks with Python](https://medium.com/@sebastian.phelps/aws-cloudwatch-alarms-on-microsoft-teams-9b5239e23b64)
- [MS Teams Connectors](https://docs.microsoft.com/de-de/microsoftteams/platform/webhooks-and-connectors/what-are-webhooks-and-connectors)
- [MS Teams Message Card Playground](https://messagecardplayground.azurewebsites.net/)

## Roadmap

These things can be improved/done:

- enhance message output pushed to MS Teams:
  - add link to alarm
  - enhance formatting

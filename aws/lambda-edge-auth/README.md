# Terraform Module: Lambda Edge Authentication

## Table of Contents

- [Terraform Module: Lambda Edge Authentication](#terraform-module-lambda-edge-authentication)
  - [Table of Contents](#table-of-contents)
  - [Scope](#scope)
  - [Used Services & Features](#used-services--features)
  - [Usage](#usage)
  - [Input](#input)
  - [Output](#output)
  - [Additional](#additional)
  - [Roadmap](#roadmap)

## Scope

This function is intended to use a Lambda@Edge function to handle authorization to a AWS hosted site.

## Used Services & Features

* AWS Lambda 
* Node.js 12.x (no external libs)

## Usage

```
module "lambda-edge-auth" {
    source = "git@github.com:codecampn/terraform-modules/lambda-edge-auth.git"

    project = "some-project"

    # function name (OPTIONAL: defaults to "auth-function-tf")
    function_name = "authentication-lambda"

    # Username for authentication
    username = "Max Power"

    # Password for authentication
    password = "abc123"

    # Name of AWS profile
    aws_profile_name = "Projectname"

    # Path to AWS credentials file
    aws_credentials_path = "~/.aws/credentials" // e.g. default on Mac
}
```

## Input

| Variable             | Description                                                                      | Default Value      |
| -------------------- | -------------------------------------------------------------------------------- | ------------------ |
| project              | The unique prefix you use for your lambda's function name, f.e. the project name | n/a                |
| function_name        | The name of the function as configured in AWS Lambda                             | "auth-function-tf" |
| username             | The username used for authentication.                                            | n/a                |
| password             | The password used for authentication.                                            | n/a                |
| aws_profile_name     | Name of AWS profile.                                                             | n/a                |
| aws_credentials_path | Path to AWS credentials file                                                     | n/a                |

## Output

| Output      | Description                |
| ----------- | -------------------------- |
| lambda_arn  | ARN of the lambda created  |
| lambda_name | Name of the lambda created |

## Additional

* [How to create a Lambda@Edge for this purpose](https://medium.com/hackernoon/serverless-password-protecting-a-static-website-in-an-aws-s3-bucket-bfaaa01b8666)

## Roadmap

* check if path to lambda source code is correct
* check if provider setting is working
* check if IAM role can be used in such fashion
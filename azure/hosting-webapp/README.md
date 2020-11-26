# Terraform Module: azure-hosting-webapp

## Table of Contents

- [Terraform Module: Lambda Edge Authentication](#terraform-module-lambda-edge-authentication)
  - [Table of Contents](#table-of-contents)
  - [Scope](#scope)
  - [Used Services & Features](#used-services--features)
  - [Usage](#usage)
  - [Input](#input)
  - [Output](#output)
  <!-- - [Additional](#additional)
  - [Roadmap](#roadmap) -->

## Scope

This module provides a storage account where the application can be stored and a CDN endpoint to make the web application available to the world.

## Used Services & Features

- azure storage_account
- azure cdn_profile
- azure cdn_endpoint

## Usage

```
module "azure_hosting_webapp" {
  source              = "git::https://github.com/codecampn/terraform-modules.git//azure/hosting-webapp"
  app_name            = "my_app"
  location            = "West Europe"
  environment         = "dev"
  resource_group_name = "my_resource_group"
  random_key          = "xyz"
}
```

## Input

| Variable             | Description                                                                      | Default Value      |
| -------------------- | -------------------------------------------------------------------------------- | ------------------ |
| app_name             | The unique prefix you use for your lambda's function name, f.e. the project name | n/a                |
| location             | The name of the function as configured in AWS Lambda                             | "auth-function-tf" |
| environment          | The username used for authentication.                                            | n/a                |
| resource_group_name  | The password used for authentication.                                            | n/a                |
| random_key           | Name of AWS profile.                                                             | n/a                |
| aws_credentials_path | Path to AWS credentials file                                                     | n/a                |

## Output

| Output | Description |
| ------ | ----------- |
|        |             |

## Additional

## Roadmap

/*--------------------------------------------------------------
   Basics
--------------------------------------------------------------*/
variable "project" {
  description = "The unique prefix you use for your lambda's function name, e.g. the project name."
  type = string
}

/*--------------------------------------------------------------
   Lambda related
--------------------------------------------------------------*/
variable "function_name" {
  description = "The name of the function as registered in AWS"
  default = "auth-function-tf"
  type = string
}

/*--------------------------------------------------------------
   AWS credentials
--------------------------------------------------------------*/
variable "aws_profile_name" {
    description = "The name of the AWS profile to use."
    type = string
}

variable "aws_credentials_path" {
    description = "The path to the AWS credentials file."
    type = string
}

/*--------------------------------------------------------------
   Auth credentials
--------------------------------------------------------------*/
variable "username" {
    description = "The username for the page that will be protected."
    type = string
}

variable "password" {
    description = "The password for the page that will be protected."
    type = string
}
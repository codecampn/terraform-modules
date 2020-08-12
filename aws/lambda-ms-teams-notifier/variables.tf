/*--------------------------------------------------------------
   Basics
--------------------------------------------------------------*/
variable "project" {
  description = "the unique prefix you use for your lambda's function name, f.e. the project name"
  type = string
}

variable "enabled" {
  description = "true, if the module shall be enabled"
  default = true
}

/*--------------------------------------------------------------
   Lambda related
--------------------------------------------------------------*/
variable "webhook_url" {
  description = "the ms teams connector used for pushing messages"
  type = string
}


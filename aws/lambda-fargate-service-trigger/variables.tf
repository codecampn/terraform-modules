/*--------------------------------------------------------------
   Basics
--------------------------------------------------------------*/
variable "project" {
  description = "the unique prefix you use for your lambda's function name, f.e. the project name"
  type        = string
}

variable "enabled" {
  description = "true, if the module shall be enabled"
  default     = true
}

variable "stage" {
  description = "the stage this stack is deployed to"
  type        = string
}

/*--------------------------------------------------------------
   Lambda related
--------------------------------------------------------------*/
variable "ecs_cluster" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_service_names" {
  description = "array of services which need to be updated"
  type        = list(string)
}

/*--------------------------------------------------------------
   Cloudwatch Eventrule related
--------------------------------------------------------------*/
variable "start_scheduled_expression" {
  description = "the cron job expression for starting ECS Fargate services"
  type        = string
}

variable "stop_scheduled_expression" {
  description = "the cron job expression for stopping ECS Fargate services"
  type        = string
}

variable "start_trigger_enabled" {
  description = "true, if  CW Event rule (trigger) for starting ECS Fargate services is enabled"
  type        = bool
  default     = true

}

variable "stop_trigger_enabled" {
  description = "true, if  CW Event rule (trigger) for stopping ECS Fargate services is enabled"
  type        = bool
  default     = true
}

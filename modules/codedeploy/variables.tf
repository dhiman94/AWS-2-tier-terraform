variable "app_name" {
  type = string
  description = "Name of the codedeploy application"
}

variable "deployment_group_name" {
  type = string
  description = "Name of the deployment group"
}

variable "codedeploy_service_role_arn" {}


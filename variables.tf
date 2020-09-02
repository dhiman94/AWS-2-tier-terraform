variable region {
  type        = string
  description = "region in which u want to deploy"
  default     = "ap-south-1"
}

variable "app_name" {
    type = string
    description = "name of codedeploy app"
    default = "spring-maven-app"
}

variable "deployment_group_name" {
    type = string
    description = "name of codedeploy deployment group"
    default = "spring-maven-deployment-group"
}

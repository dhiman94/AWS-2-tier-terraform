terraform {
  experiments = [variable_validation]
}

variable "instance_type_to_env" {
  description = "maps ec2 instance type to environment"
  type        = map
  default = {
    "dev"   = "t2.micro"
    "stage" = "t3.small"
    "prod"  = "m4.large"
  }
}

variable "env_name" {
  description = "infra environment(eg: dev, stage, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = var.env_name == "dev" || var.env_name == "stage" || var.env_name == "prod"
    error_message = "Invalid environment name.Please select either dev or stage or prod."

  }
}

variable "app_ami_id" {
  description = "custom ami created for tomcat server"
  default     = "ami-0d6edafd83d77276a"
}

variable "tomcat_server_sg" {
  description = "put sg of tomcat server"
}

variable "asg_subnet_ids" {
  description = "list of private subnets in custom vpc"
  type        = list
}

variable "alb_tg_arn" {
  description = "application load balancer target group arn"
}


# create codedeploy application
resource "aws_codedeploy_app" "spring_maven" {
  compute_platform = "Server"
  name             = var.app_name
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.spring_maven.name
}

# create codedeploy deployment group
resource "aws_codedeploy_deployment_group" "spring_maven_deployment_group"{
  app_name = aws_codedeploy_app.spring_maven.name
  deployment_group_name = var.deployment_group_name 
  service_role_arn      = var.codedeploy_service_role_arn

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "tomcat"
    }

    ec2_tag_filter {
      key   = "Deployment"
      type  = "KEY_AND_VALUE"
      value = "Codedeploy"
    }
  }

}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.spring_maven_deployment_group.id
}

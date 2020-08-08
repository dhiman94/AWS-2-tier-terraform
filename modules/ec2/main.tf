# create launch config for app server
resource "aws_launch_configuration" "tomcat_launch_config" {
  name                        = "tomcat_launch_config"
  image_id                    = var.app_ami_id
  instance_type               = lookup(var.instance_type_to_env, var.env_name, "t2.micro")
  security_groups             = [var.tomcat_server_sg]
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

# create asg from launch config
resource "aws_autoscaling_group" "tomcat_asg" {
  name                      = "tomcat_asg"
  launch_configuration      = aws_launch_configuration.tomcat_launch_config.name
  min_size                  = 2
  max_size                  = 6
  desired_capacity          = 4
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.asg_subnet_ids
  target_group_arns         = [var.alb_tg_arn]
  force_delete              = true


  lifecycle {
    create_before_destroy = true
  }
}

# scale up policy 
resource "aws_autoscaling_policy" "tomcat_server_scale_up" {
  name                   = "tomcat_server_scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.tomcat_asg.name
}

# scale in policy
resource "aws_autoscaling_policy" "tomcat_server_scale_in" {
  name                   = "tomcat_server_scale_in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.tomcat_asg.name
}

# cloudwatch alarm for tomcat scale up
resource "aws_cloudwatch_metric_alarm" "tomcat_scale_up_alarm" {
  alarm_name          = "tomcat_scale_up_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.tomcat_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization and triggers alarm when cpuutilization >= 70"
  alarm_actions     = [aws_autoscaling_policy.tomcat_server_scale_up.arn]
}

# cloudwatch alarm for tomcat scale in
resource "aws_cloudwatch_metric_alarm" "tomcat_scale_in_alarm" {
  alarm_name          = "tomcat_scale_in_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.tomcat_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization and triggers alarm when cpuutilization >= 70"
  alarm_actions     = [aws_autoscaling_policy.tomcat_server_scale_in.arn]
}

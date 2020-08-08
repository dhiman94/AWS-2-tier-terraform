#create application load balancer
resource "aws_lb" "alb" {
  name               = "apploadbalancer"
  internal           = false 
  load_balancer_type = "application"
  security_groups    = [var.lb_sg_id]
  subnets            = var.lb_public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

# create alb HTTP listener on port 80 
resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

# create target group for alb
resource "aws_lb_target_group" "alb_target_group" {
  name        = "AlbTargetGroup"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    interval            = 6
    path                = "/"
    port                = 8080
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 5
  }
}

output "out_target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}


# tomcat server(deployed in private subnet) sg 
resource "aws_security_group" "tomcat_server_sg" {
  name        = "tomcat_server_sg"
  description = "App server security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "out_tomcat_server_sg_id" {
  value = aws_security_group.tomcat_server_sg.id
}

# application load balancer sg
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "application load balancer security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "out_alb_sg_id" {
  value = aws_security_group.alb_sg.id
}



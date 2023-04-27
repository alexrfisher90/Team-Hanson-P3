####################################################
# Application Load balancer
####################################################

resource "aws_lb" "lb" {
  name               = "snakeALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_default_security_group.default.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public2[0].id]
}

####################################################
# Listner
####################################################

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.snakeTargetGroup.arn
  }
}

resource "aws_lb_target_group" "snakeTargetGroup" {
  name     = "snakeTargets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

####################################################
# Listener Rule
####################################################

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.snakeTargetGroup.arn

  }

  condition {
    path_pattern {
      values = ["/var/www/html/index.html"]
    }
  }
}

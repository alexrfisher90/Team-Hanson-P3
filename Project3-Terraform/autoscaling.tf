resource "aws_launch_configuration" "as_conf" {
  name_prefix                 = "SnakeGame"
  image_id                    = data.aws_ami.amazon-linux.id
  key_name                    = "Hanson"
  instance_type               = "t3.micro"
  associate_public_ip_address = "true"
  lifecycle {
    create_before_destroy = true
  }
  user_data = file("user.sh")
}

resource "aws_autoscaling_group" "bar" {
  name                 = "${aws_launch_configuration.as_conf.name}-asg"
  launch_configuration = aws_launch_configuration.as_conf.name
  desired_capacity     = 2
  min_size             = 0
  max_size             = 2
  target_group_arns    = ["${aws_lb_target_group.snakeTargetGroup.arn}"]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier = [
    "${aws_subnet.public[0].id}",
    "${aws_subnet.public2[0].id}"
  ]
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "SnakeGameEC2"
    propagate_at_launch = true
  }
  tag {
    key                 = "name"
    value               = "snakegameEC2"
    propagate_at_launch = true
  }
}

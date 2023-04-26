#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["782863115905] # Canonical
# }

resource "aws_launch_configuration" "as_conf" {
  name_prefix                 = "snake-asg"
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
  name_prefix          = "snake-asg"
  launch_configuration = aws_launch_configuration.as_conf.name
  availability_zones   = ["us-east-1a", "us-east-1b"]
  min_size             = 2
  max_size             = 2

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

  lifecycle {
    create_before_destroy = true
  }
}

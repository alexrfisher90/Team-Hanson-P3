data "aws_availability_zones" "availability_zone" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
  state = "available"
}
# data "aws_ssm_parameter" "instance_ami" {
#   name = "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-gp2"
# }

data "aws_ami" "amazon-linux" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

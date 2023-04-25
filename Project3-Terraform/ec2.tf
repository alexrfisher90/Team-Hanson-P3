resource "aws_instance" "main" {
  depends_on             = [aws_internet_gateway.main_igw]
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = "t3.micro"
  key_name               = "Hanson"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_vpc.main.default_security_group_id]
  tags = {
    "Name" = "${var.default_tags.env}-EC2"
  }
  user_data = base64encode(file("C:/Users/thegy/Desktop/Skillstorm/Team-Hanson-P3/Project3-Terraform/user.sh"))
}
output "ec2_ssh_command" {
  value = "ssh -i Hanson.pem linux@ec2-${replace(aws_instance.main.public_ip, ".", "-")}.compute-1.amazonaws.com"
}

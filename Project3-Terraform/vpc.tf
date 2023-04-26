terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# #Lambda zip
# provider "archive" {}
# data "archive_file" "zip" {
#   type        = "zip"
#   source_dir  = "C:\\Users\\thegy\\Desktop\\Skillstorm\\Project3\\Project3-Terraform\\lambda"
#   output_path = "index.zip"
# }


# Create VPC; CIDR 10.0.0.0/16
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    "Name" = "${var.default_tags.env}-VPC"
  }
}

resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "All in"
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    self        = true
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound Rules
  egress {
    description = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Public Subnets 10.0.0.0/24
resource "aws_subnet" "public" {
  count      = var.public_subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  # netnum = number to change based on subnet addition: 1st subnet 10.0.0.0/24. 10.0.1.0/24, 10.0.2.0/24
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.default_tags.env}-Public-Subnet-${data.aws_availability_zones.availability_zone.names[count.index]}"
  }
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public2" {
  count      = var.public_subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.public_subnet_count)
  # netnum = number to change based on subnet addition: 1st subnet 10.0.0.0/24. 10.0.1.0/24, 10.0.2.0/24
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.default_tags.env}-Public2-Subnet-${data.aws_availability_zones.availability_zone.names[count.index]}"
  }
  availability_zone = "us-east-1b"
}

# IGW
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id #attachement

  tags = {
    "Name" = "${var.default_tags.env}-IGW"
  }
}

# EIP
resource "aws_eip" "NAT_EIP" {
  vpc = true
}



# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.default_tags.env}-Public-RT"
  }
}
# Public Routes - for route table
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}
# Public Route Table Association
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public2.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Naming Elastic IP
resource "aws_eip" "elastic_ip" {
  tags = {
    Name = "Hanson-eip"
  }
}

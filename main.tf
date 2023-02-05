provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.96.0/20"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_instance" "webapp_server" {
  ami                  = data.aws_ami.latest_amazon_linux.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.public_subnet.id
  iam_instance_profile = "LabInstanceProfile"
  security_groups      = [aws_security_group.webapp_sg.id]

  tags = {
    Name = "webapp-server"
  }
}

resource "aws_ecr_repository" "webapp_images" {
  name = "webapp-images"
}

resource "aws_ecr_repository" "mysql_images" {
  name = "mysql-images"
}

resource "aws_security_group" "webapp_sg" {
  name        = "webapp-security-group"
  description = "Security group for webapp server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webapp-security-group"
  }
}
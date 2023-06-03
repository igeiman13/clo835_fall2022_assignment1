provider "aws" {
  region = "us-east-1"
}

#using default vpc
data "aws_vpc" "default" {
  default = true
}

#creating public subnet within default vpc
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.96.0/20"
  map_public_ip_on_launch = true

  tags   = {
    Name = "public_subnet_1"
  }
}

#creating security group
resource "aws_security_group" "instance" {
  name        = "instance1-instance-sg"
  description = "Allow SSH access and http"
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
    
  ingress {
    from_port   = 8083
    to_port     = 8083
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

#created ec2 instance with hardcoded ami-id 
resource "aws_instance" "instance1" {
  ami                    = "ami-0aa7d40eeae50c9a9"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.instance.id]
  iam_instance_profile   = "LabInstanceProfile"
  key_name               = "clo835assign"
  
  tags   = {
    Name = "instance1"
  }
}

#creating ECR repositories
resource "aws_ecr_repository" "application_repository" {
  name = "application-repository"
}

resource "aws_ecr_repository" "database_repository" {
  name = "database-repository"
}
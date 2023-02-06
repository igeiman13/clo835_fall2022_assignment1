terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Data source for AMI id
data "aws_ami" "amilinixass1" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_instance" "akash" {
  ami           = data.aws_ami.amilinixass1.id
  instance_type = var.instance_type
  key_name                    = aws_key_pair.akashkikey.key_name
  vpc_security_group_ids      = [aws_security_group.akashsecurites.id]
}

# Create a new VPC 
data "aws_vpc" "vpc" {
  default = true
  
}
# Security Group
resource "aws_security_group" "akashsecurites" {
  name        = "allow_ssh"
  description = "allowing inbound ssh traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  # Opening ports for application to access 
  ingress {
    description = "Blue"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Red"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Green"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  }
  
  # Adding SSH key to Amazon EC2
resource "aws_key_pair" "akashkikey" {
  key_name   = local.name_prefix
  public_key = file("${local.name_prefix}.pub")
}

# Define tags locally
locals {
  default_tags = merge(module.globalvariables.default_tags, { "env" = var.env })
  prefix       = module.globalvariables.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}
module "globalvariables" {
  source = "/home/ec2-user/environment/clo835_fall2022_assignment1/Global Variables"
}

# Creating ecr repositories
resource "aws_ecr_repository" "akashwebecrrepo" {
  name                 = "akashwebecrrepo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "akashdbrepo" {
  name                 = "akashdbrepo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
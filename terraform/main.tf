# Define the provider
provider "aws" {
  region = "us-east-1"
}




# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}


# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}



# Create VPC 
resource "aws_vpc" "main" {
  default = true
}


# Create webserver 1
resource "aws_instance" "ws1" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  #subnet_id                   = data.terraform_remote_state.network_dev.outputs.private_subnet_dev[0]
  security_groups             = [aws_security_group.sg_web.id]
  associate_public_ip_address = false
  



  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "drdobariya_ws1"
    }
  )
}





# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.prefix_main
  public_key = file("${local.prefix_main}.pub")
}


# Security Group For ws1
resource "aws_security_group" "sg_web" {
  name        = "webserver traffic"
  description = "webserver traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups  = [aws_security_group.sg_b.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups  = [aws_security_group.sg_b.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "drdobariya_sg_web"
    }
  )
}
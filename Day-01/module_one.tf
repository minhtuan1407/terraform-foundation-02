##############################################################################
# VARIABLES
##############################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
  
variable "key_name" {}

variable "private_key_path" {}

variable "region" {
    default = "ap-southeast-1"
}

##############################################################################
# PROVIDERS
##############################################################################

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     = var.region
}

##############################################################################
# DATA
##############################################################################

data "aws_ami" "aws_linux" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn-ami-hvm-*"]
    }
    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

##############################################################################
# RESOURCES
##############################################################################

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.aws_linux.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    connection {
        type     = "ssh"
        host     = self.public_ip
        user     = "ec2-user"
        private_key = file(var.private_key_path)
    }

    provisioner "remote-exec" {
      inline = [
          "sudo yum install -y nginx",
          "sudo service nginx start",
          "sudo rm /usr/share/nginx/html/index.html",
          "sudo echo 'Hello Terraform' > /usr/share/nginx/html/index.html"
      ]
    }
}

##############################################################################
# OUTPUTS
##############################################################################

output "aws_instance_public_dns" {
  value = aws_instance.web.public_dns
  description = "Public DNS of nginx"
}

output "aws_instance_private_dns" {
  value = aws_instance.web.private_dns
  description = "Private DNS of nginx"
}

output "aws_instance_arn" {
  value = aws_instance.web.arn
  description = "ARN"
}
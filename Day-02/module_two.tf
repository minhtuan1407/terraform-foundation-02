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

variable "network_address_space" {
    description = "Address space for VPC"
    default = "10.1.0.0/16"
}

variable "subnet1_address_space" {
    description = "Address space for subnet1"
    default = "10.1.0.0/24"
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

data "aws_availability_zones" "available" {}

##############################################################################
# RESOURCES
##############################################################################

resource "aws_vpc" "vpc" {
    cidr_block = var.network_address_space
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet1_address_space
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_route_table" "rtp" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rtb-subnet1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtp.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

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
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.aws_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet1.id
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
          "sudo service nginx start"
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
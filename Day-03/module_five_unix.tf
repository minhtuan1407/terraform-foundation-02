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
  default     = "10.1.0.0/16"
}

variable "subnet1_address_space" {
  description = "Address space for subnet1"
  default     = "10.1.0.0/24"
}

variable "subnet2_address_space" {
  description = "Address space for subnet1"
  default     = "10.1.1.0/24"
}

variable "bucket_name_prefix" {}

variable "billing_code_tag" {}

variable "environment_tag" {}

##############################################################################
# PROVIDERS
##############################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

##############################################################################
# LOCAL
##############################################################################

locals {
  common_tags = {
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
  }

  s3_bucket_name = "${var.bucket_name_prefix}-${var.environment_tag}-${random_integer.rand.result}"
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

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "aws_vpc" "vpc" {
  cidr_block = var.network_address_space
  tags       = merge(local.common_tags, { Name = "${var.environment_tag}-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.common_tags, { Name = "${var.environment_tag}-igw" })
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet1_address_space
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags                    = merge(local.common_tags, { Name = "${var.environment_tag}-subnet1" })
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet2_address_space
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags                    = merge(local.common_tags, { Name = "${var.environment_tag}-subnet2" })
}

##############################################################################
# ROUTING
##############################################################################

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-rtb" })
}

resource "aws_route_table_association" "rtp-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rtp-subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_security_group" "elb-sg" {
  name   = "nginx-elb-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-elb-sg" })
}

resource "aws_security_group" "allow_ssh" {
  name        = "nginx-demo"
  description = "Allow ports for nginx demo"
  vpc_id      = aws_vpc.vpc.id

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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-nginx" })
}

resource "aws_elb" "nginx" {
  name            = "nginx-demo"
  subnets         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  security_groups = [aws_security_group.elb-sg.id]
  instances       = [aws_instance.nginx1.id, aws_instance.nginx2.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-elb" })
}

resource "aws_instance" "nginx1" {
  ami                    = data.aws_ami.aws_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet1.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [aws_iam_role_policy.allow_s3_all]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    content     = <<EOF
  access_key =
  secret_key = 
  security_token = 
  use_https = True
  bucket_location = US
    
  EOF
    destination = "/home/ec2-user/.s3cfg"
  }

  provisioner "file" {
    content = <<EOF
/var/log/nginx/*log {
    daily
    rotate 10
    missingok
    compress
    sharedscripts
    postrotate
    endscript
    lastaction
        INSTANCE_ID=`curl --silent http://169.254.169.254/latest/meta-data/instance-id`
        sudo /usr/local/bin/s3cmd sync --config=/home/ec2-user/.s3cfg /var/log/nginx/ s3://${aws_s3_bucket.web_bucket.id}/nginx/$INSTANCE_ID/
    endscript
}
EOF
    destination = "/home/ec2-user/nginx"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo cp /home/ec2-user/.s3cfg /root/.s3cfg",
      "sudo cp /home/ec2-user/nginx /etc/logrotate.d/nginx",
      "sudo pip install s3cmd",
      "s3cmd get s3://${aws_s3_bucket.web_bucket.id}/website/index.html",
      "s3cmd get s3://${aws_s3_bucket.web_bucket.id}/website/terraformio-logo.png",
      "sudo rm /usr/share/nginx/html/index.html",
      "sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html",
      "sudo cp /home/ec2-user/terraformio-logo.png /usr/share/nginx/html/terraformio-logo.png",
      "sudo logrotate -f /etc/logrotate.d/nginx"
    ]
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-nginx1" })
}

resource "aws_instance" "nginx2" {
  ami                    = data.aws_ami.aws_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet2.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [aws_iam_role_policy.allow_s3_all]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    content     = <<EOF
  access_key =
  secret_key = 
  security_token = 
  use_https = True
  bucket_location = US
    
  EOF
    destination = "/home/ec2-user/.s3cfg"
  }

  provisioner "file" {
    content = <<EOF
/var/log/nginx/*log {
    daily
    rotate 10
    missingok
    compress
    sharedscripts
    postrotate
    endscript
    lastaction
        INSTANCE_ID=`curl --silent http://169.254.169.254/latest/meta-data/instance-id`
        sudo /usr/local/bin/s3cmd sync --config=/home/ec2-user/.s3cfg /var/log/nginx/ s3://${aws_s3_bucket.web_bucket.id}/nginx/$INSTANCE_ID/
    endscript
}
EOF

    destination = "/home/ec2-user/nginx"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo cp /home/ec2-user/.s3cfg /root/.s3cfg",
      "sudo cp /home/ec2-user/nginx /etc/logrotate.d/nginx",
      "sudo pip install s3cmd",
      "s3cmd get s3://${aws_s3_bucket.web_bucket.id}/website/index.html",
      "s3cmd get s3://${aws_s3_bucket.web_bucket.id}/website/terraformio-logo.png",
      "sudo rm /usr/share/nginx/html/index.html",
      "sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html",
      "sudo cp /home/ec2-user/terraformio-logo.png /usr/share/nginx/html/terraformio-logo.png",
      "sudo logrotate -f /etc/logrotate.d/nginx"
    ]
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-nginx2" })
}

resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx-profile"
  role = aws_iam_role.allow_nginx_s3.name
}

resource "aws_iam_role_policy" "allow_s3_all" {
  name   = "allow_s3_all"
  role   = aws_iam_role.allow_nginx_s3.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name}",
                "arn:aws:s3:::${local.s3_bucket_name}/*"
            ]
     }
  ]
}
EOF
}

resource "aws_s3_bucket" "web_bucket" {
  bucket        = local.s3_bucket_name
  force_destroy = true

  tags = merge(local.common_tags, { Name = "${var.environment_tag}-web-bucket" })
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.web_bucket.id
  acl    = "private"
}

# resource "aws_s3_bucket_object" "website" {
#   bucket = aws_s3_bucket.web_bucket.id
#   key    = "website/index.html"
#   source = "./index.html"
# }

# resource "aws_s3_bucket_object" "graphic" {
#   bucket = aws_s3_bucket.web_bucket.id
#   key    = "website/terraformio-logo.png"
#   source = "./terraformio-logo.png"
# }

resource "aws_s3_object" "website" {
  bucket = aws_s3_bucket.web_bucket.id
  key    = "website/index.html"
  source = "./index.html"
}

resource "aws_s3_object" "graphic" {
  bucket = aws_s3_bucket.web_bucket.id
  key    = "website/terraformio-logo.png"
  source = "./terraformio-logo.png"
}

################################################################################
# OUTPUTS
################################################################################

output "aws_instance_public_dns" {
  value       = aws_elb.nginx.dns_name
  description = "Public DNS of elb"
}
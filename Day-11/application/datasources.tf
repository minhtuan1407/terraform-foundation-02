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

data "consul_keys" "application" {
  key {
    name = "application"
    path = terraform.workspace == "default" ? "application/configuration/globo-primary/app_info" : "application/configuration/globo-primary/${terraform.workspace}/app_info"
  }

  key {
    name = "common-tags"
    path = "networking/configuration/globo-primary/common-tags"
  }
}

data "terraform_remote_state" "application" {
  backend = "consul"
  config  = {
    address = "192.168.1.10:8500"
    scheme  = "http"
    path = terraform.workspace == "default" ? "" : "application/configuration/globo-primary/${terraform.workspace}/terraform.tfstate"
  }
}
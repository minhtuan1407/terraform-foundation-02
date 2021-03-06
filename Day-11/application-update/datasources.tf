# DATA SOURCE

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

data "consul_keys" "applications" {
  key {
    name = "applications"
    path = terraform.workspace == "default" ? "applications/configuration/globo-primary/app_info" : "applications/configuration/globo-primary/${terraform.workspace}/app_info"
  }

  key {
    name = "common-tags"
    path = "networking/configuration/globo-primary/common-tags"
  }
}

data "terraform_remote_state" "networking" {
  backend = "consul"
  config = {
    address = "192.168.1.10:8500"
    scheme  = "http"
    path    = terraform.workspace == "default" ? "networking/state/globo-primary" : "networking/state/globo-primary-env:${terraform.workspace}"
  }
}
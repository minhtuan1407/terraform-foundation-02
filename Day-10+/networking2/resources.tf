##############################################################################
# VERSIONS
##############################################################################
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.0"
    }
  }
}

##############################################################################
# PROVIDERS
##############################################################################
provider "aws" {
  region  = var.region
  profile = "minhtuan1407-us-east-1"
}

provider "consul" {
  address    = "${var.consul_address}:${var.consul_port}"
  datacenter = var.consul_datacenter
}

##############################################################################
# DATA
##############################################################################
data "aws_availability_zones" "available" {}

data "consul_keys" "networking" {
  key {
    name = "networking"
    path = "networking/configuration/globo-primary/net_info"
  }
  key {
    name = "common-tags"
    path = "networking/configuration/globo-primary/common-tags"
  }
}

##############################################################################
# LOCALS
##############################################################################

locals {
  cidr_block      = jsondecode(data.consul_keys.networking.var.networking)["cidr_block"]
  common_tags     = jsondecode(data.consul_keys.networking.var.common-tags)
  subnet_count    = jsondecode(data.consul_keys.networking.var.networking)["subnet_count"]
}

##############################################################################
# RESOURCES
##############################################################################

# Networking

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name            = "globo-primary"
  cidr            = local.cidr_block
  azs             = slice(data.aws_availability_zones.available.names, 0, local.subnet_count)
  private_subnets = data.template_file.private_cidrsubnet.*.rendered
  public_subnets  = data.template_file.public_cidrsubnet.*.rendered

  enable_nat_gateway           = true
  create_database_subnet_group = false

  tags = local.common_tags
}
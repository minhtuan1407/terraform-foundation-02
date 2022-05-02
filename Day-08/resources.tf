##################################################################################
# CONFIGURATION 
##################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

##################################################################################
# PROVIDER 
##################################################################################

provider "aws" {
  region  = var.region
  profile = "minhtuan1407-us-east-1"
}

##################################################################################
# DATA 
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name            = "globo-primary"
  cidr            = var.cidr_block
  azs             = slice(data.aws_availability_zones.available.names, 0, var.subnet_count)
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway           = false
  create_database_subnet_group = false

  tags = {
    Environment = "Production"
    Team        = "Network"
  }
}
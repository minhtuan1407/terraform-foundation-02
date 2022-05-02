terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket  = "minhtuan1407-bucket"
    key     = "dev/project1-vpc/terraform.tfstate"
    profile = "minhtuan1407-us-east-1"
    region  = "us-east-1"

    # Enable during State Locking
    dynamodb_table = "dev-project-vpc"
  }
}
provider "aws" {
  region  = var.aws_region
  profile = "minhtuan1407-us-east-1"
}




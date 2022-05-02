variable "aws_region" {
  description = "The region to run Terraform in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance type to use for the instance"
  type        = string
  default     = "t3.micro"
}

variable "instance_keypair" {
  description = "Name of the key pair to use for the instance"
  type        = string
  default     = "minhtuan1407"
}

variable "instance_type_list" {
  description = "List of instance types to use for the instance"
  type        = list(string)
  default     = ["t3.micro", "t3.small", "t3.micro"]
}

variable "instance_type_map" {
  description = "Map of instance types to use for the instance"
  type        = map(string)
  default = {
    "dev"  = "t3.micro"
    "qa"   = "t3.small"
    "prod" = "t3.micro"
  }
}

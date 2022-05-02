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
variable "aws_region" {
  description = "Region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment to deploy to"
  type        = string
  default     = "dev"
}

variable "buissiness_division" {
  description = "Buissiness division to deploy to"
  type        = string
  default     = "SAP"

}
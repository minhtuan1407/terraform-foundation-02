variable "bussiness_division" {
  description = "Bussiness division in a company"
  type        = string
  default     = "sap"
}

variable "environment" {
  description = "Environment var use as a prefix for all resources"
  type        = string
  default     = "dev"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-default"
}

variable "resource_group_location" {
  description = "Region where the resource group will be created"
  type        = string
  default     = "westeurope"
}
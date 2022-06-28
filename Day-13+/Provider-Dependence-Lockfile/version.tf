# Require
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "1.44.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 1.0"
    }
  }
}

# Provider
provider "azurerm" {
  features {}
  subscription_id = "998e7914-717a-4043-bfeb-b8bd8dda05cf"
  client_id       = "626483c6-2134-46d1-a550-8e1f09600063"
  client_secret   = "xNZNi1xW_NJy3SGpyILs9ertV1sAPW7GtK"
  tenant_id       = "a0a0514b-7342-4392-ad0b-fec45b42ed59"
}
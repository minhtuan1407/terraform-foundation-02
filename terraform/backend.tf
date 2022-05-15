#IMPORTANT - please do not nodify the inventory manually, it will be overrided from template

terraform {
  backend "azurerm" {
    resource_group_name  = "PLATFORM_SHARED"
    storage_account_name = "tfstate1361"
    container_name       = "tfstate"
    key                  = "apps-nonprod-blue-vms.platform/terraform.tfstate"
  }
}
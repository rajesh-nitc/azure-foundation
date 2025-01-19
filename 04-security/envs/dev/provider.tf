terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.61.0"
    }
  }
}

provider "azurerm" {
  alias               = "sub-common-connectivity"
  subscription_id     = "9f75fbbf-3b6c-4036-971d-426b55119ad5"
  storage_use_azuread = true
  features {}
}
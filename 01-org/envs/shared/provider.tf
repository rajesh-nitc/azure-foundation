terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.61.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">=1.8.0"
    }

  }
}

provider "azurerm" {
  subscription_id = var.sub_id_connectivity
  features {}
}

provider "azuread" {
}

provider "azurerm" {
  alias               = "sub-common-management"
  subscription_id     = var.sub_id_management
  storage_use_azuread = true
  features {}
}

provider "azapi" {
}
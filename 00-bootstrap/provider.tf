terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.61.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
  }
}

provider "azurerm" {
  subscription_id     = var.default_subscription_id
  storage_use_azuread = true
  features {}
}

provider "azuread" {
}
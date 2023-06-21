terraform {
  required_version = ">= 1.3.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.61.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  alias                      = "sub-common-connectivity"
  subscription_id            = "9f75fbbf-3b6c-4036-971d-426b55119ad5"
  features {}
}
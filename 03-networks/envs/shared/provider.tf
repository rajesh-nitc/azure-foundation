terraform {
  required_version = ">= 1.3.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.61.0"
    }
  }
}

# Both providers are same!
# This is the default provider (i.e. without alias), it will be inherited by the root module automatically
provider "azurerm" {
  skip_provider_registration = false
  subscription_id            = "9f75fbbf-3b6c-4036-971d-426b55119ad5"
  features {}
}

# Couple of data sources use connectivity/hub
provider "azurerm" {
  skip_provider_registration = false
  alias                      = "sub-common-connectivity"
  subscription_id            = "9f75fbbf-3b6c-4036-971d-426b55119ad5"
  features {}
}
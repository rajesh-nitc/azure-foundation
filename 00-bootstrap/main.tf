resource "azurerm_resource_group" "tfstate" {
  name     = "rg-org-tfstate"
  location = var.location
}

resource "azurerm_storage_account" "tfstate" {
  name                      = "storgtfstate"
  resource_group_name       = azurerm_resource_group.tfstate.name
  location                  = azurerm_resource_group.tfstate.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  shared_access_key_enabled = false
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "stct-org-tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}
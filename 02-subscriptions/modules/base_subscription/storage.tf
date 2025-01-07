resource "azurerm_storage_account" "tfstate" {
  name                      = format("%s%s", module.naming.storage_account.name, "tf")
  resource_group_name       = azurerm_resource_group.tfstate.name
  location                  = azurerm_resource_group.tfstate.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  shared_access_key_enabled = false
}

resource "azurerm_storage_container" "tfstate" {
  name                  = format("%s-%s", module.naming.storage_container.name, "tf")
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}
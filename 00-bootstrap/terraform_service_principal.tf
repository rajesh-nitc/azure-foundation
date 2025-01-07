resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}

# Assign roles on azure ad
resource "azuread_application" "terraform" {
  display_name     = var.terraform_service_principal
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"] # For creating app registrations in subscriptions stage
      type = "Role"
    }

    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Directory.ReadWrite.All"] # For creating azure ad groups in org stage
      type = "Role"
    }

    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["RoleManagement.ReadWrite.Directory"] # For providing directory roles to azure ad groups in subscriptions stage
      type = "Role"
    }
  }

}

resource "azuread_application_password" "terraform" {
  application_id = azuread_application.terraform.id
}

# Assign Azure resource roles
resource "azuread_service_principal" "terraform" {
  client_id                    = azuread_application.terraform.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "terraform_mg" {
  for_each             = toset(var.terraform_service_principal_roles)
  scope                = format("/providers/Microsoft.Management/managementGroups/%s", var.mg_root_id)
  role_definition_name = each.key
  principal_id         = azuread_service_principal.terraform.object_id
}
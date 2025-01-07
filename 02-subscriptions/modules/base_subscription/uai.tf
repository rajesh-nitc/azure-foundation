resource "azurerm_user_assigned_identity" "uai" {
  for_each            = var.uai_roles
  name                = format("%s-%s-%s-%s-%s", "uai", each.key, var.bu, var.app, var.env)
  resource_group_name = local.rg_name
  location            = var.location
}

resource "azurerm_role_assignment" "uai" {
  for_each = {
    for i in local.uai_roles : "${i.role}-${i.member}" => {
      role   = i.role
      member = i.member
    }
  }
  scope                = local.sub_resource_id
  role_definition_name = each.value.role
  principal_id         = azurerm_user_assigned_identity.uai[each.value.member].principal_id
}

resource "azurerm_federated_identity_credential" "cicd" {
  for_each            = var.uai_repos
  name                = format("%s-%s-%s-%s-%s", "uaif", each.key, var.bu, var.app, var.env)
  resource_group_name = local.rg_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.uai["${each.key}-cicd"].id
  subject             = "repo:${var.github_owner}/${each.value}${each.value}:environment:${var.env}"
}

# apim
resource "azurerm_user_assigned_identity" "apim" {
  name                = format("%s-%s-%s-%s-%s", "uai", "apim", var.bu, var.app, var.env)
  resource_group_name = local.rg_name
  location            = var.location
}

resource "azuread_group" "group" {
  for_each                = var.group_roles
  display_name            = each.key
  security_enabled        = true
  prevent_duplicate_names = true
  owners = [
    # This is my user object ID
    # I think i might have created these groups using my Azure account and
    # not using the terraform service principal
    data.azuread_client_config.current.object_id
  ]

  lifecycle {
    ignore_changes = [
      owners,
    ]
  }
}

resource "azurerm_role_assignment" "group" {
  for_each = {
    for i in local.group_roles : "${i.role}-${i.member}" => {
      role   = i.role
      member = i.member
    }
  }
  scope                = local.scope
  role_definition_name = each.value.role
  principal_id         = azuread_group.group[each.value.member].object_id
}
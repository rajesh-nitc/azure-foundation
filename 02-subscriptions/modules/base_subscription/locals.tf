locals {
  sub_id          = data.azurerm_subscription.current.subscription_id
  sub_resource_id = data.azurerm_subscription.current.id
  tenant_id       = data.azurerm_client_config.current.tenant_id

  rg_name = azurerm_resource_group.rg.name

  uai_roles = flatten([
    for k, v in var.uai_roles : [
      for i in v : { member = k, role = i }
    ]
  ])

  group_roles = flatten([
    for k, v in var.group_roles : [
      for i in v : { member = k, role = i }
    ]
  ])

  app_repos = { for k, v in var.uai_repos : k => v if !can(regex(".*infra.*", k)) }

}
resource "azurerm_subnet" "snet" {
  for_each = local.all_snets
  # It looks like Azure-managed subnets starts with Capital
  # If subnet name starts with Capital, then keep that name
  # else follow the naming
  name = (
    substr(each.value.name, 0, 1) == upper(substr(each.value.name, 0, 1))
    ? each.value.name
    : format("%s-%s", module.naming.subnet.name, each.value.name)
  )
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_name
  address_prefixes     = each.value.address_prefixes

  service_endpoints = try(each.value.service_endpoints, [])

  private_endpoint_network_policies             = try(each.value.private_endpoint_network_policies, "Disabled")
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, true)
}


resource "azurerm_route_table" "route_table" {
  for_each                      = { for i in local.all_snets : i.route_table_name => i if try(i.route_table_name, null) != null }
  name                          = format("%s-%s", module.naming.route_table.name, each.value.name)
  resource_group_name           = local.rg_name
  location                      = var.location
  bgp_route_propagation_enabled = var.env == "hub" ? false : true
}

resource "azurerm_route" "route" {
  for_each            = { for i in local.routes : i.route_table_name => i if try(i.route_table_name, null) != null }
  name                = format("%s-%s", module.naming.route_table.name, each.value.route_name)
  resource_group_name = local.rg_name
  route_table_name    = azurerm_route_table.route_table[each.key].name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
  next_hop_in_ip_address = (
    each.value.next_hop_type == "VirtualAppliance"
    ? each.value.next_hop_in_ip_address
    : null
  )
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  for_each       = { for i in local.all_snets : i.name => i if try(i.route_table_name, null) != null }
  subnet_id      = azurerm_subnet.snet[each.key].id
  route_table_id = azurerm_route_table.route_table[each.value.route_table_name].id
}

# route for outbound traffic through nat ?
# https://learn.microsoft.com/en-us/azure/nat-gateway/nat-gateway-resource#connect-to-the-internet-with-nat-gateway
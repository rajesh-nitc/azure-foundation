resource "azurerm_monitor_diagnostic_setting" "subscription" {
  for_each                   = toset(var.enable_diagnostics_at_subscription)
  name                       = format("%s-%s", module.naming.monitor_diagnostic_setting.name, "logs")
  target_resource_id         = format("/subscriptions/%s", each.key)
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  # log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = toset(var.log_categories)
    content {
      category = enabled_log.value
    }
  }


}
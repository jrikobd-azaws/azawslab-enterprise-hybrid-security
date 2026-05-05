output "monitoring_resource_group_name" {
  value = try(azurerm_resource_group.monitoring[0].name, null)
}

output "log_analytics_workspace_id" {
  value = try(azurerm_log_analytics_workspace.sentinel[0].id, null)
}

output "log_analytics_workspace_name" {
  value = try(azurerm_log_analytics_workspace.sentinel[0].name, null)
}

output "sentinel_onboarding_id" {
  value = try(azurerm_sentinel_log_analytics_workspace_onboarding.sentinel[0].id, null)
}

output "sentinel_analytics_rule_id" {
  value = try(azurerm_sentinel_alert_rule_scheduled.azure_activity_write_delete[0].id, null)
}

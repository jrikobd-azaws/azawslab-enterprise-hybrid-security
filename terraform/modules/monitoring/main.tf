data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "monitoring" {
  count = var.enable_sentinel ? 1 : 0

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "sentinel" {
  count = var.enable_sentinel ? 1 : 0

  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.monitoring[0].location
  resource_group_name = azurerm_resource_group.monitoring[0].name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days
  tags                = var.tags
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  count = var.enable_sentinel ? 1 : 0

  workspace_id = azurerm_log_analytics_workspace.sentinel[0].id
}

resource "azurerm_monitor_diagnostic_setting" "subscription_activity_to_law" {
  count = var.enable_sentinel ? 1 : 0

  name                       = "diag-subscription-activity-to-sentinel"
  target_resource_id         = data.azurerm_subscription.current.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel[0].id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "Policy"
  }

  enabled_log {
    category = "Recommendation"
  }

  enabled_log {
    category = "Alert"
  }
}

resource "azurerm_sentinel_alert_rule_scheduled" "azure_activity_write_delete" {
  count = var.enable_sentinel ? 1 : 0

  name                       = var.sentinel_rule_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel[0].id
  display_name               = var.sentinel_rule_display_name
  severity                   = "Medium"
  enabled                    = true

  query = <<-KQL
AzureActivity
| where OperationNameValue has_any ("write", "delete")
| summarize OperationCount = count() by Caller, OperationNameValue, ResourceGroup, bin(TimeGenerated, 15m)
| where OperationCount >= 3
KQL

  query_frequency   = "PT15M"
  query_period      = "PT15M"
  trigger_operator  = "GreaterThan"
  trigger_threshold = 0

  tactics = [
    "Discovery",
    "Impact"
  ]

  depends_on = [
    azurerm_sentinel_log_analytics_workspace_onboarding.sentinel
  ]
}

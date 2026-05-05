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

resource "azurerm_monitor_action_group" "p9a" {
  count = var.enable_monitor_alerts ? 1 : 0

  name                = var.monitor_action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.monitor_action_group_short_name
  tags                = var.tags

  email_receiver {
    name                    = "admin-lab-email"
    email_address           = var.monitor_action_group_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "vm_cpu_high" {
  count = var.enable_monitor_alerts ? 1 : 0

  name                = var.monitor_cpu_alert_name
  resource_group_name = var.resource_group_name
  scopes              = [var.monitor_alert_target_vm_id]
  description         = "P9a validation alert for high CPU on vm-dev-client-01."
  severity            = 3
  enabled             = true
  frequency           = "PT5M"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.monitor_cpu_alert_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.p9a[0].id
  }
}

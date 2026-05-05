variable "enable_sentinel" {
  description = "Controls whether P8 Log Analytics and Microsoft Sentinel resources are deployed."
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "Name of the monitoring resource group."
  type        = string
}

variable "location" {
  description = "Azure region for monitoring resources."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace used by Microsoft Sentinel."
  type        = string
}

variable "log_analytics_sku" {
  description = "SKU for the Log Analytics workspace."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_retention_days" {
  description = "Retention period for the Log Analytics workspace."
  type        = number
  default     = 30
}

variable "sentinel_rule_name" {
  description = "Name of the P8 Sentinel scheduled analytic rule."
  type        = string
  default     = "rule-p8-azure-activity-write-delete"
}

variable "sentinel_rule_display_name" {
  description = "Display name of the P8 Sentinel scheduled analytic rule."
  type        = string
  default     = "P8 Azure Activity write or delete operations"
}

variable "tags" {
  description = "Tags applied to monitoring resources."
  type        = map(string)
  default     = {}
}

variable "enable_monitor_alerts" {
  description = "Controls whether P9a Azure Monitor action group and alert resources are deployed."
  type        = bool
  default     = false
}

variable "monitor_action_group_name" {
  description = "Name of the P9a Azure Monitor action group."
  type        = string
  default     = "ag-p9a-platform-ops"
}

variable "monitor_action_group_short_name" {
  description = "Short name for the P9a Azure Monitor action group."
  type        = string
  default     = "p9aops"
}

variable "monitor_action_group_email" {
  description = "Email receiver for P9a Azure Monitor action group notifications."
  type        = string
}

variable "monitor_alert_target_vm_id" {
  description = "Resource ID of the VM targeted by the P9a CPU metric alert."
  type        = string
}

variable "monitor_cpu_alert_name" {
  description = "Name of the P9a VM CPU metric alert."
  type        = string
  default     = "alert-p9a-vm-cpu-high"
}

variable "monitor_cpu_alert_threshold" {
  description = "CPU percentage threshold for the P9a VM metric alert."
  type        = number
  default     = 85
}

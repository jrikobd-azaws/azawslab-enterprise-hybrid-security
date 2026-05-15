variable "enabled" {
  description = "Controls creation of the O4 private AKS platform."
  type        = bool
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "node_resource_group" {
  type = string
}

variable "workload_rg_name" {
  type = string
}

variable "workload_vnet_name" {
  type = string
}

variable "aks_subnet_name" {
  type = string
}

variable "aks_subnet_prefixes" {
  type = list(string)
}

variable "connectivity_rg_name" {
  type = string
}

variable "azure_firewall_name" {
  type = string
}

variable "route_table_name" {
  type = string
}

variable "aks_name" {
  type = string
}

variable "dns_prefix_private" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "node_vm_size" {
  type = string
}

variable "system_node_count" {
  type = number
}

variable "admin_group_object_ids" {
  type = list(string)
}

variable "app_operators_group_id" {
  type = string
}

variable "readers_group_id" {
  type = string
}

variable "aks_identity_name" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "acr_sku" {
  type = string
}

variable "monitor_workspace_name" {
  type = string
}

variable "grafana_name" {
  description = "Azure Managed Grafana workspace name."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9-]{0,21}[A-Za-z0-9]$", var.grafana_name))
    error_message = "grafana_name must be 2-23 characters, use only letters, numbers, and dashes, start with a letter, and end with a letter or digit."
  }
}

variable "grafana_major_version" {
  description = "Major version for Azure Managed Grafana."
  type        = string
}
variable "common_tags" {
  type = map(string)
}
variable "enable_o5_avd_aks_dns_link" {
  description = "Controls whether O4 AKS private API DNS is linked to the O5 AVD VNet for private kubectl validation from AVD."
  type        = bool
  default     = false
}

variable "o5_avd_vnet_resource_group_name" {
  description = "Resource group containing the O5 AVD spoke VNet."
  type        = string
}

variable "o5_avd_vnet_name" {
  description = "O5 AVD spoke VNet that requires private DNS resolution for the O4 AKS API."
  type        = string
}

variable "o5_aks_private_dns_zone_resource_group_name" {
  description = "Resource group containing the AKS system-managed private DNS zone."
  type        = string
}

variable "o5_aks_private_dns_zone_name" {
  description = "AKS system-managed private DNS zone name for the O4 private AKS API."
  type        = string
}

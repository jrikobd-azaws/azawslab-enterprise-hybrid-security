variable "enabled" {
  description = "Controls deployment of the O5 AVD and FSLogix foundation."
  type        = bool
}

variable "location" {
  type = string
}

variable "paired_location" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "resource_group_name" {
  type = string
}

variable "avd_vnet_name" {
  type = string
}

variable "avd_vnet_address_space" {
  type = list(string)
}

variable "avd_subnet_name" {
  type = string
}

variable "avd_subnet_address_prefixes" {
  type = list(string)
}

variable "private_endpoint_subnet_name" {
  type = string
}

variable "private_endpoint_subnet_prefixes" {
  type = list(string)
}

variable "route_table_name" {
  type = string
}

variable "azure_firewall_private_ip_address" {
  type = string
}

variable "host_pool_name" {
  type = string
}

variable "workspace_name" {
  type = string
}

variable "desktop_app_group_name" {
  type = string
}

variable "fslogix_storage_account_name" {
  type = string
}

variable "fslogix_storage_replication_type" {
  type = string
}

variable "fslogix_share_name" {
  type = string
}

variable "fslogix_share_quota_gb" {
  type = number
}
variable "enable_o5_o6_private_routes" {
  description = "Controls O5/O6 explicit private routes from the AVD subnet to Azure admin, HQ, and AWS trusted destinations."
  type        = bool
  default     = false
}

variable "o5_o6_azure_platform_admin_prefix" {
  description = "Azure platform/admin destination prefix reached from O5 AVD through Azure Firewall."
  type        = string
  default     = "10.10.0.0/16"
}

variable "o5_o6_hq_prefix" {
  description = "HQ destination prefix reached from O5 AVD through FortiGate."
  type        = string
  default     = "192.168.1.0/24"
}

variable "o5_o6_aws_trusted_prefix" {
  description = "AWS trusted destination prefix reached from O5 AVD through FortiGate."
  type        = string
  default     = "172.16.1.0/24"
}

variable "o5_o6_fortigate_private_ip_address" {
  description = "FortiGate private next-hop IP for O5/O6 HQ and AWS trusted private routes."
  type        = string
  default     = "10.0.3.4"
}

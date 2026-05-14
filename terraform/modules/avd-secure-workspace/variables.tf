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
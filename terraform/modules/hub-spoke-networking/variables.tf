variable "connectivity_resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "hub_address_space" {
  type = list(string)
}

variable "bastion_subnet_prefixes" {
  type = list(string)
}

variable "firewall_subnet_prefixes" {
  type = list(string)
}

variable "gateway_subnet_prefixes" {
  type = list(string)
}

variable "workload_spoke_vnet_id" {
  type = string
}

variable "workload_spoke_vnet_name" {
  type = string
}

variable "workload_spoke_resource_group_name" {
  type = string
}

variable "workload_subnet_id" {
  type = string
}

variable "hub_to_spoke_peering_name" {
  type = string
}

variable "spoke_to_hub_peering_name" {
  type = string
}

variable "workload_route_table_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "enable_azure_firewall" {
  description = "Controls whether the ephemeral Azure Firewall resources are deployed for validation."
  type        = bool
  default     = false
}

variable "azure_firewall_name" {
  description = "Name of the Azure Firewall instance."
  type        = string
  default     = "afw-dev-norwayeast-01"
}

variable "azure_firewall_public_ip_name" {
  description = "Name of the Azure Firewall public IP address."
  type        = string
  default     = "pip-azfw-norwayeast-01"
}

variable "azure_firewall_policy_name" {
  description = "Name of the Azure Firewall Policy."
  type        = string
  default     = "afwp-dev-norwayeast"
}

variable "azure_firewall_route_name" {
  description = "Name of the workload default route that sends internet-bound traffic to Azure Firewall."
  type        = string
  default     = "route-default-to-azure-firewall"
}

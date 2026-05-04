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

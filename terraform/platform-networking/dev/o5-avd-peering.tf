variable "enable_o5_avd_peering" {
  description = "Controls global VNet peering between the Norway East hub and the North Europe O5 AVD spoke."
  type        = bool
  default     = false
}

variable "o5_avd_vnet_resource_group_name" {
  description = "Resource group containing the O5 AVD spoke VNet."
  type        = string
  default     = "rg-dev-avd-northeurope"
}

variable "o5_avd_vnet_name" {
  description = "O5 AVD spoke VNet name."
  type        = string
  default     = "vnet-dev-northeurope-spoke-avd"
}

variable "o5_hub_vnet_resource_group_name" {
  description = "Resource group containing the Norway East hub VNet."
  type        = string
  default     = "rg-connectivity-prod-norwayeast"
}

variable "o5_hub_vnet_name" {
  description = "Norway East hub VNet name."
  type        = string
  default     = "vnet-dev-norwayeast-hub"
}

data "azurerm_virtual_network" "o5_hub" {
  count = var.enable_o5_avd_peering ? 1 : 0

  name                = var.o5_hub_vnet_name
  resource_group_name = var.o5_hub_vnet_resource_group_name
}

data "azurerm_virtual_network" "o5_avd" {
  count = var.enable_o5_avd_peering ? 1 : 0

  name                = var.o5_avd_vnet_name
  resource_group_name = var.o5_avd_vnet_resource_group_name
}

resource "azurerm_virtual_network_peering" "hub_to_o5_avd" {
  count = var.enable_o5_avd_peering ? 1 : 0

  name                         = "peer-hub-to-spoke-avd-northeurope"
  resource_group_name          = data.azurerm_virtual_network.o5_hub[0].resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.o5_hub[0].name
  remote_virtual_network_id    = data.azurerm_virtual_network.o5_avd[0].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_virtual_network_peering" "o5_avd_to_hub" {
  count = var.enable_o5_avd_peering ? 1 : 0

  name                         = "peer-spoke-avd-to-hub-norwayeast"
  resource_group_name          = data.azurerm_virtual_network.o5_avd[0].resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.o5_avd[0].name
  remote_virtual_network_id    = data.azurerm_virtual_network.o5_hub[0].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  lifecycle {
    prevent_destroy = true
  }
}

output "o5_hub_to_avd_peering_id" {
  value = var.enable_o5_avd_peering ? azurerm_virtual_network_peering.hub_to_o5_avd[0].id : null
}

output "o5_avd_to_hub_peering_id" {
  value = var.enable_o5_avd_peering ? azurerm_virtual_network_peering.o5_avd_to_hub[0].id : null
}
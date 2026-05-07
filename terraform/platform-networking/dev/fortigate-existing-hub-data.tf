# -----------------------------------------------------------------------------
# Existing P5 hub lookup for O3a / FortiGate extension
#
# The base hub VNet is already owned by the platform-networking root.
# This file lets the FortiGate extension attach new dedicated FortiGate subnets
# without relying on missing module outputs.
# -----------------------------------------------------------------------------

data "azurerm_resource_group" "p5_connectivity" {
  name = var.p5_hub_resource_group_name
}

data "azurerm_virtual_network" "p5_hub" {
  name                = var.p5_fortigate_hub_vnet_name
  resource_group_name = data.azurerm_resource_group.p5_connectivity.name
}

output "connectivity_resource_group_name" {
  value = azurerm_resource_group.connectivity.name
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion.id
}

output "firewall_subnet_id" {
  value = azurerm_subnet.firewall.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}

output "hub_to_spoke_peering_id" {
  value = azurerm_virtual_network_peering.hub_to_workload_spoke.id
}

output "spoke_to_hub_peering_id" {
  value = azurerm_virtual_network_peering.workload_spoke_to_hub.id
}

output "workload_route_table_id" {
  value = azurerm_route_table.workload_to_hub.id
}

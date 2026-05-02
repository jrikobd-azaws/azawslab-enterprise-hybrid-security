output "resource_group_name" {
  value = azurerm_resource_group.networking.name
}

output "workload_subnet_id" {
  value = azurerm_subnet.workload.id
}

output "workload_vnet_name" {
  value = azurerm_virtual_network.workload.name
}

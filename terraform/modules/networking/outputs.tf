output "resource_group_name" {
  value = azurerm_resource_group.networking.name
}

output "workload_subnet_id" {
  value = azurerm_subnet.workload.id
}

output "workload_vnet_name" {
  value = azurerm_virtual_network.workload.name
}

output "management_subnet_id" {
  value = length(azurerm_subnet.management) > 0 ? azurerm_subnet.management[0].id : null
}

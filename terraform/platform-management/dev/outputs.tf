output "management_resource_group_name" {
  value = azurerm_resource_group.management.name
}

output "management_vm_name" {
  value = azurerm_linux_virtual_machine.management.name
}

output "management_private_ip" {
  value = azurerm_network_interface.management.private_ip_address
}

output "management_public_ip_id" {
  value = azurerm_public_ip.management.id
}

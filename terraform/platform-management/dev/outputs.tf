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
output "awx_vm_name" {
  value = try(module.a2_awx_vm[0].vm_name, null)
}

output "awx_private_ip" {
  value = try(module.a2_awx_vm[0].private_ip_address, null)
}

output "awx_public_ip" {
  value = try(module.a2_awx_vm[0].public_ip_address, null)
}

output "awx_network_interface_id" {
  value = try(module.a2_awx_vm[0].network_interface_id, null)
}

output "awx_principal_id" {
  value = try(module.a2_awx_vm[0].principal_id, null)
}

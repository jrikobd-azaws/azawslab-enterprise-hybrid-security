output "o5_session_host_vm_id" {
  value = local.session_host_enabled ? azurerm_windows_virtual_machine.session_host[0].id : null
}

output "o5_session_host_nic_id" {
  value = local.session_host_enabled ? azurerm_network_interface.session_host[0].id : null
}

output "o5_session_host_private_ip_address" {
  value = local.session_host_enabled ? azurerm_network_interface.session_host[0].private_ip_address : null
}
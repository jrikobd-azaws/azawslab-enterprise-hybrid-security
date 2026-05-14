output "resource_group_id" {
  value = var.enabled ? azurerm_resource_group.this[0].id : null
}

output "resource_group_name" {
  value = var.enabled ? azurerm_resource_group.this[0].name : null
}

output "avd_vnet_id" {
  value = var.enabled ? azurerm_virtual_network.avd[0].id : null
}

output "avd_subnet_id" {
  value = var.enabled ? azurerm_subnet.avd[0].id : null
}

output "private_endpoint_subnet_id" {
  value = var.enabled ? azurerm_subnet.private_endpoints[0].id : null
}

output "route_table_id" {
  value = var.enabled ? azurerm_route_table.avd[0].id : null
}

output "host_pool_id" {
  value = var.enabled ? azurerm_virtual_desktop_host_pool.this[0].id : null
}

output "workspace_id" {
  value = var.enabled ? azurerm_virtual_desktop_workspace.this[0].id : null
}

output "desktop_application_group_id" {
  value = var.enabled ? azurerm_virtual_desktop_application_group.desktop[0].id : null
}

output "fslogix_storage_account_id" {
  value = var.enabled ? azurerm_storage_account.fslogix[0].id : null
}

output "fslogix_file_share_id" {
  value = var.enabled ? azurerm_storage_share.fslogix_profiles[0].rbac_scope_id : null
}

output "fslogix_private_endpoint_id" {
  value = var.enabled ? azurerm_private_endpoint.fslogix_file[0].id : null
}

output "fslogix_private_dns_zone_id" {
  value = var.enabled ? azurerm_private_dns_zone.file[0].id : null
}
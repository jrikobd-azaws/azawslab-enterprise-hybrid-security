output "resource_group_name" {
  value = azurerm_resource_group.security.name
}

output "key_vault_name" {
  value = azurerm_key_vault.security.name
}

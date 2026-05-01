output "resource_group_name" {
  value = azurerm_resource_group.security.name
}

output "key_vault_name" {
  value = azurerm_key_vault.security.name
}

output "local_admin_password_secret_name" {
  value = azurerm_key_vault_secret.local_admin_password.name
}

output "generated_local_admin_password" {
  value     = random_password.local_admin.result
  sensitive = true
}

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

output "defender_for_servers_pricing_id" {
  value = azurerm_security_center_subscription_pricing.defender_for_servers.id
}

output "defender_for_servers_pricing_tier" {
  value = azurerm_security_center_subscription_pricing.defender_for_servers.tier
}

output "defender_for_servers_subplan" {
  value = azurerm_security_center_subscription_pricing.defender_for_servers.subplan
}

output "defender_security_contact_id" {
  value = azurerm_security_center_contact.defender.id
}

output "defender_security_contact_email" {
  value = azurerm_security_center_contact.defender.email
}

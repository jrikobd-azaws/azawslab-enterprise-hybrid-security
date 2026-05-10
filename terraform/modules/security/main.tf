resource "random_password" "local_admin" {
  length           = 20
  special          = true
  override_special = "!@#%^*-_=+?"
}

resource "azurerm_resource_group" "security" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "admin-lab"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

resource "azurerm_key_vault" "security" {
  name                = "kvdevazawsne01"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  tenant_id           = "78643a83-bcc9-4a3b-ab7e-eeede0b3384e"
  sku_name            = "standard"

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "admin-lab"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

resource "azurerm_key_vault_access_policy" "principals" {
  for_each = toset(var.key_vault_secret_admin_object_ids)

  key_vault_id = azurerm_key_vault.security.id
  tenant_id    = "78643a83-bcc9-4a3b-ab7e-eeede0b3384e"
  object_id    = each.value

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Purge"
  ]
}

resource "azurerm_key_vault_secret" "local_admin_password" {
  name         = "local-admin-password"
  value        = random_password.local_admin.result
  key_vault_id = azurerm_key_vault.security.id

  depends_on = [azurerm_key_vault_access_policy.principals]
}

resource "azurerm_security_center_subscription_pricing" "defender_for_servers" {
  resource_type = "VirtualMachines"
  tier          = var.defender_for_servers_pricing_tier
  subplan       = var.defender_for_servers_subplan
}

resource "azurerm_security_center_contact" "defender" {
  name  = var.defender_security_contact_name
  email = var.defender_security_contact_email

  alert_notifications = true
  alerts_to_admins    = true
}

resource "azurerm_private_dns_zone" "key_vault" {
  count = var.enable_key_vault_private_endpoint ? 1 : 0

  name                = var.key_vault_private_dns_zone_name
  resource_group_name = azurerm_resource_group.security.name

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "admin-lab"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
    Phase            = "P2b"
    Service          = "KeyVault-PrivateEndpoint"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_management_vnet" {
  count = var.enable_key_vault_private_endpoint ? 1 : 0

  name                  = var.key_vault_private_dns_link_name
  resource_group_name   = azurerm_resource_group.security.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault[0].name
  virtual_network_id    = var.key_vault_private_dns_vnet_id
  registration_enabled  = false

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "admin-lab"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
    Phase            = "P2b"
    Service          = "KeyVault-PrivateEndpoint"
  }
}

resource "azurerm_private_endpoint" "key_vault" {
  count = var.enable_key_vault_private_endpoint ? 1 : 0

  name                = var.key_vault_private_endpoint_name
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  subnet_id           = var.key_vault_private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-kvdevazawsne01-norwayeast-01"
    private_connection_resource_id = azurerm_key_vault.security.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-kvdevazawsne01-norwayeast-01"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault[0].id]
  }

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "admin-lab"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
    Phase            = "P2b"
    Service          = "KeyVault-PrivateEndpoint"
  }
}

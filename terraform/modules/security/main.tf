data "azurerm_client_config" "current" {}

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
  name                = "kvdevazaws01"
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

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.security.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

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

  depends_on = [azurerm_key_vault_access_policy.current_user]
}

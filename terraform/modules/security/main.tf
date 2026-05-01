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

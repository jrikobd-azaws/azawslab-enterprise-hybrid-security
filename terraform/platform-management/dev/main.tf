data "azurerm_subnet" "management" {
  name                 = "snet-mgmt"
  virtual_network_name = "vnet-dev-norwayeast-spoke-workload"
  resource_group_name  = "rg-dev-workload-norwayeast"
}

locals {
  common_tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

resource "azurerm_resource_group" "management" {
  name     = "rg-dev-management-norwayeast"
  location = "norwayeast"

  tags = local.common_tags
}

resource "azurerm_public_ip" "management" {
  name                = "pip-vm-dev-mgmt-01-norwayeast-01"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

resource "azurerm_network_interface" "management" {
  name                = "nic-vm-dev-mgmt-01-01"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.management.id
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "management" {
  name                            = "vm-dev-mgmt-01"
  resource_group_name             = azurerm_resource_group.management.name
  location                        = azurerm_resource_group.management.location
  size                            = "Standard_B2als_v2"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.management.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.management_ssh_public_key
  }

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = local.common_tags
}
data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "a2_shared" {
  name                = var.a2_key_vault_name
  resource_group_name = var.a2_key_vault_resource_group_name
}
module "a2_awx_vm" {
  count  = var.enable_a2_awx ? 1 : 0
  source = "../../modules/platform-linux-vm"

  vm_name                = var.awx_vm_name
  computer_name          = "devawx01"
  resource_group_name    = azurerm_resource_group.management.name
  location               = azurerm_resource_group.management.location
  subnet_id              = data.azurerm_subnet.management.id
  network_interface_name = "nic-${var.awx_vm_name}-01"

  create_public_ip     = false
  vm_size              = var.awx_vm_size
  admin_username       = var.awx_admin_username
  admin_ssh_public_key = coalesce(var.awx_ssh_public_key, var.management_ssh_public_key)
  os_disk_size_gb      = var.awx_os_disk_size_gb
  identity_type        = "SystemAssigned"

  tags = merge(local.common_tags, {
    Phase        = "A2"
    Service      = "AWX"
    Role         = "AutomationControlPlane"
    AutoShutdown = "true"
  })
}

resource "azurerm_key_vault_access_policy" "a2_awx_vm_secrets" {
  count = var.enable_a2_awx && var.a2_key_vault_auth_model == "access_policy" ? 1 : 0

  key_vault_id = data.azurerm_key_vault.a2_shared.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.a2_awx_vm[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  depends_on = [
    module.a2_awx_vm
  ]
}

resource "azurerm_role_assignment" "a2_awx_vm_key_vault_secrets_user" {
  count = var.enable_a2_awx && var.a2_key_vault_auth_model == "rbac" ? 1 : 0

  scope                = data.azurerm_key_vault.a2_shared.id
  role_definition_name = var.a2_key_vault_rbac_role_definition_name
  principal_id         = module.a2_awx_vm[0].principal_id
  principal_type       = "ServicePrincipal"

  depends_on = [
    module.a2_awx_vm
  ]
}

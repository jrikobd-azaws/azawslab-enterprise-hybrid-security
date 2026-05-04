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

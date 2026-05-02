locals {
  effective_computer_name = var.computer_name != null ? var.computer_name : substr(replace(var.vm_name, "-", ""), 0, 15)
}

resource "azurerm_network_interface" "vm" {
  name                = "nic-${var.vm_name}-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                 = var.vm_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  size                 = "Standard_B2als_v2"
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  computer_name        = local.effective_computer_name
  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = var.tags
}

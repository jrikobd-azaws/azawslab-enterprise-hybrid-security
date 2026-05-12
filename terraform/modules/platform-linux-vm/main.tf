locals {
  effective_computer_name  = var.computer_name != null ? var.computer_name : substr(replace(var.vm_name, "-", ""), 0, 15)
  effective_nic_name       = var.network_interface_name != null ? var.network_interface_name : "nic-${var.vm_name}-01"
  effective_public_ip_name = var.public_ip_name != null ? var.public_ip_name : "pip-${var.vm_name}-01"
}

resource "azurerm_public_ip" "this" {
  count = var.create_public_ip ? 1 : 0

  name                = local.effective_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  tags                = var.tags
}

resource "azurerm_network_interface" "this" {
  name                = local.effective_nic_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.this[0].id : null
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  computer_name                   = local.effective_computer_name
  disable_password_authentication = true
  custom_data                     = var.custom_data
  tags                            = var.tags

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : [var.identity_type]

    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }
}

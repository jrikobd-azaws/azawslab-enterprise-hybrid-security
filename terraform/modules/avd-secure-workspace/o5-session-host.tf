locals {
  session_host_enabled = var.enabled && var.enable_session_host
}

data "azurerm_key_vault" "session_host_admin" {
  count = local.session_host_enabled ? 1 : 0

  name                = var.session_host_admin_password_key_vault_name
  resource_group_name = var.session_host_admin_password_key_vault_resource_group
}

data "azurerm_key_vault_secret" "session_host_admin_password" {
  count = local.session_host_enabled ? 1 : 0

  name         = var.session_host_admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.session_host_admin[0].id
}

resource "azurerm_network_interface" "session_host" {
  count = local.session_host_enabled ? 1 : 0

  name                = var.session_host_nic_name
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  tags                = azurerm_resource_group.this[0].tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.avd[0].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "session_host" {
  count = local.session_host_enabled ? 1 : 0

  name                = var.session_host_name
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  size                = var.session_host_vm_size

  admin_username = var.session_host_admin_username
  admin_password = data.azurerm_key_vault_secret.session_host_admin_password[0].value

  network_interface_ids = [
    azurerm_network_interface.session_host[0].id
  ]

  license_type              = "Windows_Client"
  patch_mode                = "AutomaticByOS"
  provision_vm_agent        = true
  enable_automatic_updates  = true
  secure_boot_enabled       = true
  vtpm_enabled              = true
  tags                      = azurerm_resource_group.this[0].tags

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    name                 = "${var.session_host_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.session_host_image_publisher
    offer     = var.session_host_image_offer
    sku       = var.session_host_image_sku
    version   = var.session_host_image_version
  }
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "session_host" {
  count = local.session_host_enabled ? 1 : 0

  hostpool_id     = azurerm_virtual_desktop_host_pool.this[0].id
  expiration_date = var.session_host_registration_expiration_date
}

resource "azurerm_virtual_machine_extension" "session_host_aad_login" {
  count = local.session_host_enabled ? 1 : 0

  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.session_host[0].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "2.0"
  auto_upgrade_minor_version = true

  depends_on = [
    azurerm_windows_virtual_machine.session_host
  ]
}

resource "azurerm_virtual_machine_extension" "session_host_avd_registration" {
  count = local.session_host_enabled ? 1 : 0

  name                       = "Microsoft.PowerShell.DSC"
  virtual_machine_id         = azurerm_windows_virtual_machine.session_host[0].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    modulesUrl            = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip"
    configurationFunction = "Configuration.ps1\\AddSessionHost"
    properties = {
      hostPoolName = azurerm_virtual_desktop_host_pool.this[0].name
      aadJoin      = true
    }
  })

  protected_settings = jsonencode({
    properties = {
      registrationInfoToken = azurerm_virtual_desktop_host_pool_registration_info.session_host[0].token
    }
  })

  depends_on = [
    azurerm_virtual_machine_extension.session_host_aad_login,
    azurerm_virtual_desktop_host_pool_registration_info.session_host
  ]
}
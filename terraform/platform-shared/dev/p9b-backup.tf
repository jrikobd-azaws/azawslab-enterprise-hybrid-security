data "azurerm_virtual_machine" "p9b_workload_vm" {
  count = var.enable_p9b_backup ? 1 : 0

  name                = "vm-dev-client-01"
  resource_group_name = "rg-dev-workload-norwayeast"
}

resource "azurerm_resource_group" "p9b_backup" {
  count = var.enable_p9b_backup ? 1 : 0

  name     = "rg-dev-backup-norwayeast"
  location = "norwayeast"

  tags = local.p9b_tags
}

resource "azurerm_recovery_services_vault" "p9b_backup" {
  count = var.enable_p9b_backup ? 1 : 0

  name                = "rsv-dev-backup"
  location            = azurerm_resource_group.p9b_backup[0].location
  resource_group_name = azurerm_resource_group.p9b_backup[0].name
  sku                 = "Standard"
  tags                = local.p9b_tags
}

resource "azurerm_backup_policy_vm" "p9b_daily" {
  count = var.enable_p9b_backup ? 1 : 0

  name                = "bp-dev-vm-daily"
  resource_group_name = azurerm_resource_group.p9b_backup[0].name
  recovery_vault_name = azurerm_recovery_services_vault.p9b_backup[0].name

  timezone = "GMT Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }
}

resource "azurerm_backup_protected_vm" "p9b_workload_vm" {
  count = var.enable_p9b_backup ? 1 : 0

  resource_group_name = azurerm_resource_group.p9b_backup[0].name
  recovery_vault_name = azurerm_recovery_services_vault.p9b_backup[0].name
  source_vm_id        = data.azurerm_virtual_machine.p9b_workload_vm[0].id
  backup_policy_id    = azurerm_backup_policy_vm.p9b_daily[0].id
}


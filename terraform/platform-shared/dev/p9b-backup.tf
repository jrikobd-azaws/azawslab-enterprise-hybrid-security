locals {
  p9b_restore_point_rg_name   = "rg-dev-backup-rsv-rp-norwayeast-1-rg"
  p9b_restore_point_rg_prefix = "rg-dev-backup-rsv-rp-norwayeast-"
}

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

resource "azurerm_resource_group" "p9b_backup_restore_points" {
  count = var.enable_p9b_backup ? 1 : 0

  name     = local.p9b_restore_point_rg_name
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

  instant_restore_resource_group {
    prefix = local.p9b_restore_point_rg_prefix
    suffix = "-rg"
  }

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }

  depends_on = [
    azurerm_resource_group.p9b_backup_restore_points
  ]
}

resource "azurerm_backup_protected_vm" "p9b_workload_vm" {
  count = var.enable_p9b_backup ? 1 : 0

  resource_group_name = azurerm_resource_group.p9b_backup[0].name
  recovery_vault_name = azurerm_recovery_services_vault.p9b_backup[0].name
  source_vm_id        = data.azurerm_virtual_machine.p9b_workload_vm[0].id
  backup_policy_id    = azurerm_backup_policy_vm.p9b_daily[0].id
}


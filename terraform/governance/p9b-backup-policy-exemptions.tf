data "azurerm_resource_group" "p9b_backup_restore_points" {
  count = var.enable_p9b_backup_governance ? 1 : 0

  name = "rg-dev-backup-rsv-rp-norwayeast-1-rg"
}

locals {
  p9b_backup_restore_point_resource_tag_policy_assignments = var.enable_p9b_backup_governance ? {
    Environment = azurerm_management_group_policy_assignment.require_tag_environment.id
    Project     = azurerm_management_group_policy_assignment.require_tag_project.id
    Owner       = azurerm_management_group_policy_assignment.require_tag_owner.id
    CostCenter  = azurerm_management_group_policy_assignment.require_tag_costcenter.id
  } : {}
}

resource "azurerm_resource_group_policy_exemption" "p9b_backup_restore_point_resource_tags" {
  for_each = local.p9b_backup_restore_point_resource_tag_policy_assignments

  name                 = "ex-p9b-backup-rp-${lower(each.key)}"
  display_name         = "P9b Backup restore point RG exemption - ${each.key}"
  resource_group_id    = data.azurerm_resource_group.p9b_backup_restore_points[0].id
  policy_assignment_id = each.value
  exemption_category   = "Waiver"

  description = "P9b scoped exemption for Azure Backup restore point resources in rg-dev-backup-rsv-rp-norwayeast-1-rg. Existing P3 resource tag deny assignments remain active everywhere else. This exemption is scoped only to the deterministic Azure Backup restore point resource group because Azure Backup creates Microsoft.Compute/restorePointCollections runtime resources that may not carry required tags at creation time."

  metadata = jsonencode({
    phase              = "P9b"
    project            = "Azawslab-Release2"
    service            = "Azure Backup"
    scope_reason       = "Azure Backup restore point collection runtime resources"
    restore_point_rg   = "rg-dev-backup-rsv-rp-norwayeast-1-rg"
    enterprise_pattern = "narrow resource-group-scoped policy exemption"
    reusable_switch    = "enable_p9b_backup_governance"
  })
}

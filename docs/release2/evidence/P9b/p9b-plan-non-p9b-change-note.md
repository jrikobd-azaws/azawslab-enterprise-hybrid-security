# P9b Plan Non-P9b Change Review

## Finding

The P9b Terraform plan produced the expected four P9b additions:

- azurerm_resource_group.p9b_backup[0]
- azurerm_recovery_services_vault.p9b_backup[0]
- azurerm_backup_policy_vm.p9b_daily[0]
- azurerm_backup_protected_vm.p9b_workload_vm[0]

The plan also showed one existing Sentinel analytic rule update:

- module.monitoring.azurerm_sentinel_alert_rule_scheduled.azure_activity_write_delete[0]

## Review

The detected update is limited to the KQL query heredoc representation for the existing P8 Sentinel rule.

No tracked source-code change was detected under terraform/modules/monitoring. The working-tree diff for Terraform showed only the P9b tag locals added to terraform/platform-shared/dev/main.tf and the new P9b files.

## Decision

This is treated as provider/state query-string normalization, not a functional P9b design change.

No destroy or replacement is planned.

## Control

The plan must still be reviewed before apply. If the Sentinel rule update expands beyond KQL whitespace/query representation, stop and do not apply.

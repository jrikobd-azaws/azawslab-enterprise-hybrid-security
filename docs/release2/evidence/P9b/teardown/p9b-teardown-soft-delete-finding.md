# P9b Teardown Finding - Azure Backup Soft Delete

## Summary

P9b teardown was attempted after Azure Backup validation. Terraform destroy could not immediately delete the Recovery Services Vault because Azure Backup retained the protected VM item in soft-delete / deferred-delete state.

## Observed State

- Recovery Services Vault: rsv-dev-backup
- Vault resource group: rg-dev-backup-norwayeast
- Protected VM: vm-dev-client-01
- Protection state: ProtectionStopped
- DeleteBackupData job: Completed
- Soft delete: Enabled
- Deferred delete: Active
- Soft delete retention: 14 days
- Restore point collection still present:
  - AzureBackup_vm-dev-client-01_7566839024171629714

## Interpretation

This is expected Azure Backup behavior. Even after protection is stopped and backup data deletion is requested, Azure Backup can retain the deleted item for the configured soft-delete retention period.

During this period, the Recovery Services Vault remains non-empty and cannot be deleted. The Azure-created restore point collection resource group can also remain present until Azure Backup completes backend cleanup.

## Enterprise Best Practice

In a production environment, this behavior is desirable. Azure Backup soft delete protects recovery data against accidental or malicious deletion. Production designs may also add locked immutability and Resource Guard / Multi-User Authorization to further protect backup operations.

## Lab Implementation Decision

For this lab, locked immutability was intentionally not enabled to avoid irreversible teardown friction. However, soft delete was left enabled to demonstrate realistic backup protection behavior.

The lab will not force-delete or bypass Azure Backup soft-delete behavior. The remaining P9b resources will be reviewed again after the deferred-delete retention period expires.

## Terraform Impact

Terraform destroy failed because the vault still contained a soft-deleted protected item and the restore point resource group still contained an AzureBackup restorePointCollection.

This is not a Terraform syntax or state-boundary failure. It is a service lifecycle dependency created by Azure Backup.

## Follow-Up Action

After the soft-delete retention period expires:

1. Confirm the backup item no longer appears in the vault.
2. Confirm the restore point collection no longer exists.
3. Regenerate Terraform plan with P9b disabled.
4. Confirm the plan only removes P9b backup resources.
5. Apply cleanup through the normal controlled deployment path.
6. Capture final teardown evidence.

# P9b BCDR Plan - Lab Implementation

## Scope

P9b validates Backup / Recovery Services Vault controls for Release 2.

Implemented in this lab pass:
- Recovery Services Vault
- daily VM backup policy
- protected item registration for vm-dev-client-01
- vault/protection settings review
- CLI-first evidence capture

## Protected workload

- VM: vm-dev-client-01
- Resource group: rg-dev-workload-norwayeast
- Backup vault: rsv-dev-backup
- Backup resource group: rg-dev-backup-norwayeast
- Backup policy: bp-dev-vm-daily

## RPO / RTO statement

Lab RPO target:
- 24 hours, based on daily VM backup policy.

Lab RTO target:
- Best-effort restore validation depending on lab budget and Azure Backup job completion time.

Enterprise RPO / RTO target:
- Defined per workload tier.
- Validated through scheduled restore tests and DR exercises.

## Immutability decision

In an enterprise production deployment, the Recovery Services Vault would use immutable vault protection and the immutability state would be locked after validation and change-control approval.

For this lab implementation, immutability is intentionally not locked. The lab keeps the vault in a teardown-safe state so that P9b resources can be removed after validation if required. This avoids unnecessary cost, retention lock-in, and deletion friction while still documenting the enterprise target-state control.

## Resource Guard / MUA decision

Enterprise target:
- Resource Guard / Multi-User Authorization is used to protect critical operations such as disabling soft delete, deleting backup data, or reducing protection.

Lab implementation:
- Resource Guard / MUA is documented as an enterprise delta and not enabled in this first lab pass unless explicitly implemented later.

## ASR decision

Enterprise target:
- Azure Site Recovery test failover would be used to validate application-level disaster recovery.

Lab implementation:
- ASR is documented as an enterprise delta and not enabled in this first lab pass.

## Completion criteria

P9b lab implementation is complete when:
- Recovery Services Vault is visible.
- Backup policy is visible.
- vm-dev-client-01 is registered as a protected item.
- Backup state is captured.
- Evidence is saved under docs/release2/evidence/P9b/.

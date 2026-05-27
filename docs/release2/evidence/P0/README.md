# P0 - OIDC Bootstrap & Terraform Backend

## What This Evidence Proves
The GitHub Actions workflow authenticates to Azure using OIDC (no static secrets), and the Terraform remote state backend was successfully configured with blob locking in Azure Storage.

## Evidence Inventory
- OIDC trust configuration artifacts
- Terraform backend initialization and remote-state locking evidence
- Pipeline run logs

## How to Interpret
Check that the pipeline runs produced no credential errors and that state files are stored remotely, not locally.

## Redaction Notes
Tenant IDs, subscription IDs, and service principal object IDs are removed. Pipeline run timestamps and resource group names are preserved for traceability.

## Related Capability Document
- [01. Landing Zone, IaC & Governance](../../01-landing-zone-iac-governance.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**The platform's CI/CD does not rely on long-lived secrets.** OIDC was operational from the first bootstrap phase.
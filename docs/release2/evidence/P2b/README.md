# P2b - Ansible Configuration Baseline & Private WinRM

## What This Evidence Proves
Ansible is integrated as the configuration management baseline for Windows hosts, using private WinRM paths and Key Vault-backed secrets. The environment is idempotent and re-runnable.

## Evidence Inventory
- Ansible playbook run logs
- Private WinRM connectivity test outputs
- Domain-join verification (idempotent re-run proof)

## How to Interpret
Confirm that playbooks complete without errors on a clean run and report no changes on a re-run, proving idempotency. Validate that secrets are referenced, not embedded.

## Redaction Notes
Internal hostnames, IP addresses, and Key Vault secret IDs are removed or masked.

## Related Capability Document
- [01. Landing Zone, IaC & Governance](../../01-landing-zone-iac-governance.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Host configuration is automated, repeatable, and secret-safe.**
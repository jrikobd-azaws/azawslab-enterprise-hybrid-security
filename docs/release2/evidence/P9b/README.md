# P9b - Backup & Recovery Services Vault (Base)

## What This Evidence Proves
A Recovery Services Vault is configured with immutability and Multi-User Authorization (Resource Guard). Soft-delete is validated.

## Evidence Inventory
- Vault configuration (immutability, soft-delete)
- MUA/Resource Guard settings
- Soft-delete teardown behavior logs

## How to Interpret
Verify that backup items exist, that delete operations require secondary approval, and that soft-deleted items are recoverable.

## Redaction Notes
Vault names and protected item details are partially redacted.

## Related Capability Document
- [03. Automation, SecOps & Resilience](../../03-automation-secops-resilience.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Backup is protected against accidental and malicious deletion.**
# P1 - Management Group Structure

## What This Evidence Proves
The Azure Management Group hierarchy was deployed as designed, separating platform subscriptions from workload subscriptions.

## Evidence Inventory
- Management group tree exports (CLI and/or portal)
- Subscription placement validation

## How to Interpret
Verify that platform subscriptions are isolated from workload subscriptions and that the hierarchy matches the governance model described in the architecture.

## Redaction Notes
Subscription IDs are partially masked; management group names are preserved.

## Related Capability Document
- [01. Landing Zone, IaC & Governance](../../01-landing-zone-iac-governance.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Governance scaffolding was in place before any workload resource was deployed.**
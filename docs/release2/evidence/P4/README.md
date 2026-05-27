# P4 - Azure Lighthouse Cross-Tenant Delegation

## What This Evidence Proves
Azure Lighthouse Reader delegation was successfully configured, enabling cross-tenant visibility for managed service scenarios.

## Evidence Inventory
- Lighthouse delegation configuration artifacts
- Cross-tenant portal view validation

## How to Interpret
Verify that a user in the managing tenant can see the delegated subscription with Reader permissions.

## Redaction Notes
Tenant IDs are redacted; the delegation name and role assignment scope are preserved.

## Related Capability Document
- [01. Landing Zone, IaC & Governance](../../01-landing-zone-iac-governance.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**The platform is multi-tenant ready, demonstrating MSP-style governance without complexity.**
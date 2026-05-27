# P3 - Azure Policy & RBAC Enforcement

## What This Evidence Proves
Azure Policy deny rules (region, VM SKU) and custom RBAC roles are actively enforced. Non-compliant deployments are rejected at the ARM level.

## Evidence Inventory
- Policy assignment outputs (pa-loc-prod-norwayeast, pa-vmsku-prod-b2alsv2)
- Deny-rejection logs (CLI/portal)
- Custom role definitions and assignment scopes

## How to Interpret
Attempt to deploy a VM in an unapproved region or using an unapproved SKU; the evidence should show the deployment blocked with a policy denial message.

## Redaction Notes
Policy definition IDs are kept; specific resource names in denial messages may be sanitized.

## Related Capability Document
- [01. Landing Zone, IaC & Governance](../../01-landing-zone-iac-governance.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Governance is preventative, not just detective. Bad configurations are blocked before creation.**
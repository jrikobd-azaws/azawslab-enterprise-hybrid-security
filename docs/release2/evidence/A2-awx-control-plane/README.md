# A2 - AWX Automation Control Plane

## What This Evidence Proves
The AWX control plane is fully operational: Entra ID SSO, RBAC, project sync, tiered job templates, and runtime secret retrieval from Key Vault/AWS SSM.

## Evidence Inventory
- AWX SSO configuration
- AWX job execution stdout logs
- Project sync status
- Inventory and template definitions

## How to Interpret
Review job stdout to see dynamic secret injection and successful task execution. Confirm that credentials do not appear in plaintext.

## Redaction Notes
AWX URLs, organization names, and secret references are sanitized; job success/failure states are kept.

## Related Capability Document
- [03. Automation, SecOps & Resilience](../../03-automation-secops-resilience.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Automation is governed, identity-integrated, and secretless - a true platform service.**
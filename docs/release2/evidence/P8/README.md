# P8 - Microsoft Sentinel Deployment

## What This Evidence Proves
Sentinel is provisioned with Log Analytics integration, policy exemption handling, Terraform validation, and post-apply validation evidence.

## Evidence Inventory
- Sentinel enablement status
- Provider and schema checks
- Policy exemption records
- Post-apply validation outputs

## How to Interpret
Verify that the Sentinel resource provider is registered and that deployment validation passed. For incident proof, check for explicit incident record files.

## Redaction Notes
Workspace IDs are masked; rule names and policy exemption details are preserved.

## Related Capability Document
- [03. Automation, SecOps & Resilience](../../03-automation-secops-resilience.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Sentinel deployment and validation are evidenced; incident proof should be linked only where captured.**
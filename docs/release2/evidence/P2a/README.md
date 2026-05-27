# P2a - Reusable Terraform Modules & Split-State Foundation

## What This Evidence Proves
Terraform modules are reusable, parameterized, and split across lifecycle-aware state roots. The IaC foundation supports independent planning of governance, networking, and workload layers.

## Evidence Inventory
- Terraform plan/apply outputs for module instantiation
- Remote state configuration evidence
- Drift check reports

## How to Interpret
Look for evidence that the same module code is used across multiple root configurations without copy-paste, and that state boundaries are enforced at the backend level.

## Redaction Notes
Resource IDs and subscription scopes are sanitized; provider registration details are kept.

## Related Capability Document
- [01. Landing Zone, IaC & Governance](../../01-landing-zone-iac-governance.md)
- [11. Terraform State & Pipeline Map](../../11-terraform-state-and-pipeline-map.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**The platform's IaC is modular and lifecycle-aware, reducing blast radius.**
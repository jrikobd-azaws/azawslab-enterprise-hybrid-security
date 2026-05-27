# O3c - Segmented Multi-Cloud Routing & Transitive Path Validation

## What This Evidence Proves
End-to-end traffic from on-premises HQ to AWS branch traverses the Azure hub, passes inspection, and returns symmetrically. BGP route segmentation and firewall state are preserved.

## Evidence Inventory
- Traceroute / path validation outputs
- Symmetric return path verification
- Firewall session logs during transit

## How to Interpret
Confirm that traffic flows HQ -> Azure -> AWS and back, with source/destination IPs consistent and firewall session entries showing both directions.

## Redaction Notes
Internal IPs are masked; hop sequence is kept.

## Related Capability Document
- [02. Hybrid & Multi-Cloud Networking](../../02-hybrid-multicloud-network-security.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**The multi-cloud transit architecture works end-to-end, not just in theory.**
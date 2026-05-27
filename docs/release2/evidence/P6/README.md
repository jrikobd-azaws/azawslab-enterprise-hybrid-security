# P6 - Azure Firewall Egress & Inspection

## What This Evidence Proves
Azure Firewall is operational and enforcing egress rules; east-west traffic inspection is validated.

## Evidence Inventory
- Firewall rule collections
- Traffic acceptance/denial logs
- Forced tunneling route validation

## How to Interpret
Look for log entries showing traffic being allowed or denied based on configured rules, and verify that spoke VMs route outbound traffic through the firewall.

## Redaction Notes
Public IPs and target FQDNs may be sanitized; rule names and priorities are preserved.

## Related Capability Document
- [02. Hybrid & Multi-Cloud Networking](../../02-hybrid-multicloud-network-security.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Validated egress paths route through Azure Firewall inspection.**
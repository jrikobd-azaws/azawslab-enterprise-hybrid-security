# O1 - FortiGate Service Chaining & Dual-Policy Inspection

## What This Evidence Proves
FortiGate NVA is integrated into the hub, performing deep packet inspection and service chaining with Azure Firewall. UDR steering directs traffic through the NVA.

## Evidence Inventory
- FortiGate policy and routing tables
- Service chaining validation (traffic flow logs)
- UDR next-hop verification

## How to Interpret
Trace traffic from a spoke workload to an external destination; confirm it passes through the FortiGate trusted interface.

## Redaction Notes
FortiGate interface IPs and policy rule names are partially redacted; traffic flow direction is preserved.

## Related Capability Document
- [02. Hybrid & Multi-Cloud Networking](../../02-hybrid-multicloud-network-security.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**NVA inspection is not "bolted on" - it is forced by design.**
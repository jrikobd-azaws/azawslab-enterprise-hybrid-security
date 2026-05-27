# P5 - Hub-Spoke Network Foundation

## What This Evidence Proves
The Azure hub VNet and spoke VNets are deployed with correct subnets, route tables, and NSGs in Norway East.

## Evidence Inventory
- VNet/subnet configuration exports (CLI)
- NSG rule sets
- Route table definitions

## How to Interpret
Compare the evidence against the network architecture diagram. Ensure that default routes point to the hub inspection appliances.

## Redaction Notes
Internal IP ranges are masked; VNet names and region are kept.

## Related Capability Document
- [02. Hybrid & Multi-Cloud Networking](../../02-hybrid-multicloud-network-security.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**The network fabric is deployed as code and validated against the intended hub-spoke design.**
# P5-vpn - VPN Gateway & IPSec Tunnel Preflight

## What This Evidence Proves
Azure VPN Gateway is configured and site-to-site IPSec tunnels to the simulated on-premises (VyOS) environment are validated. The preflight confirms tunnel establishment and BGP readiness.

## Evidence Inventory
- VPN Gateway configuration
- IPSec tunnel status (connected)
- BGP peer status outputs

## How to Interpret
Verify the tunnel is in a "Connected" state and BGP routes are being exchanged.

## Redaction Notes
Pre-shared keys are never included; peer IPs are masked.

## Related Capability Document
- [02. Hybrid & Multi-Cloud Networking](../../02-hybrid-multicloud-network-security.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Hybrid connectivity is proven end-to-end; BGP is actively exchanging routes.**
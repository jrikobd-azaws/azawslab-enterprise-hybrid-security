# O3b - AWS Branch Foundation & Selective BGP

## What This Evidence Proves
AWS Transit Gateway and Cisco CSR 8000V are configured. BGP peering is active, and route maps selectively advertise only trusted subnets to Azure.

## Evidence Inventory
- BGP neighbor status (Cisco CLI)
- Route advertisement tables
- Transit Gateway attachment configuration

## How to Interpret
Verify that only approved subnet prefixes appear in the Azure BGP learned routes table; DMZ prefixes are absent.

## Redaction Notes
Public IPs and AS numbers are redacted; prefix lists are preserved.

## Related Capability Document
- [02. Hybrid & Multi-Cloud Networking](../../02-hybrid-multicloud-network-security.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Multi-cloud routing is secure by design, not by default.**
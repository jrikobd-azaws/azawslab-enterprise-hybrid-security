O1 FortiGate Legacy IPSec Post-Cleanup Evidence

Purpose:
Capture FortiGate state after removing old direct FortiGate-to-VyOS IPSec residue.

Active design retained:
Azure workload -> FortiGate NVA service-chain -> Azure VPN Gateway -> VyOS/HQ

Removed legacy object:
ipsec-vyos / ipsec-vyos-p2

Evidence collected from vm-dev-mgmt-01 using FortiGate REST API token.
Token value is not stored in this evidence bundle.

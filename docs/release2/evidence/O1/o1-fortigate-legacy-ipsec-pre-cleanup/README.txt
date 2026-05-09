O1 FortiGate Legacy IPSec Pre-Cleanup Evidence

Purpose:
Capture FortiGate state before removing old direct FortiGate-to-VyOS IPSec residue.

Active design:
Azure workload -> FortiGate NVA service-chain -> Azure VPN Gateway -> VyOS/HQ

Legacy object under review:
ipsec-vyos

Notes:
Evidence collected from vm-dev-mgmt-01 using FortiGate REST API token.
Token value is not stored in this evidence bundle.

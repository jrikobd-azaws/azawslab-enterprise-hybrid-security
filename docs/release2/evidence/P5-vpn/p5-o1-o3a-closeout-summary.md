# P5/O1/O3a Closeout Summary

## Scope

This closeout records the final validated hybrid traffic-inspection state for the current Release 2 O1/P2b scope.

Covered scope:
- P5 hub-spoke networking foundation
- O3a Azure VPN Gateway to VyOS IPSec connectivity
- O1 FortiGate Azure-to-HQ service-chain validation
- HQ/DC1-to-Azure workload symmetry correction through FortiGate

O2 / Azure Arc is not closed in this checkpoint. No O2 evidence folder or Arc evidence exists in the local repository.

## Final architecture

```text
Azure workload / 10.10.0.4
        |
        | selected HQ/private traffic
        v
FortiGate port2 / 10.0.3.36
        |
        | FortiGate policy 1 or policy 11
        v
FortiGate port1 / 10.0.3.4
        |
        v
Azure VPN Gateway / 20.100.50.9
        |
        | IKEv2 / IPSec
        | AES256 / SHA256 / DHGroup14 / PFS14
        v
VyOS / HQ lab / 192.168.1.0/24
```

## Final FortiGate policy baseline

Policy 1:
- Name: `O1-AzureWorkload-to-HQ-Required-SNAT`
- Direction: `port2 -> port1`
- Source: `AZURE_WORKLOAD_10_10_0_0_16`
- Destination: `HQ_LAB_192_168_1_0_24`
- Services: `Windows AD`, `PING`, `NTP`
- NAT: enabled

Policy 11:
- Name: `O1-HQ-to-AzureWorkload-Web-ICMP`
- Direction: `port1 -> port2`
- Source: `HQ_LAB_192_168_1_0_24`
- Destination: `VM_DEV_CLIENT_10_10_0_4`
- Services: `HTTP`, `HTTPS`, `PING`
- NAT: disabled

## GatewaySubnet symmetry correction

The HQ/DC1-to-Azure workload path initially failed because of asymmetric routing.

Corrected path:

```text
DC1 / 192.168.1.10
  -> Azure VPN Gateway / GatewaySubnet
  -> GatewaySubnet UDR: 10.10.0.0/24 -> FortiGate port1 / 10.0.3.4
  -> FortiGate policy 11
  -> FortiGate port2 / 10.0.3.36
  -> vm-dev-client-01 / 10.10.0.4
  -> FortiGate port2
  -> FortiGate policy 1 / return path
  -> FortiGate port1
  -> Azure VPN Gateway
  -> DC1
```

The GatewaySubnet UDR was first validated manually, then reconciled into the platform networking Terraform design and applied through the normal GitHub Actions Terraform workflow.

## Evidence

Primary evidence:
- `docs/release2/evidence/P5-vpn/p5-o3a-fortigate-stage1-validation.txt`
- `docs/release2/evidence/P5-vpn/p5-o3a-azure-vpngw-vyos-data-plane-validation.txt`
- `docs/release2/evidence/P5-vpn/firewall-policy-current-post-gateway-udr.json`
- `docs/release2/evidence/P5-vpn/p5-fortigate-gateway-ingress-symmetry-validation.txt`

Supplementary screenshots:
- `docs/release2/evidence/P5-vpn/p5-o1-fortigate-two-policy-baseline.png`
- `docs/release2/evidence/P5-vpn/p5-o1-fortigate-service-groups.png`
- `docs/release2/evidence/P5-vpn/p5-o1-fortigate-custom-services.png`
- `docs/release2/evidence/P5-vpn/p5-o3a-fortigate-interface-mapping.png`

## Status

- P5 base hub-spoke networking: complete
- O1 FortiGate service-chain validation: complete for current Azure/HQ scope
- O3a Azure VPN Gateway to VyOS hybrid connectivity: complete
- O2 Azure Arc: not started / no evidence
- O3b AWS branch: not part of this closeout

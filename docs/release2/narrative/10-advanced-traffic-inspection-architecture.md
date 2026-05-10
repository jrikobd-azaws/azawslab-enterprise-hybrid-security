# 10-advanced-traffic-inspection-architecture

## 1. Objective

This chapter documents the optional O1 advanced traffic inspection pattern for Release 2.

The objective was to introduce FortiGate as a hybrid and east-west inspection NVA while preserving Azure Firewall as the internet and Azure public-control-plane egress service.

## 2. Business Problem

Hybrid environments need clear inspection boundaries. Sending every traffic class through one firewall creates policy bloat and operational ambiguity.

Release 2 uses a split inspection model:

```text
Azure Firewall:
  internet egress
  Azure public control plane
  Windows Update / Azure Arc / public Microsoft endpoints

FortiGate NVA:
  hybrid private traffic
  HQ private services
  east-west / branch inspection
  future AWS branch inspection after route path exists
```

## 3. Technical Solution

FortiGate was deployed in Azure as a two-NIC NVA:

```text
port1 / hub-untrusted side: 10.0.3.4
port2 / trusted/workload side: 10.0.3.36
```

The final O1 policy model was consolidated into two directional policies because the FortiGate lab license has a policy-entry limit.

Policy 1:
- Azure workload to HQ required services
- `port2 -> port1`
- Source: `AZURE_WORKLOAD_10_10_0_0_16`
- Destination: `HQ_LAB_192_168_1_0_24`
- Services: `Windows AD`, `PING`, `NTP`
- NAT: enabled

Policy 11:
- HQ to Azure workload web and ICMP validation
- `port1 -> port2`
- Source: `HQ_LAB_192_168_1_0_24`
- Destination: `VM_DEV_CLIENT_10_10_0_4`
- Services: `HTTP`, `HTTPS`, `PING`
- NAT: disabled

## 4. Architecture Snapshot

```text
Azure workload
  10.10.0.4
      |
      v
FortiGate port2
  10.0.3.36
      |
      | policy 1 or policy 11
      v
FortiGate port1
  10.0.3.4
      |
      v
Azure VPN Gateway
      |
      v
VyOS / HQ
  192.168.1.0/24
```

## 5. Implementation Summary

The O1 implementation validated FortiGate as the controlled inspection plane for private hybrid traffic.

The route design was refined after HQ/DC1-initiated traffic exposed asymmetric routing. A targeted GatewaySubnet UDR for `10.10.0.0/24` via FortiGate port1 `10.0.3.4` restored symmetry for the current O1/P2b scope.

The GatewaySubnet UDR was validated manually first, then reconciled into the platform networking Terraform design and applied through the normal GitHub Actions workflow.

AWS/O3b FortiGate policies are intentionally not created yet. They must remain disabled until the AWS-Cisco/O3b route path is active and validated.

## 6. Validation Summary

Validated:
- FortiGate VM running.
- FortiGate GUI reachable from approved management source.
- port1 and port2 interface mapping confirmed.
- FortiGate policy baseline consolidated into two directional policies.
- Azure workload to HQ private traffic validated.
- HQ/DC1 to Azure workload HTTP/ICMP path validated after GatewaySubnet symmetry correction.
- FortiGate policy export confirms the current two-policy model.

## 7. Evidence Path

Primary evidence:
- `docs/release2/evidence/O1/`
- `docs/release2/evidence/P5-vpn/firewall-policy-current-post-gateway-udr.json`
- `docs/release2/evidence/P5-vpn/p5-fortigate-gateway-ingress-symmetry-validation.txt`
- `docs/release2/evidence/P5-vpn/p5-o1-o3a-closeout-summary.md`

Supplementary screenshots:
- `docs/release2/evidence/P5-vpn/p5-o1-fortigate-two-policy-baseline.png`
- `docs/release2/evidence/P5-vpn/p5-o1-fortigate-service-groups.png`
- `docs/release2/evidence/P5-vpn/p5-o1-fortigate-custom-services.png`

## 8. Lessons Learned

- FortiGate inspection must be proven with routes, policies, and traffic evidence, not route-table changes alone.
- GatewaySubnet ingress routing can affect traffic symmetry and must be documented carefully.
- Lab license limits require consolidated policy design.
- Azure Firewall and FortiGate should retain separate architectural responsibilities.

## 9. Recruiter-Ready Outcome Statement

Implemented and validated a dual-firewall hybrid inspection model using Azure Firewall for public egress and FortiGate NVA for private hybrid traffic. Resolved asymmetric HQ-to-Azure routing with a targeted GatewaySubnet UDR, consolidated FortiGate rules into a clean two-policy model, and preserved future AWS branch inspection behind route-readiness gates.

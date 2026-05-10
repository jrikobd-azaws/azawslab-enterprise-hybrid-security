# 12-hybrid-and-multi-cloud-routing

## 1. Objective

## 2. Business Problem

## 3. Technical Solution

## 4. Architecture Snapshot

## 5. Implementation Summary

## 6. Validation Summary

## 7. Evidence Path

## 8. Key Commands Used

## 9. Lessons Learned

## 10. Recruiter-Ready Outcome Statement

---

## P5/O3a Hybrid Connectivity Extension - FortiGate, VPN Gateway, and VyOS

This phase extends the completed Azure hub-spoke networking foundation into a controlled hybrid connectivity pattern. The objective is to connect the Azure platform to the local Hyper-V lab through a secure IPSec path so that Azure-hosted management and Ansible orchestration can later reach private lab systems without exposing them directly to the internet.

The Terraform ownership boundary remains in the platform networking root because the resources involved are network-transit components: VPN Gateway, Local Network Gateway, VPN connection objects, FortiGate-related network resources, and route-table updates. This avoids mixing hybrid transit resources into workload or management state.

```text
[terraform/platform-networking/dev]
        |
        | backend key:
        | platform-networking-dev.tfstate
        |
        +--> Existing P5 hub/spoke networking
        +--> New fortigate-vpn.tf skeleton
              |
              +--> FortiGate-related Azure resources
              +--> VPN Gateway resources
              +--> Local Network Gateway for VyOS
              +--> VPN connection
              +--> route-table updates for 192.168.1.0/24

[Hyper-V / VyOS]
        |
        | DDNS peer:
        | vyos01.hq.azawslab.co.uk
        |
        v
[192.168.1.0/24 lab subnet]
```

### Lab Delta

In a production enterprise environment, the remote peer would normally use a stable static public IP address, redundant edge devices, controlled change windows, and formal routing/firewall approval. In this lab, the Hyper-V edge is represented by VyOS with Dynamic DNS. This is documented as a lab-safe adaptation to prove the routing and automation pattern without requiring business-grade WAN services.

### Current Deployment Safety

The FortiGate and VPN resources are held behind Terraform enable flags and are not deployed by local apply. Local PowerShell and Terraform commands are used only for preflight, validation, and evidence capture. Any future apply must run through the controlled GitHub Actions release-2 environment using OIDC.

### Validation Intent

Successful validation will prove that Azure can route to the Hyper-V lab subnet through the approved VPN path. This is a prerequisite before Azure-hosted Ansible orchestration can perform domain join, configuration management, or server administration against private Hyper-V systems.


## P5/O3a Hybrid Connectivity Decision: Decoupling IPSec Termination from NVA Inspection

The P5/O3a hybrid connectivity milestone established secure connectivity between the Azure hub/spoke environment and the Hyper-V/VyOS lab network.

The final implemented design separates encrypted tunnel termination from future security inspection:

```text
[Azure Workload Spoke]
  vm-dev-client-01 / 10.10.0.4
        |
        | route to 192.168.1.0/24 learned via hub VPN Gateway
        |
[Azure Hub VNet]
  Azure VPN Gateway
        |
        | IKEv2 / IPSec
        | AES256 / SHA256 / DHGroup14 / PFS14
        |
[VyOS01 / Hyper-V]
  vyos01.hq.azawslab.co.uk
  192.168.1.0/24
        |
        v
[Home / HQ Lab]
```

FortiGate was originally selected as the Azure hub NVA and successfully deployed through Terraform. The deployment validated a real NVA foundation:

- Key Vault-backed FortiGate admin credential.
- Azure Policy-governed VM SKU.
- Restricted management NSG rule.
- Two-NIC FortiGate model.
- IP forwarding enabled.
- FortiGate GUI access validated.

During IPSec validation, the FortiGate BYOL permanent evaluation license was found to restrict IPSec proposals to DES-class low-encryption options. VyOS did not support single DES, and using legacy DES would not meet the project security baseline.

Rather than weaken the cryptographic standard, the design was pivoted to a service-chaining-ready model:

```text
Azure VPN Gateway:
  managed AES-256 IPSec tunnel termination

FortiGate NVA:
  deployed inspection and segmentation plane

VyOS:
  simulated HQ/branch edge
```

This is an enterprise-aligned design decision because it separates the connectivity plane from the inspection plane. The Azure VPN Gateway provides managed route-based IPSec termination, while FortiGate remains available for controlled service-chaining and inspection validation in the next phase.

The final tunnel successfully negotiated:

```text
IKEv2
AES256
SHA256
DHGroup14
PFS14
NAT-T
```

Gateway transit was enabled on the hub/spoke peering so the workload spoke could learn the HQ lab prefix through the hub VPN Gateway:

```text
192.168.1.0/24 -> VirtualNetworkGateway
```

Final data-plane validation confirmed:

```text
Azure workload VM 10.10.0.4 -> VyOS LAN gateway 192.168.1.254
VyOS LAN source 192.168.1.254 -> Azure hub FortiGate interface 10.0.3.4
```

This milestone demonstrates a realistic enterprise architecture pattern: native Azure VPN Gateway for supportable encrypted connectivity, with FortiGate retained as the NVA inspection plane for future service chaining.

---

## Next Phase Gate: FortiGate Service Chaining / Inspection

Controlled FortiGate service chaining for selected Azure workload to HQ traffic has been validated for the current O1/P2b scope.

This must not be treated as only an Azure UDR change. The FortiGate must be able to route, permit, log, and count the traffic before Azure workload traffic is steered to it.

Target path:

```text
[Azure Workload VM]
  10.10.0.4
      |
      | future narrow UDR:
      | 192.168.1.0/24 -> VirtualAppliance 10.0.3.36
      v
[FortiGate trusted interface]
  10.0.3.36
      |
      | FortiGate route / policy / logging
      | optional lab SNAT only if required for first symmetric validation
      v
[Azure VPN Gateway]
  20.100.50.9
      |
      v
[VyOS / HQ Lab]
  192.168.1.254 / 192.168.1.0/24
```

Required validation before claiming inspection:
- workload effective route shows `192.168.1.0/24` via `10.0.3.36`
- Azure workload can reach `192.168.1.254`
- Azure VPN connection remains connected and counters increase
- FortiGate policy counters or logs prove traffic traversal

GatewaySubnet route changes require explicit justification. For this lab, the `10.10.0.0/24` ingress route was researched, validated, and codified to correct asymmetric HQ-to-Azure workload routing.


---

## O1 Service-Chain Route Design: Workload to HQ via FortiGate

The O1 service-chain validation introduces a narrow workload route that sends only the HQ lab prefix to the FortiGate trusted interface. This is not a broad forced-tunnelling change and does not modify the GatewaySubnet.

```text
[Azure Workload VM]
  vm-dev-client-01 / 10.10.0.4
        |
        | Azure workload subnet UDR:
        | 192.168.1.0/24 -> VirtualAppliance 10.0.3.36
        v
[FortiGate trusted interface]
  port2 / 10.0.3.36
        |
        | FortiGate policy:
        | source      = 10.10.0.0/16
        | destination = 192.168.1.0/24
        | service     = PING for first validation
        | logging     = enabled
        | NAT         = enabled as lab delta
        v
[FortiGate hub interface]
  port1 / 10.0.3.4
        |
        | existing Azure hub path
        v
[Azure VPN Gateway]
  20.100.50.9
        |
        | IKEv2/IPSec to VyOS
        v
[VyOS / HQ Lab]
  192.168.1.254 / 192.168.1.0/24
```

### Validation Requirements

FortiGate inspection must not be claimed from the route alone. Success requires evidence across four planes:

```text
Routing plane:
  Workload effective route shows 192.168.1.0/24 via 10.0.3.36.

Data plane:
  vm-dev-client-01 reaches 192.168.1.254.

Control plane:
  Azure VPN Gateway to VyOS remains connected and counters increase.

Security plane:
  FortiGate session table, logs, or policy counters show policy ID 1 handling the test traffic.
```

### Lab Delta

SNAT is enabled on the first FortiGate validation policy to avoid asymmetric return routing during the initial proof. This is a controlled lab delta and should be revisited before presenting the design as a production service-chaining pattern.


---

## O1 Closeout: FortiGate Azure-to-HQ Service-Chain Validation

O1 validated the first controlled FortiGate NVA service-chain path for Azure workload traffic destined to the HQ lab subnet.

### Validated Traffic Direction

```text
Azure workload -> HQ/VyOS
```

HQ/DC1-initiated inspection toward the Azure workload was later validated for the current O1/P2b scope using a targeted GatewaySubnet UDR and FortiGate policy 11.

### Final Validated Path

```text
[Azure Workload VM]
  vm-dev-client-01 / 10.10.0.4
        |
        | Azure workload subnet UDR:
        | 192.168.1.0/24 -> VirtualAppliance 10.0.3.36
        v
[FortiGate trusted interface]
  port2 / 10.0.3.36
        |
        | FortiGate policy ID 1:
        | source      = 10.10.0.0/16
        | destination = 192.168.1.0/24
        | service     = PING
        | action      = accept
        | logging     = enabled
        | NAT         = enabled
        v
[FortiGate hub interface]
  port1 / 10.0.3.4
        |
        | existing Azure hub path
        v
[Azure VPN Gateway]
  20.100.50.9
        |
        | IKEv2/IPSec to VyOS
        v
[VyOS / HQ Lab]
  192.168.1.254 / 192.168.1.0/24
        |
        | ICMP reply returns to 10.0.3.4,
        | FortiGate de-NATs and forwards back to 10.10.0.4
        v
[Azure Workload VM]
  vm-dev-client-01 / 10.10.0.4
```

### Evidence Summary

Azure routing proof:
```text
192.168.1.0/24 -> VirtualAppliance -> 10.0.3.36
```

FortiGate debug flow proof:
```text
Allowed by Policy-1: SNAT
SNAT 10.10.0.4 -> 10.0.3.4
gw 10.0.3.1 via port1
```

VyOS packet proof:
```text
vti1 In   10.0.3.4 -> 192.168.1.254  ICMP echo request
vti1 Out  192.168.1.254 -> 10.0.3.4  ICMP echo reply
```

FortiGate four-leg sniffer proof:
```text
port2 in   10.10.0.4 -> 192.168.1.254  echo request
port1 out  10.0.3.4 -> 192.168.1.254   echo request
port1 in   192.168.1.254 -> 10.0.3.4   echo reply
port2 out  192.168.1.254 -> 10.10.0.4  echo reply
```

### Lab Delta

SNAT was enabled on the first validation policy to avoid asymmetric return routing. This is acceptable for the lab proof because the purpose was to validate that the FortiGate NVA could receive, inspect, translate, forward, and return Azure workload traffic through the hybrid path.

A production design should separately evaluate:
- whether SNAT should remain
- whether symmetric routing without NAT is required
- VPN Gateway ingress traffic for the Azure workload /24 was steered through FortiGate for the current O1/P2b scope
- GatewaySubnet route-table association was validated and reconciled into Terraform for the current lab design

### Final O1 Status

O1 is validated for Azure workload to HQ service chaining and HQ/DC1-to-Azure workload symmetry through FortiGate NVA for the current O1/P2b scope.

Not yet validated:
- HQ-initiated traffic to Azure workloads through FortiGate
- bidirectional inspection
- GatewaySubnet ingress steering
- production no-NAT service-chain design

## P5/O1/O3a Closeout: Symmetric Hybrid Inspection Path

The later P5/O1 validation completed the reverse HQ/DC1-to-Azure workload path.

Final validated path:

```text
DC1 / 192.168.1.10
  -> Azure VPN Gateway / GatewaySubnet
  -> GatewaySubnet UDR: 10.10.0.0/24 -> FortiGate port1 / 10.0.3.4
  -> FortiGate policy 11
  -> FortiGate port2 / 10.0.3.36
  -> vm-dev-client-01 / 10.10.0.4
  -> FortiGate return path
  -> Azure VPN Gateway
  -> DC1
```

The current FortiGate policy model remains deliberately small because of the lab license policy-entry limit:
- Policy 1: Azure workload to HQ required services with SNAT.
- Policy 11: HQ to Azure workload HTTP/HTTPS/ICMP without NAT.

AWS/O3b inspection policies remain disabled until the AWS-Cisco route path is active and validated.


---

## O3b/O3c Global Transit Direction - Azure VPN Gateway Hub

The validated P5/O1/O3a design remains the foundation for O3b and O3c.

Azure VPN Gateway is the external IPSec/BGP hub. FortiGate is the Azure-side inspection and service-chaining plane. VyOS remains the HQ/on-prem edge. Cisco Catalyst 8000V becomes the AWS branch edge.

```text
                         Azure Hub
                            |
                    [Azure VPN Gateway]
                       ASN: 65515
                            |
              +-------------+-------------+
              |                           |
          IPSec/BGP                   IPSec/BGP
              |                           |
              v                           v
       [VyOS / HQ Lab]            [Cisco 8000V / AWS]
          ASN: 65001                  ASN: 65002
          192.168.1.0/24              172.16.0.0/16
```

O3b validates the Cisco 8000V to Azure VPN Gateway IPSec/BGP path. O3c validates transitive routing between Azure, HQ, and AWS.

FortiGate remains available for service-chained inspection. However, inspection is only claimed for traffic flows where FortiGate policy counters or logs prove traversal.


---

## O3b Segmented BGP Route-Control Requirement

The O3b AWS branch validation must show route-control discipline.

The first Cisco 8000V BGP validation should not advertise the entire AWS VPC summary. Instead, it should advertise only the approved trusted branch prefix:

```text
Advertise:
  172.16.1.0/24

Do not advertise:
  172.16.2.0/24
```

This produces two useful validation outcomes:

```text
Trusted AWS subnet:
  participates in private hybrid routing.

DMZ AWS subnet:
  remains excluded from private hybrid route propagation until explicitly approved.
```

This supports the enterprise security story: BGP is not simply turned on globally; branch prefixes are intentionally selected, validated, and documented.


---

## O5 Secure Admin and Dev Workspace Direction

O5 extends the platform with a secure admin and development workspace using Azure Virtual Desktop and FSLogix.

The AVD environment is intended to provide a controlled workspace for platform administration, hybrid administration, and future AKS/container workflows.

```text
[Admin / Engineer]
      |
      | AVD broker path
      v
[AVD Session Host]
  optional/admin spoke: 10.2.0.0/16
      |
      +-- Azure Firewall:
      |     internet, SaaS, updates, AVD control-plane egress
      |
      +-- FortiGate:
      |     hybrid/private paths where service-chained and validated
      |
      +-- Azure Files Private Endpoint:
            FSLogix profile containers
```

This keeps local developer machines out of the privileged management path and supports a more enterprise-aligned secure workspace model.

O5 should not claim AKS operational validation unless AKS exists. Until then, O5 should validate the admin/dev toolchain readiness only.


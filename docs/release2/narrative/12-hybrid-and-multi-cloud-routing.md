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

The next implementation target is controlled FortiGate service chaining for selected Azure workload to HQ traffic.

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

Do not modify GatewaySubnet routes unless separately researched and justified.


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


# 02. Hybrid & Multi-Cloud Network Security

> **Part of** [Release 2 - Azure Platform Engineering, Security, Automation, Private Platform & AI Operations](./README.md)
>
> **Status:** Implemented and evidenced.

---

## What This Solves

Enterprise platform networks must prove more than basic VNet peering. They need controlled ingress and egress, dynamic routing, traffic inspection, branch namespace separation, and validated paths across cloud and simulated on-premises environments.

This capability story proves the design and validation of a secure, multi-cloud transit architecture that connects Azure, AWS, and simulated on-premises environments through IPSec tunnels, BGP, and layered firewall inspection. It also establishes the branch office namespace `br1.azawslab.co.uk` as an isolated branch namespace and routing boundary, not a Git branch.

---

## What Was Built

| Layer | Components | Evidence |
|---|---|---|
| **Hub-Spoke Foundation** | Azure hub VNet, spoke VNets, subnets, route tables, and network security groups in Norway East | `docs/release2/evidence/P5/` |
| **Azure Firewall** | Central egress and east-west inspection, force-tunneling, application and network rules | `docs/release2/evidence/P6/` |
| **FortiGate NVA** | Dual-policy inspection, hybrid traffic control, service chaining with Azure Firewall via User-Defined Routes (UDRs) | `docs/release2/evidence/O1/` |
| **VPN & IPSec** | Azure VPN Gateway, site-to-site IPSec tunnel validation for VyOS branch/on-premises patterns and multi-cloud transit preflight | `docs/release2/evidence/P5-vpn/` |
| **AWS Branch Foundation** | AWS Transit Gateway, Cisco CSR 8000V, BGP peering, selective route propagation via route maps | `docs/release2/evidence/O3b/` |
| **Segmented Multi-Cloud Routing** | BGP route filtering, symmetric path engineering, transitive path validation from HQ through Azure hub to AWS branch | `docs/release2/evidence/O3c/` |
| **Automated Network Audit** | Read-only Ansible playbooks extracting interface states, routing tables, and firewall policies; configuration backups | `docs/release2/evidence/A1-ansible-network-baseline/` |

---

## Architecture

```text
                        ┌------------------------┐
                        |   On-Premises (VyOS)   |
                        |   br1.azawslab.co.uk   |
                        `-----------┬------------┘
                                    | IPSec Site-to-Site Tunnel
                                    ▼ (Dynamic eBGP Peering)
                        ┌------------------------┐
                        |   Azure VPN Gateway    |
                        |   (GatewaySubnet)      |
                        `-----------┬------------┘
                                    |
          ┌-------------------------┼-------------------------┐
          | UDR Next-Hop Steering   | UDR Next-Hop Steering   |
          ▼                         ▼                         ▼
┌-------------------┐     ┌-------------------┐     ┌-------------------┐
|  Azure Firewall   |     |   FortiGate NVA   |     |    Spoke VNets    |
| Centralized Cloud |◄---►| Deep Hybrid Trust |◄---►| (Private AKS O4,  |
| Egress Filtermaps |     | Policy Inspection |     |  AVD Workspace O5)|
`-------------------┘     `-------------------┘     `-------------------┘
          ▲
          | IPSec Site-to-Site Tunnel
          | (Dynamic eBGP Peering)
          ▼
┌----------------------------------------------------------------------┐
|                              AWS Cloud                               |
|  ┌----------------------------------------------------------------┐  |
|  |       AWS Transit Gateway Peering & Cisco CSR 8000V Edge       |  |
|  |   Route-Map Policy Matrix: Propagates Trusted Workload Subnets |  |
|  |   Explicitly Drops/Withholds Dynamic DMZ Subnet Advertisements |  |
|  `----------------------------------------------------------------┘  |
`----------------------------------------------------------------------┘
```

![Release 2 hybrid multi-cloud network security](../../diagrams/release2/hybrid-multicloud-network-security.png)

---

## How It Works

### 1. Hub-Spoke with Dual-Firewall Inspection via UDRs

Traffic entering the hub VNet is steered by **User-Defined Routes** applied to the `GatewaySubnet` and spoke subnets. Ingress packets are directed first to the FortiGate NVA trusted interface for deep packet inspection, then to Azure Firewall for cloud egress evaluation. This service chaining eliminates single-point inspection bypass and enforces symmetric inspection.

### 2. IPSec and eBGP for Dynamic Multi-Cloud Routing

IPSec tunnels carry BGP sessions between the Azure VPN Gateway, VyOS, and AWS Cisco CSR. Dynamic route exchange replaces static route tables, enabling faster failover and cleaner topology management. On the AWS side, the Cisco CSR applies route-map policies that advertise only trusted workload subnets and explicitly withhold DMZ prefixes, preventing route table pollution and asymmetric path failures.

### 3. Branch Namespace Isolation

The branch office namespace `br1.azawslab.co.uk` is a network and routing boundary, not a Git branch. It separates branch-originated traffic and identity from the core `hq.azawslab.co.uk` domain, allowing firewall policies, DNS zones, and routing tables to be scoped without cross-contamination.

### 4. Transitive Routing Validation

The O3c evidence validates the full end-to-end path: traffic originates from on-premises HQ, passes through the Azure hub (inspected by FortiGate and Azure Firewall), and reaches the AWS branch via BGP-learned routes. Return traffic follows the symmetric path, proving stateful inspection across every hop.

### 5. Read-Only Ansible Audit

A1 playbooks run as read-only service accounts against FortiGate, VyOS, and Cisco devices. They extract routing tables, firewall policies, and interface statuses without making configuration changes. Outputs are stored as version-controlled `.txt` evidence, forming an immutable audit trail.

---

## Evidence

| What | Where | Why It Matters |
|---|---|---|
| Hub-spoke network foundation | `docs/release2/evidence/P5/` | Proves the network architecture deployed as designed |
| Azure Firewall egress and inspection | `docs/release2/evidence/P6/` | Proves controlled egress and east-west traffic inspection |
| FortiGate service chaining and UDR steering | `docs/release2/evidence/O1/` | Proves NVA integration alongside native firewall |
| IPSec tunnels and VPN preflight | `docs/release2/evidence/P5-vpn/` | Proves site-to-site connectivity to on-premises and AWS |
| AWS branch foundation with BGP route filtering | `docs/release2/evidence/O3b/` | Proves multi-cloud transit and selective route propagation |
| Segmented routing and transitive validation | `docs/release2/evidence/O3c/` | Proves end-to-end path and symmetric stateful inspection |
| Ansible read-only device state validation | `docs/release2/evidence/A1-ansible-network-baseline/` | Proves automated audit and backup without configuration drift |

---

## Operational Notes

- **UDR-driven inspection:** Spoke VNet route tables use default routes (`0.0.0.0/0`) pointing to hub inspection appliances. Private workload routing is designed to use hub inspection paths rather than direct internet egress.
- **Symmetric path enforcement:** BGP weight and metric settings ensure traffic enters and exits through the same firewall instance, preserving stateful session tracking.
- **FortiGate, VyOS, and Cisco device states are validated through Ansible read-only playbooks.** Configuration changes remain subject to the same reviewed delivery discipline as other platform changes.
- **Namespace `br1.azawslab.co.uk` is a network boundary, not a Git branch.** It isolates routing and DNS without polluting the core platform.
- **IPSec with dynamic BGP** is the foundation for hybrid and multi-cloud transit, not static routing.

---

## What I Learned

- **Dual-firewall architecture is operationally valuable.** Azure Firewall handles cloud-native egress efficiently; FortiGate provides deep enterprise inspection. Together they cover a wider threat spectrum.
- **BGP in a multi-cloud lab demands explicit route filtering.** Without route maps on the Cisco CSR, DMZ subnets leak and asymmetric paths can break stateful firewall sessions.
- **Separating the branch namespace at the network layer prevents identity spillover.** It is a foundational decision that simplifies security policy before any workload exists.
- **Ansible read-only validation turns device state into version-controlled evidence.** It provides an audit trail without risking configuration drift from automated changes.

---

## Implementation Positioning

This multi-cloud network architecture demonstrates layered inspection, dynamic routing, namespace isolation, and transitive path validation across Azure, AWS, and simulated on-premises environments. The integration of Azure Firewall, FortiGate NVA, VyOS, and Cisco CSR, validated through CLI-first evidence and Ansible audit playbooks, provides strong signals for **Hybrid Cloud / Infrastructure Engineer** and **Cloud Security Architect** roles.

Reviewers should focus on:
- The UDR-driven service chaining that forces symmetric inspection.
- The BGP route filtering design, not just connectivity.
- The evidence of transitive path validation (O3c), proving the architecture works end-to-end.
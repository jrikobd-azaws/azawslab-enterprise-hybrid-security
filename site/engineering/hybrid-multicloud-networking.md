# Hybrid & Multi-Cloud Networking

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/engineering/hybrid-identity/">
    <span class="portfolio-chip-label">R1</span>
    <span class="portfolio-chip-value portfolio-chip-value-ready">Workplace</span>
  </a>
  <a class="portfolio-chip" href="/engineering/terraform-state-boundaries/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Delivery</span>
  </a>
  <a class="portfolio-chip" href="/engineering/hybrid-multicloud-networking/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value portfolio-chip-value-active">Network</span>
  </a>
  <a class="portfolio-chip" href="/engineering/private-aks-platform/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Platform</span>
  </a>
  <a class="portfolio-chip" href="/engineering/automation-control-plane/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Operations</span>
  </a>
</div>

!!! summary "Scope"
    Network architecture notes and evidence paths for the hybrid and multi-cloud fabric connecting simulated on-premises services, Azure hub-spoke networking, FortiGate inspection, and the AWS branch. It covers IPSec, BGP, VyOS with Dynu-backed real DNS, Azure VPN Gateway, Azure Firewall, FortiGate NVA service chaining, AWS Transit Gateway, Cisco CSR 8000V, and validated transitive routing.

## Network architecture

AzAWSLab implements a routable hybrid and multi-cloud fabric across three environments:

- Simulated on-premises services behind a VyOS router.
- Azure hub-spoke networking with firewall and NVA inspection paths.
- AWS branch networking with Transit Gateway and Cisco CSR 8000V validation.

```text
On-premises / branch simulation
  VyOS router
  Dynu real DNS hostname for dynamic WAN IP
  AD DS, DNS, Exchange Hybrid
        |
        | IPSec VPN and BGP
        v
Azure Hub VNet
  Azure VPN Gateway
  enterprise extension: active-active or zone-resilient gateway
  Azure Firewall
  FortiGate NVA inspection path
        |
        | VNet peering and UDR steering
        v
Azure Spokes
  AKS spoke
  AVD spoke
  Management spoke
        |
        | IPSec VPN and BGP transit path
        v
AWS Branch
  Transit Gateway
  Cisco CSR 8000V
  BGP route-map filtering
  EC2 validation host
```

The lab validates the routing and inspection model without presenting every production high-availability option as deployed. In a production enterprise design, the same IPSec/BGP pattern can extend to active-active or zone-resilient Azure VPN Gateway, redundant customer gateways, dual tunnels, and stricter availability controls where the business case justifies the cost.

## Design decisions

| Decision | Rationale | Evidence path |
|---|---|---|
| Hub-spoke network fabric | Centralizes shared inspection, routing, VPN, and management paths while keeping workload spokes isolated. | [`terraform/platform-networking/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-networking/dev) and [`docs/release2/evidence/P5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5) |
| IPSec and BGP for hybrid connectivity | Provides route exchange and realistic site-to-site routing behavior instead of relying only on static routes. | [`docs/release2/evidence/P5-vpn/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5-vpn) |
| VyOS with Dynu-backed real DNS | Supports an ephemeral, cost-controlled lab WAN address while still using a real DNS hostname for the VPN peer identity. | VPN and VyOS evidence under [`docs/release2/evidence/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence) |
| Cost-controlled VPN gateway with HA-ready production pattern | The lab demonstrates IPSec/BGP without carrying the cost of always-on active-active enterprise VPN design. The same pattern can be extended with active-active or zone-resilient gateway options, redundant customer gateways, and dual tunnels. | VPN Gateway and BGP evidence in [`docs/release2/evidence/P5-vpn/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5-vpn); enterprise HA pattern documented on this page |
| FortiGate NVA service chaining | Adds third-party inspection and validates UDR-driven traffic steering through the hub inspection path. | [`docs/release2/evidence/O1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O1) |
| AWS Transit Gateway and Cisco CSR validation | Extends the fabric into AWS and proves multi-vendor route exchange, route-map filtering, and transitive path validation. | [`terraform/aws-branch/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/aws-branch/dev), [`docs/release2/evidence/O3b/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3b), and [`docs/release2/evidence/O3c/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3c) |

## VPN and dynamic DNS: VyOS + Dynu

The on-premises site is simulated on Hyper-V with a VyOS virtual router. Because the lab runs in an ephemeral, cost-controlled environment without a permanent static public IP, VyOS uses Dynu dynamic DNS to publish a real DNS hostname for the changing WAN address.

Azure VPN Gateway uses that DNS-backed peer identity for the IPSec path, allowing the tunnel to be re-established when the public address changes. This validates the same routing pattern that would normally be hardened in an enterprise deployment with static public IPs, redundant customer gateways, dual tunnels, and active-active or zone-resilient VPN Gateway design where availability requirements justify the cost.

The demonstrated configuration includes:

- IKE/IPSec tunnel establishment between VyOS and Azure VPN Gateway.
- BGP route exchange across the tunnel.
- Advertisement of the on-premises subnet into Azure.
- Dynu-backed dynamic DNS handling for the VyOS public endpoint.

This is the engineering distinction: the lab is cost-controlled, but the routing design is not casual. It validates the route exchange and tunnel pattern while documenting how the same architecture would be hardened for enterprise availability.

## BGP route propagation

BGP is used as the routing control plane across the hybrid and multi-cloud paths.

| Peer relationship | Advertises | Receives |
|---|---|---|
| VyOS to Azure VPN Gateway | Simulated on-premises prefixes | Azure hub and spoke prefixes |
| Azure VPN Gateway to VyOS | Azure hub and spoke prefixes | Simulated on-premises prefixes |
| Azure to AWS branch path | Azure-side prefixes | AWS branch prefixes |
| AWS branch to Azure | AWS VPC and branch prefixes | Azure-side prefixes |
| Cisco CSR 8000V | Filtered branch routing information | Routes required for validation and route-map testing |

The signal is not just that routes exist. The evidence shows dynamic routing, inspection, and validation across cloud and simulated on-premises boundaries. Route propagation is supported by BGP peer evidence, effective route tables, Cisco output, and transitive path testing.

## FortiGate NVA insertion

For traffic requiring deeper inspection than native routing alone provides, a FortiGate NVA is integrated into the Azure hub inspection path. User-defined routes steer selected traffic through the NVA, and the evidence validates policy and routing state, service-chain traffic flow, and next-hop behavior.

Validated signals include:

- FortiGate policy and routing table evidence.
- UDR next-hop steering.
- Service-chain validation through traffic-flow logs.
- Symmetric routing and return-path validation as part of the multi-cloud transit evidence.

**Evidence:** FortiGate service chaining and dual-policy inspection evidence in [`docs/release2/evidence/O1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O1), with transitive path validation in [`docs/release2/evidence/O3c/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3c).

## AWS branch gateway

The AWS branch is a dedicated multi-cloud validation environment. It extends the routing fabric beyond Azure and validates operation across provider boundaries.

The AWS branch includes:

- AWS Transit Gateway.
- Cisco CSR 8000V.
- BGP route-map filtering.
- AWS VPC routing.
- EC2 validation host for reachability checks.
- Terraform root isolation under `terraform/aws-branch/dev`.

The AWS branch validates that cross-cloud routing is not just a diagram. It is represented in infrastructure code and supported by evidence for routing, prefix propagation, and transitive path validation.

## Read-only network automation evidence

The network architecture is also validated through automation. AWX and Ansible evidence captures read-only state from FortiGate, VyOS, and Cisco devices without changing configuration.

This confirms the network can be observed and validated through a governed operations plane, not only through portal screenshots.

| Device or path | Validation signal |
|---|---|
| FortiGate | Policy, routing, and service-chain state captured through read-only automation. |
| VyOS | Routing and VPN-related state captured from the simulated on-premises router. |
| Cisco CSR 8000V | BGP and route-map state captured for AWS branch validation. |

## Enterprise production hardening pattern

The demonstrated lab topology is cost-controlled by design. In a production enterprise environment, the same architecture would normally be hardened with additional availability and governance controls.

| Area | Enterprise hardening pattern |
|---|---|
| VPN Gateway | Active-active or zone-resilient Azure VPN Gateway where availability requirements justify the cost. |
| Customer gateways | Redundant on-premises or branch routers with dual tunnels. |
| Public endpoints | Static public IPs or provider-managed resilient edge connectivity instead of dynamic residential-style WAN addressing. |
| Routing | BGP route filters, summarization, route dampening, and explicit route-map governance. |
| Inspection | HA NVA design, health probes, route failover testing, and firewall policy lifecycle controls. |
| Operations | Scheduled read-only validation, sanitized backups, idempotency checks, approved change workflow, and rollback testing through the automation control plane. |

This pattern is included to separate the evidence lab from the production hardening path. It shows the difference between the cost-controlled evidence lab and the production design standard expected in an enterprise environment.

## Architectural significance

Hybrid and Multi-Cloud Networking shows five network engineering decisions:

1. Routing is dynamic and validated with BGP, not only drawn as static connectivity.
2. The on-premises simulation uses VyOS and Dynu-backed real DNS to keep the lab practical while documenting the enterprise HA extension path.
3. Azure hub-spoke networking centralizes routing and inspection rather than scattering controls across isolated spokes.
4. FortiGate NVA insertion validates third-party inspection and UDR-based service chaining.
5. AWS branch integration with Transit Gateway and Cisco CSR 8000V validates the multi-cloud routing model.

This page establishes the network underlay for private platform services, AVD, AKS, AWX, and future Release 3 multi-cloud Kubernetes work.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Hub-spoke network fabric is deployed | [`docs/release2/evidence/P5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5) and [`terraform/platform-networking/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-networking/dev) | VNet/subnet exports, NSGs, route tables, default routes toward hub inspection appliances |
| Azure VPN Gateway and IPSec/BGP preflight are validated | [`docs/release2/evidence/P5-vpn/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5-vpn) | Tunnel connected state, BGP readiness, and exchanged routes |
| VyOS uses Dynu-backed dynamic DNS for the VPN peer endpoint | VyOS configuration and VPN evidence in [`docs/release2/evidence/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence) | Real DNS hostname, Dynu update path, and Azure VPN peer configuration using the DNS-backed endpoint |
| FortiGate NVA is inserted into the inspection path | [`docs/release2/evidence/O1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O1) | Policy/routing tables, UDR next-hop verification, service-chain traffic flow logs |
| AWS branch routing pattern uses Transit Gateway, Cisco CSR 8000V, BGP, and route maps | [`docs/release2/evidence/O3b/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3b) and [`terraform/aws-branch/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/aws-branch/dev) | Cisco BGP neighbor status, route advertisement tables, TGW attachment configuration, selective prefix propagation |
| End-to-end transitive routing is validated | [`docs/release2/evidence/O3c/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3c) | HQ to Azure to AWS path validation, symmetric return path, firewall session logs |
| Network device state is captured through read-only automation | [`docs/release2/evidence/A1-ansible-network-baseline/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A1-ansible-network-baseline) | FortiGate, VyOS, and Cisco state extracts, routing tables, firewall policies, sanitized backups |
| Enterprise HA extension path is documented | This page | Active-active or zone-resilient VPN Gateway, redundant customer gateways, dual tunnels, static public endpoints, HA inspection, and route governance patterns documented as production hardening options |

## Review takeaway

Hybrid and Multi-Cloud Networking shows that Release 2 has a routed network fabric, not a disconnected collection of cloud resources.

A reviewer can inspect Terraform roots, VPN evidence, FortiGate service-chain evidence, AWS branch validation, and read-only automation output to confirm hybrid routing, multi-cloud transit, inspection, and production hardening awareness.

# BGP Multi-Cloud Transit

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/engineering/hybrid-identity/">
    <span class="portfolio-chip-label">R1</span>
    <span class="portfolio-chip-value">Workplace</span>
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
    How AzAWSLab builds a segmented eBGP transit design across on-premises, Azure, and AWS. This page covers IPSec-based BGP peering, APIPA-style addressing, Cisco CSR route-map filtering, transitive path validation through the Azure hub inspection stack, free-tier-aware Azure-to-AWS validation, and symmetric return path proof.

## Architecture

```text
On-premises / HQ simulation
  VyOS router
  private AS
  APIPA BGP peer (169.254.x.x) toward Azure
  advertises: 10.0.0.0/24
        |
        | IPSec tunnel and BGP session
        v
Azure VPN Gateway
  private AS
  exchanges Azure hub and spoke reachability
  enterprise extension: active-active / zone-resilient gateway
        |
        | cost-controlled AWS branch validation path
        v
AWS Branch
  Transit Gateway
  Cisco CSR 8000V
  loopback-based validation path where used
  route-map filtering
  advertises: 172.16.0.0/16
  permits trusted workload prefixes
  withholds DMZ prefixes
```

Inter-site reachability is driven by BGP route exchange, while Azure user-defined routes still enforce firewall and NVA inspection paths. This is the correct separation of responsibility: BGP learns and distributes reachability; UDRs keep inspected traffic aligned with Azure Firewall and FortiGate service-chain controls.

## Design decisions

| Decision | Rationale | Evidence |
|---|---|---|
| Segmented eBGP design with separate private ASNs per environment | Keeps routing policy explicit at each boundary and reduces the risk of accidental prefix leakage. | VyOS, Azure VPN Gateway, and Cisco CSR configuration and evidence in P5-vpn, O3b, and O3c. |
| APIPA-style BGP peer addressing for Azure-to-VyOS | Uses 169.254.x.x BGP peer addressing so the peering addresses do not conflict with workload, hub, spoke, or on-premises private subnets. | P5-vpn evidence and Azure/VyOS BGP peer configuration captures. |
| Cisco CSR route-map filtering in AWS | Permits trusted workload prefixes and withholds DMZ prefixes before routes are accepted or advertised across the AWS branch path. | O3b Cisco CSR BGP, route-map, and Transit Gateway evidence. |
| Cost-controlled Azure-to-AWS validation path | The lab demonstrates route-control behavior without claiming a full production active-active cross-cloud VPN build. Loopback-based Cisco CSR validation is used where appropriate for the AWS branch model. | O3b and O3c evidence, with active-active documented as a production hardening pattern. |
| Transitive path validation with inspection | Proves traffic traverses the Azure hub inspection stack and returns symmetrically. | O3c traceroute, ping, inspection path, and symmetric return validation evidence. |

## Peering and prefix propagation

### On-premises VyOS to Azure

VyOS establishes an IPSec tunnel to Azure VPN Gateway and forms a BGP session using APIPA-style addresses in the 169.254.x.x range. This addressing choice keeps the BGP peering isolated from routable workload prefixes.

VyOS advertises the on-premises AD DS subnet `10.0.0.0/24` and receives Azure hub and spoke reachability in return. The BGP session remains tied to the VPN tunnel state.

**Evidence:** `docs/release2/evidence/P5-vpn/` contains VPN Gateway configuration, tunnel status, and BGP peer evidence.

### Azure to AWS branch

The Azure-to-AWS branch path is represented through the AWS Transit Gateway and Cisco CSR 8000V validation model. Because the lab is cost-controlled, this path does not claim the same full production active-active VPN gateway design that would be used in a higher-availability enterprise deployment.

The implemented evidence focuses on the route-control plane:

- Cisco CSR BGP state.
- Loopback-based validation where used.
- Route-map filtering.
- Trusted-prefix advertisement.
- DMZ prefix withholding.
- AWS branch route propagation evidence.
- End-to-end transit validation through Azure hub inspection.

This demonstrates routing policy, multi-vendor interoperability, and branch transit control without overstating the deployed lab topology.

### Cisco CSR route filtering

Inside the AWS branch, Cisco CSR 8000V participates in the routing design and applies route-map filtering. The route policy separates trusted workload prefixes from DMZ or infrastructure prefixes that should not be propagated.

This is an important enterprise control. Multi-cloud routing should not mean every prefix is shared everywhere. The CSR route-map evidence shows that the branch path is governed by policy, not just connected.

**Evidence:** `docs/release2/evidence/O3b/` contains Cisco CSR BGP, route-map, and AWS Transit Gateway evidence.

## Transit path validation

The O3c evidence validates that BGP-advertised reachability works as an end-to-end path, not just as routing table entries.

The validation proves:

- Traffic originates from the on-premises / HQ side.
- It traverses the Azure hub.
- It passes through FortiGate and Azure Firewall inspection points.
- It reaches the AWS branch through BGP-learned reachability.
- Return traffic follows the expected symmetric path.

Validation signals include ping, traceroute, firewall or inspection logs, effective routes, and route tables where captured.

**Evidence:** `docs/release2/evidence/O3c/` contains transitive path and symmetric return validation evidence.

## APIPA-style BGP addressing

Azure VPN Gateway supports APIPA-style BGP peer addressing. AzAWSLab uses a 169.254.x.x BGP peer pattern for the Azure-to-VyOS session.

This design choice is deliberate:

- It avoids overlap with workload, hub, spoke, and on-premises prefixes.
- It keeps BGP peer addressing out of the production workload address plan.
- It mirrors the way enterprise VPN designs isolate tunnel-adjacent control-plane addressing.
- It can be extended to active-active gateway designs where each gateway instance has distinct BGP peer addressing.

The lab keeps the deployed gateway cost-controlled, but the BGP design demonstrates awareness of the enterprise HA extension path.

## Multi-vendor BGP interoperability

The routing design spans multiple BGP implementations:

- VyOS for simulated on-premises routing.
- Azure VPN Gateway for cloud VPN and route exchange.
- Cisco CSR 8000V for AWS branch route-policy validation.
- AWS Transit Gateway for branch route propagation.

This is not a single-vendor demo. It demonstrates that the platform can exchange and govern routes across open-source routing, Microsoft cloud networking, Cisco IOS-XE, and AWS transit constructs.

## BGP and inspection are separate control planes

A mature hybrid design separates route learning from inspection enforcement.

| Control plane | Responsibility |
|---|---|
| BGP | Exchanges reachability between on-premises, Azure, and AWS branch routing domains. |
| UDRs | Force selected Azure paths through Azure Firewall and FortiGate inspection. |
| Route maps | Control which prefixes are advertised, accepted, or withheld across the AWS branch path. |
| Firewall policy | Enforces allowed traffic once routing has delivered the flow to the inspection point. |

This distinction matters. BGP makes the path reachable. UDRs and firewall policy make the path governable.

## Enterprise hardening pattern

In a full production deployment, the same BGP design can be extended with additional controls:

- Prefix lists and AS-path filters on every peer to govern accepted and advertised prefixes.
- BGP authentication where supported and required by policy.
- Bidirectional Forwarding Detection for faster failure detection on critical tunnels.
- Active-active or zone-resilient VPN gateways with dual BGP sessions.
- Route dampening and aggregate route control to reduce route churn.
- Change-controlled route-map promotion workflows.
- Regular read-only validation through the automation control plane.

These patterns show that the BGP implementation is not just functional. It is designed in a way that can be hardened for enterprise operations.

## Engineering significance

BGP Multi-Cloud Transit demonstrates five routing-engineering decisions:

1. Route exchange is dynamic and policy-controlled, not manually maintained by scattered static routes.
2. APIPA-style BGP peer addressing isolates the Azure-to-VyOS control plane from workload address space.
3. AWS branch routing uses Cisco CSR route-map filtering to permit trusted prefixes and withhold DMZ routes.
4. Transitive HQ-to-Azure-to-AWS reachability is validated through the Azure hub inspection stack.
5. BGP route learning, UDR inspection steering, and firewall policy are treated as separate but coordinated control planes.

This page proves the routing control plane behind the multi-cloud network.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| VyOS to Azure VPN Gateway BGP peering runs over IPSec | [`docs/release2/evidence/P5-vpn/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5-vpn) | VPN tunnel status, BGP peer state, APIPA-style peer addressing, and exchanged routes |
| On-premises subnet `10.0.0.0/24` is advertised toward Azure | [`docs/release2/evidence/P5-vpn/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5-vpn) | VyOS/Azure BGP advertisement evidence |
| AWS branch route-control model uses Transit Gateway and Cisco CSR 8000V | [`docs/release2/evidence/O3b/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3b) and [`terraform/aws-branch/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/aws-branch/dev) | TGW evidence, Cisco CSR configuration, and branch route propagation |
| Cisco CSR applies route-map filtering | [`docs/release2/evidence/O3b/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3b) | Route-map configuration, trusted prefix advertisement, DMZ prefix withholding |
| AWS branch prefix `172.16.0.0/16` participates in the branch route model | [`docs/release2/evidence/O3b/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3b) | AWS branch route tables and Cisco CSR BGP output |
| Transitive on-premises to AWS path is validated | [`docs/release2/evidence/O3c/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3c) | Ping, traceroute, symmetric return path, and inspection-path validation |
| FortiGate and Azure Firewall participate in the transit inspection path | [`docs/release2/evidence/O3c/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3c) and [`docs/release2/evidence/O1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O1) | Firewall logs, traffic-flow evidence, service-chain validation, and symmetric route proof |
| Multi-vendor BGP operates across VyOS, Azure, Cisco, and AWS transit constructs | P5-vpn, O3b, O3c evidence | Established peer state, route propagation, route-map behavior, and validation traffic |
| Enterprise hardening path is understood | This page | Active-active or zone-resilient gateway design, BGP authentication, route filters, BFD, dampening, and route-governance controls documented as production extensions |

## Review takeaway

BGP Multi-Cloud Transit shows that AzAWSLab has a real routing control plane behind the hybrid and multi-cloud fabric.

A reviewer can inspect VPN evidence, Cisco CSR route-map evidence, AWS branch evidence, O3c transitive path validation, and FortiGate/Azure Firewall inspection evidence to confirm that route exchange, route governance, and inspected transit were implemented together.
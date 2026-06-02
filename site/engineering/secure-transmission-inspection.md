# Secure Transmission & Inspection

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
    How AzAWSLab enforces encrypted transport, embeds third-party inspection, and extends private transmission boundaries. This page focuses on IPSec transport, BGP route exchange, Azure Firewall enforcement, FortiGate NVA service chaining, UDR steering, private service access where evidenced, and symmetric return-path validation.

## Architecture

```text
On-premises / remote site
        |
        | IPSec VPN with BGP route exchange
        v
Azure Hub VNet
  Azure VPN Gateway
  Azure Firewall
    centralized egress and east-west inspection
  FortiGate NVA
    UDR-driven service chaining
    dual-policy inspection
    deep hybrid trust path
        |
        | VNet peering and UDR steering
        v
Spoke Subnets
  Private endpoint patterns
    AVD/FSLogix evidence
    private platform paths where evidenced
  Internal service exposure
    no-public-exposure pattern where evidenced
```

Traffic for the validated hybrid, spoke, and multi-cloud paths is routed through controlled inspection points. The design avoids unmanaged public bypass paths for the evidenced platform services.

## Secure transmission model

Release 2 applies a layered approach to transmission security.

| Layer | Control | Evidence |
|---|---|---|
| Transport encryption | IPSec VPN tunnels with Azure VPN Gateway, connected tunnel status, and BGP route exchange | `docs/release2/evidence/P5-vpn/` |
| Network inspection | Azure Firewall for centralized enforcement and FortiGate NVA for UDR-driven service chaining | `docs/release2/evidence/O1/`, `terraform/platform-networking/dev/` |
| Private access | Private endpoint and no-public-exposure patterns where evidenced, especially AVD/FSLogix and private platform paths | `docs/release2/evidence/O5/` and related platform evidence |
| Path validation | Symmetric return routing through UDRs, traffic-flow logs, and effective route validation | `docs/release2/evidence/O1/`, `docs/release2/evidence/O3c/` |

## IPSec and BGP transport boundary

The platform's site-to-site and cross-cloud connectivity runs over IPSec VPN tunnels with dynamic routing.

- Azure VPN Gateway provides the central VPN termination point.
- VyOS and Cisco CSR participate in the hybrid and multi-cloud routing pattern.
- Connected tunnel state and BGP route exchange are captured in the evidence set.

The VPN evidence proves Azure VPN Gateway configuration, connected IPSec tunnel status, and BGP route exchange. In production, the same pattern should be governed with approved IKE/IPSec proposals, strong encryption suites, Perfect Forward Secrecy where required by policy, redundant tunnels, and documented key-rotation procedures.

## FortiGate NVA inspection path

The FortiGate NVA is integrated into the Azure hub as a third-party inspection layer. User-defined routes steer selected traffic through the NVA, and the evidence validates FortiGate policy state, routing state, service-chain traffic flow, and UDR next-hop behavior.

Validated signals include:

- FortiGate policy and routing table evidence.
- UDR next-hop steering toward the NVA.
- Dual-policy inspection model.
- Service-chain validation through traffic-flow logs.
- Symmetric path validation as part of the wider multi-cloud routing evidence.

This keeps the NVA story grounded in verifiable signals: routing, policy state, service chaining, and traffic-flow evidence.

## Azure Firewall and UDR steering

Azure Firewall acts as the central enforcement point for outbound and cross-spoke flows. User-defined routes on spoke subnets steer traffic through controlled hub paths.

The pattern provides:

- Centralized firewall enforcement for routed platform traffic.
- Route-table control through UDRs.
- Inspection boundaries between workload spokes, management paths, and hybrid/multi-cloud routes.
- A second inspection tier where selected routes are steered through FortiGate.

This combination gives the platform centralized Azure Firewall enforcement and targeted FortiGate deep inspection.

## Private endpoint and no-public-exposure patterns

Private endpoint and no-public-exposure patterns are used where the Release 2 evidence proves them, especially for AVD/FSLogix private endpoint readiness and private platform access paths. The AKS and AVD pages carry the service-specific controls in more detail.

For this Secure Transmission page, the important network pattern is that private service access is treated as a transmission boundary: name resolution, routing, and endpoint exposure are controlled so platform services are not reached through unmanaged public paths.

**Evidence:** O5 shows AVD/FSLogix private endpoint readiness. Related private platform pages cover service-specific private access and no-public-exposure evidence.

## Symmetric path validation

Asymmetric routing breaks stateful inspection. The platform validates symmetric return paths through:

- UDR steering.
- Effective route checks.
- Service-chain traffic-flow logs.
- Multi-cloud return-path validation.

This validation is documented alongside the O1 FortiGate service-chain evidence and the O3c multi-cloud transitive path evidence.

## Enterprise hardening pattern

In stricter environments, the same transmission security model can be hardened further.

| Area | Enterprise hardening pattern |
|---|---|
| VPN transport | Approved IKE/IPSec proposals, PFS where required, redundant tunnels, documented key rotation, and change-controlled tunnel policy. |
| Firewall enforcement | Centralized rule lifecycle, logging, Sentinel analytics, and least-privilege egress. |
| NVA inspection | HA design where justified, health probes, route failover testing, policy promotion workflow, and packet capture governance. |
| Private endpoints | Azure Policy enforcement for private endpoints and denial of public network access where service support allows it. |
| Route control | UDR validation, effective route review, route-map governance, and regular no-bypass checks. |
| Operations | Read-only network validation, sanitized backups, approved change workflow, and rollback testing through the automation control plane. |

These patterns show that the transmission design is not a single demonstration. It is a platform security model that can be hardened further for production requirements.

## Engineering significance

Secure Transmission & Inspection demonstrates five network-security decisions:

1. Hybrid and multi-cloud transport uses IPSec and BGP route exchange rather than unmanaged public paths.
2. Azure Firewall provides centralized enforcement for routed platform traffic.
3. FortiGate NVA service chaining is validated through UDR steering, policy state, routing state, and traffic-flow logs.
4. Private endpoint and no-public-exposure patterns are treated as transmission boundaries where evidenced.
5. Symmetric return path validation is explicitly addressed, reducing a common failure point in NVA deployments.

This page complements the broader Multi-Cloud Networking page by focusing on the security controls that make the routed fabric safe to operate.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| IPSec VPN tunnels are connected and BGP routes are exchanged | [`docs/release2/evidence/P5-vpn/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5-vpn) | VPN Gateway connection status and BGP route exchange |
| FortiGate NVA policy and routing state is captured | [`docs/release2/evidence/O1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O1) | FortiGate policy table, routing table, UDR next-hop, and service-chain validation |
| UDR steering forces traffic through controlled inspection paths | [`terraform/platform-networking/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-networking/dev) | Route tables, next-hop configuration, and inspection path definitions |
| Azure Firewall provides centralized enforcement | [`docs/release2/evidence/O1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O1) and network evidence | Firewall path validation, rule evidence, and traffic-flow logs where captured |
| Private endpoint pattern is evidenced for AVD/FSLogix | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5) | FSLogix private endpoint readiness and no-public-exposure evidence |
| Symmetric return path is validated | [`docs/release2/evidence/O3c/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3c) and [`docs/release2/evidence/O1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O1) | Bidirectional path validation, effective routes, and service-chain traffic-flow evidence |
| Enterprise hardening path is understood | This page | VPN proposal governance, private endpoint policy, NVA HA options, route validation, and operational backup/change controls documented as production hardening patterns |

## Review takeaway

Secure Transmission & Inspection shows that AzAWSLab treats network security as a routed, inspected, and validated control plane.

A reviewer can inspect VPN evidence, FortiGate service-chain evidence, Terraform route definitions, O5 private endpoint evidence, and O3c return-path validation to confirm that secure transmission is implemented as part of the platform architecture.
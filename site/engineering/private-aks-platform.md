# Private AKS Platform

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
    <span class="portfolio-chip-value">Network</span>
  </a>
  <a class="portfolio-chip" href="/engineering/private-aks-platform/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value portfolio-chip-value-active">Platform</span>
  </a>
  <a class="portfolio-chip" href="/engineering/automation-control-plane/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Operations</span>
  </a>
</div>

!!! summary "Scope"
    Private platform services notes and evidence paths for the private Azure Kubernetes Service platform in Release 2. It covers private API access, Azure CNI integration, firewall-forced egress, internal workload accessibility, managed Prometheus and Grafana monitoring, Kubernetes network policy controls where evidenced, and AWX readiness for governed operations.

## Platform role

Private AKS is the private Kubernetes workload runtime for Release 2.

It is not presented as a public demo cluster. It sits in the platform services layer, connected to the same hub routing, firewall enforcement, management path, and automation model used by the rest of the environment.

The implementation validates five platform engineering concerns:

- The Kubernetes control plane is kept off unmanaged public access paths.
- Workload networking is integrated into the Azure VNet model.
- Pod and workload egress is forced through Azure Firewall.
- Cluster health is visible through managed monitoring.
- The private platform is prepared for governed operational execution through AWX readiness.

## Architecture

```text
+--------------------------------------------------+
|                AKS Spoke (private)               |
|                                                  |
|   +-------------------+                          |
|   |   Private AKS     |                          |
|   |   API access      |                          |
|   |   pattern         |                          |
|   +--------+----------+                          |
|            |                                     |
|   +--------v----------+                          |
|   |   Node pools      |                          |
|   |   Azure CNI       |                          |
|   +--------+----------+                          |
|            |                                     |
|   +--------v----------+                          |
|   | Internal workload |                          |
|   | accessibility     |                          |
|   +-------------------+                          |
|                                                  |
|   ACR private access pattern where evidenced     |
|   Managed Prometheus / Grafana                   |
|   AWX readiness                                  |
+--------------------+-----------------------------+
                     |
                     | UDR egress path
                     v
              Hub Azure Firewall
```

The cluster is operated through private platform paths. Egress routes through the hub firewall rather than uncontrolled direct internet access.

## Design decisions

| Decision | Rationale | Evidence |
|---|---|---|
| Private AKS API access pattern | Keeps Kubernetes administration inside the private platform path instead of exposing the control plane as a public administration surface. | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4), [`terraform/platform-aks/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-aks/dev) |
| Azure CNI integration | Connects cluster networking to the VNet model so workload traffic follows Azure routing and firewall controls. | O4 AKS evidence and Terraform platform AKS root |
| Firewall-forced egress | Forces pod and workload outbound traffic through Azure Firewall so egress is controlled and observable. | O4 firewall-level and pod-level egress validation |
| Internal workload accessibility | Validates that workloads are reachable through private platform paths rather than unmanaged public exposure. | O4 internal application accessibility evidence |
| Managed Prometheus and Grafana | Provides managed cluster visibility without introducing a separate self-managed monitoring stack. | O4 managed monitoring and dashboard evidence |
| Kubernetes network policy controls | Restricts workload communication where evidenced by policy manifests and validation output without naming a specific network policy plugin unless the evidence supports it. | O4 evidence and Kubernetes policy manifests where present |
| AWX readiness | Confirms the cluster is prepared for integration with the governed Release 2 automation control plane. | O4 AWX readiness evidence and A2 AWX control-plane evidence |

## Private API access

The AKS API access pattern is private by design. Administrative activity originates from controlled platform paths such as the management environment, governed operator workspace, or automation control plane.

Private AKS is not just a cluster setting. It changes the operating model. Engineers and automation jobs enter through approved network and identity paths before they interact with the platform.

The O4 evidence validates the private platform path and cluster access model, while the Release 2 private platform document explains how this fits into the wider secure workspace architecture.

## Networking and forced egress

Azure CNI integrates AKS with the VNet addressing model. The AKS subnet is governed by user-defined routes so workload egress is forced through Azure Firewall.

The implementation signal is not only that the cluster exists. The evidence shows workload egress following the inspected path rather than bypassing the hub.

The network controls include:

- VNet-integrated cluster networking.
- Route-table control for workload egress.
- Firewall-level validation.
- Pod-level egress validation.
- Internal workload reachability through private platform paths.

## Kubernetes network policy controls

Network policy is treated as a workload-level control in addition to subnet routing and firewall enforcement.

The page intentionally uses the term **Kubernetes network policy controls** rather than naming a specific plugin. This keeps the claim aligned to evidence: the security design restricts pod and workload communication, while the exact plugin name is only stated where a manifest, screenshot, or log validates it.

Where policy manifests or validation output are present, reviewers should check:

- `NetworkPolicy` objects or equivalent policy definitions.
- Allowed and denied workload flows.
- Evidence that workload communication follows the expected policy boundary.
- Interaction between workload policy and Azure Firewall egress control.

## Monitoring and observability

Managed Prometheus and Grafana provide the monitoring layer for the private AKS platform.

A private cluster still needs operational visibility. Restricting public access should not reduce observability. The O4 evidence shows managed monitoring signals and dashboard visibility for platform review.

The monitoring model supports:

- Node and pod health visibility.
- Metrics collection through managed services.
- Dashboard-level review of cluster state.
- Platform health reporting evidence.

## Internal workload accessibility

O4 validates AKS internal workloads reachable through the private platform model.

Private AKS must still support internal workloads. The design does not isolate the cluster so completely that it cannot serve internal applications. Internal workloads remain reachable through governed network paths while public exposure stays controlled.

The internal application evidence should be reviewed alongside the network pages:

- Hybrid & Multi-Cloud Networking for the overall routed fabric.
- Secure Transmission & Inspection for firewall, NVA, and private transmission boundaries.
- Private AKS & AVD for the operator-workspace pattern.

## AWX readiness

O4 includes AWX readiness and tier-execution evidence for AKS operations. This confirms that the private AKS platform connects to the Release 2 automation model.

The architecture relationship is straightforward:

```text
Private AKS
    -> private workload runtime

AWX
    -> governed operational execution

Management path
    -> controlled network route between automation and private platform
```

The detailed AWX control-plane implementation is documented separately in the Automation Control Plane page. This page keeps the AKS focus: private API access, observability, inspected routing, and governed operations readiness.

## Enterprise production hardening pattern

The Release 2 implementation validates the private AKS operating model in a cost-controlled lab. In production, the same pattern can follow a stricter hardening path.

| Area | Enterprise hardening pattern |
|---|---|
| API access | Private DNS integration, approved admin groups, privileged access controls, and access reviews. |
| Identity | Workload identity, least-privilege Kubernetes RBAC, and separation between human and automation identities. |
| Network policy | Kubernetes network policies, ingress restrictions, egress policy, and namespace-level segmentation. |
| Registry access | Private registry integration, image scanning, signed images, and policy enforcement. |
| Monitoring | Managed Prometheus, Grafana, alert rules, workload health dashboards, and log retention. |
| Egress | Azure Firewall policy lifecycle, UDR validation, no-bypass checks, and Sentinel analytics for suspicious egress. |
| Operations | AWX job evidence, controlled runbooks, backup patterns for manifests and stateful workloads, and rollback procedures. |

This hardening pattern shows that the lab implementation has a production extension path. It can be extended into a stricter enterprise Kubernetes platform.

## Engineering significance

Private AKS Platform shows five platform engineering decisions:

1. Kubernetes administration is kept behind private platform paths.
2. Azure CNI integrates workloads into the routed Azure network model.
3. Workload egress is forced through Azure Firewall for controlled inspection.
4. Managed Prometheus and Grafana provide operational visibility.
5. AWX readiness connects the private runtime to the governed automation model.

This page shows that Release 2 includes a private Kubernetes runtime with network, monitoring, and operations controls.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Private AKS platform is implemented | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4), [`terraform/platform-aks/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-aks/dev) | Private AKS access pattern, cluster configuration, and platform root implementation |
| Azure CNI is used for AKS networking | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4) | CNI configuration and VNet-integrated workload networking evidence |
| AKS egress is forced through Azure Firewall | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4), [`terraform/platform-networking/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-networking/dev) | Firewall-level and pod-level egress validation, UDR path, and firewall evidence |
| Internal workload accessibility is validated | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4) | Internal application access evidence and private platform reachability |
| Managed Prometheus and Grafana are configured | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4) | Managed monitoring configuration, dashboards, and cluster health evidence |
| Kubernetes network policy controls are documented where evidenced | O4 evidence and Kubernetes policy manifests where present | NetworkPolicy objects, allowed flows, and validation output |
| AWX readiness supports governed AKS operations | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4), [`docs/release2/evidence/A2-awx-control-plane/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane) | AWX readiness, tier-execution evidence, and automation control-plane integration |
| Enterprise hardening path is documented | This page | API access control, workload identity, network policy, registry security, monitoring, egress governance, and runbook patterns documented as production hardening options |

## Review takeaway

Private AKS Platform shows that Release 2 includes a private Kubernetes runtime with governed networking, observability, and automation readiness.

A reviewer can inspect O4 evidence, Terraform AKS code, firewall egress validation, monitoring evidence, and AWX readiness to confirm AKS as part of the platform operating model rather than a standalone demo cluster.

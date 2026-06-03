# Private AKS & AVD

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
    Private platform integration notes and evidence paths for the paired Release 2 pattern: private AKS as the workload runtime and Azure Virtual Desktop as the governed operator workspace. It covers private access, firewall-controlled egress, managed monitoring, FSLogix private profile storage, AVD toolchain readiness, and the operational relationship between AKS, AVD, hub routing, and AWX.

## Platform pattern

Release 2 pairs two private platform services:

- **Private AKS** provides the private workload runtime.
- **Azure Virtual Desktop** provides the governed operator workspace.
- **Hub routing and Azure Firewall** provide the controlled network path.
- **AWX readiness** connects the private platform to the operations control plane.

The design signal is that the platform is not administered from unmanaged laptops on the public internet. Operations follow private network paths, governed identity, and controlled platform tooling.

```text
Engineer
   |
   | Entra ID and Conditional Access access path
   v
Azure Virtual Desktop workspace
   - governed operator desktop
   - platform toolchain
   - FSLogix profile storage
   - no public session-host exposure
   |
   | private routing through hub
   v
Azure Hub
   - Azure Firewall
   - route control
   - inspection boundary
   |
   v
Private AKS
   - private API access pattern
   - Azure CNI
   - firewall-forced egress
   - managed monitoring
   |
   v
AWX readiness and operations integration
```

## Design decisions

| Decision | Rationale | Evidence |
|---|---|---|
| Private AKS API access pattern | Keeps the Kubernetes control plane off the public internet and routes administration through private platform paths. | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4), [`terraform/platform-aks/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-aks/dev) |
| Azure CNI and firewall-forced egress | Gives pods routable VNet integration and keeps outbound traffic under Azure Firewall control. | O4 firewall-level and pod-level egress validation |
| Managed Prometheus and Grafana | Provides managed cluster observability without building a separate self-managed monitoring stack. | O4 managed monitoring dashboard evidence |
| AWX readiness for AKS operations | Confirms the automation control plane can integrate with the private platform services layer. | O4 AWX readiness and tier-execution evidence |
| AVD secure workspace | Provides a governed operator workspace with no public IP session-host exposure. | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5), [`terraform/platform-avd/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-avd/dev) |
| FSLogix on Azure Files private endpoint | Preserves operator profile state while keeping profile storage aligned to private access paths. | O5 FSLogix private endpoint readiness |
| Entra ID and Conditional Access access path | Controls user access into the secure workspace using Entra ID and Conditional Access policy. | Release 2 private platform document and Release 1 identity/endpoint evidence |
| Region governance and preflight checks | Validates AVD region, provider, SKU, and network readiness before deployment. | O5 paired-region and preflight evidence |

## Private AKS platform role

Private AKS is the private Kubernetes workload runtime for Release 2. It is deployed as part of the platform services layer, not as a public demo cluster.

The platform evidence focuses on these implementation signals:

- Private AKS access pattern.
- Azure CNI integration.
- Firewall-forced pod egress.
- Internal workload reachability.
- Managed monitoring through Prometheus and Grafana.
- AWX readiness for operational integration.

A private Kubernetes platform needs more than a cluster deployment. It needs private administration paths, controlled egress, observability, and a governed automation path.

## AVD secure workspace role

Azure Virtual Desktop is the governed operator workspace for Release 2. It provides a controlled desktop environment for platform engineers to operate private resources without exposing those resources directly to unmanaged endpoints.

The workspace evidence focuses on these implementation signals:

- No public IP exposure for session hosts.
- FSLogix profile storage on Azure Files with private endpoint readiness.
- Platform toolchain readiness.
- Entra ID and Conditional Access gated access path.
- Region, SKU, provider, and network preflight validation.

This pattern gives reviewers a realistic enterprise access model: operators enter through a controlled workspace, then reach private platform services through inspected network paths.

## Integration: AVD as the private AKS operations console

The O4 and O5 designs are paired.

Private AKS keeps the workload control plane off the public internet. AVD provides the governed operator workspace used to reach that private platform path. The AVD host is pre-staged with the platform toolchain, including Azure CLI, Terraform, Git, VS Code, kubectl, and Helm, so platform operations run from inside the controlled environment rather than unmanaged local workstations.

The validated integration pattern is:

1. Engineer authenticates through the AVD access path.
2. The AVD session provides a governed desktop with the required platform toolchain.
3. Private network routing allows platform operations toward AKS and supporting services.
4. AKS egress remains forced through Azure Firewall.
5. AWX readiness confirms the automation control plane can operate against the private platform.

This validates a practical enterprise pattern: private workload runtime plus governed administrative workspace, connected through inspected network paths.

## Network and security boundary

The private platform pattern depends on the Release 2 Network Engineering design.

| Boundary | Control |
|---|---|
| AKS control plane | Private access pattern; administration from private platform paths. |
| AKS workload egress | Forced through Azure Firewall for inspection and routing control. |
| AVD operator access | Entra ID and Conditional Access gated access path. |
| AVD profile storage | FSLogix on Azure Files with private endpoint readiness. |
| Cross-service operations | Routed through hub networking rather than unmanaged public endpoints. |
| Automation integration | AWX readiness confirms operations can be controlled through a governed execution plane. |

AKS and AVD belong together in the platform services layer. One provides the private runtime; the other provides the controlled human operations plane.

## Enterprise production hardening pattern

The Release 2 implementation validates the architecture pattern in a cost-controlled lab. In production, the same design can follow a stricter hardening path.

| Area | Enterprise hardening pattern |
|---|---|
| AKS administration | Private DNS integration, bastion or private jump path, workload identity, approved admin groups, and privileged access controls. |
| AKS workload policy | Network policy, Azure Policy for Kubernetes, image policy, private registry, and controlled ingress/egress. |
| AVD access | Conditional Access, MFA, compliant device requirements, privileged access separation, and session monitoring. |
| FSLogix storage | Private endpoint, backup, soft delete, file share permissions, and storage firewall restrictions. |
| Hub inspection | Azure Firewall rules, UDR validation, log analytics, and optional NVA inspection where justified. |
| Operations | AWX job evidence, controlled runbooks, backup validation, and rollback procedures. |

This page focuses on the implemented Release 2 evidence while showing how the same model maps to a stricter enterprise operating standard.

## Architectural significance

Private AKS and AVD shows five platform engineering decisions:

1. Workload runtime and operator workspace are private by design.
2. Platform access is routed through governed identity and network paths instead of unmanaged public endpoints.
3. AKS egress is forced through Azure Firewall, keeping private workload traffic under routing and inspection control.
4. AVD provides the secure operational entry point, with FSLogix private profile storage and platform toolchain readiness.
5. AWX readiness connects the private platform to the governed automation control plane.

This page shows that Release 2 is not only a network build. It is a private platform operating model.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Private AKS platform is implemented | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4), [`terraform/platform-aks/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-aks/dev) | Private AKS access pattern, Azure CNI, firewall-forced egress, managed monitoring, and AWX readiness evidence |
| AVD secure workspace is implemented | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5), [`terraform/platform-avd/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-avd/dev) | AVD workspace, no-public-IP posture, FSLogix readiness, private endpoint readiness, toolchain readiness, and preflight evidence |
| Private platform and secure workspace are implemented as a paired pattern | [Private Platform and Secure Workspace release document](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/04-private-platform-secure-workspace.md) | O4/O5 design relationship, private operations path, and secure operator workspace narrative |
| AKS egress is controlled through firewall routing | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4) | Firewall-level and pod-level egress validation |
| AVD supports governed operator access | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5) | Toolchain readiness, FSLogix readiness, private endpoint readiness, and access governance evidence |
| AWX can integrate with the private platform | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4), [`docs/release2/evidence/A2-awx-control-plane/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane) | AWX readiness and governed automation control-plane evidence |
| Enterprise hardening path is documented | This page | Private DNS, policy, registry, Conditional Access, FSLogix protection, firewall logging, AWX runbooks, backup, and rollback patterns documented as production hardening options |

## Review takeaway

Private AKS and AVD shows that Release 2 has a private platform operating model.

A reviewer can inspect O4 evidence, O5 evidence, Terraform roots, and the private platform release document to confirm AKS and AVD as one paired pattern: private workload runtime, governed operator workspace, inspected network path, and automation-ready operations.

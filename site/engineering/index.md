# Engineering Deep Dive

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value portfolio-chip-value-active">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/proof-gallery/">
    <span class="portfolio-chip-label">Proof</span>
    <span class="portfolio-chip-value">Gallery</span>
  </a>
  <a class="portfolio-chip" href="/skills-matrix/">
    <span class="portfolio-chip-label">Skills</span>
    <span class="portfolio-chip-value">Matrix</span>
  </a>
</div>

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="#release-1-hybrid-workplace">
    <span class="portfolio-chip-label">R1</span>
    <span class="portfolio-chip-value">Workplace</span>
  </a>
  <a class="portfolio-chip" href="#release-2-delivery-engineering">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Delivery</span>
  </a>
  <a class="portfolio-chip" href="#release-2-network-engineering">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Network</span>
  </a>
  <a class="portfolio-chip" href="#release-2-platform-services">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Platform</span>
  </a>
  <a class="portfolio-chip" href="#release-2-operations-engineering">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Operations</span>
  </a>
</div>

!!! summary "Scope"
    Engineering notes for AzAWSLab implementation decisions, control-plane boundaries, configuration patterns, and evidence routes. Each note connects architecture claims to public-safe source files, screenshots, CLI output, workflow records, manifests, or evidence folders in the repository.

## Engineering map

The engineering material is grouped by platform lifecycle domain. Hybrid workplace, delivery, network, platform services, operations, and AI governance each carry their own control boundaries and evidence routes.

| Lifecycle domain | Scope | Engineering notes |
|---|---|---|
| Release 1 Hybrid Workplace | Identity, Exchange Hybrid, Microsoft 365 operations, endpoint security, Microsoft Graph PowerShell, monitoring, and operational visibility. | [Hybrid Identity Engineering](hybrid-identity.md)<br>[Exchange Hybrid and M365 Services](exchange-hybrid-m365-services.md)<br>[Modern Endpoint Management](modern-endpoint-management.md)<br>[Graph and PowerShell Operations](graph-powershell-operations.md)<br>[Monitoring and Operational Visibility](release1-monitoring-operational-visibility.md) |
| Release 2 Delivery Engineering | Terraform state boundaries, GitHub Actions OIDC, controlled apply, and traceability from claim to source to evidence. | [Terraform State Boundaries](terraform-state-boundaries.md)<br>[GitHub Actions OIDC](github-actions-oidc.md)<br>[Code Traceability](code-traceability.md) |
| Release 2 Network Engineering | Hub-spoke routing, Azure Firewall, FortiGate inspection, IPSec, BGP, AWS branch routing, and symmetric path validation. | [Hybrid Multi-Cloud Networking](hybrid-multicloud-networking.md)<br>[Secure Transmission and Inspection](secure-transmission-inspection.md)<br>[Hybrid BGP Multi-Cloud Transit](hybrid-bgp-multicloud-transit.md) |
| Release 2 Platform Services | Private AKS, AVD secure workspace, FSLogix, private access patterns, inspected integration, and governed operator access. | [Private AKS Platform](private-aks-platform.md)<br>[AVD Secure Workspace](avd-secure-workspace.md)<br>[Private AKS and AVD Architecture](private-aks-avd.md) |
| Release 2 Operations Engineering | AWX automation, Ansible source control, monitoring, alert validation, backup protection, and resilience evidence. | [Automation Control Plane](automation-control-plane.md)<br>[Monitoring, Backup and Resilience](monitoring-backup-resilience.md) |
| AI Governance | Policy-mediated tool use, human approval boundaries, decision evidence, and local AI lab context. | [AI Operations Enclave](/ai-operations/)<br>[Companion Local AI Lab](/companion-project/) |

## Release 1 Hybrid Workplace

Release 1 establishes the realistic Microsoft hybrid enterprise environment used by the rest of the platform.

Use these notes to review identity synchronisation, Conditional Access, Microsoft 365 operations, endpoint management, Microsoft Graph PowerShell, and operational visibility.

- [Hybrid Identity Engineering](hybrid-identity.md)
- [Exchange Hybrid and M365 Services](exchange-hybrid-m365-services.md)
- [Modern Endpoint Management](modern-endpoint-management.md)
- [Graph and PowerShell Operations](graph-powershell-operations.md)
- [Monitoring and Operational Visibility](release1-monitoring-operational-visibility.md)

## Release 2 Delivery Engineering

Delivery Engineering covers how infrastructure changes are planned, reviewed, applied, and traced.

Use these notes to review Terraform state boundaries, GitHub Actions OIDC, root-scoped delivery, and claim-to-evidence traceability.

- [Terraform State Boundaries](terraform-state-boundaries.md)
- [GitHub Actions OIDC](github-actions-oidc.md)
- [Code Traceability](code-traceability.md)

## Release 2 Network Engineering

Network Engineering covers the routed and inspected fabric behind the platform.

Use these notes to review hub-spoke routing, FortiGate service chaining, Azure Firewall enforcement, IPSec/BGP, AWS branch transit, and symmetric return-path validation.

- [Hybrid Multi-Cloud Networking](hybrid-multicloud-networking.md)
- [Secure Transmission and Inspection](secure-transmission-inspection.md)
- [Hybrid BGP Multi-Cloud Transit](hybrid-bgp-multicloud-transit.md)

## Release 2 Platform Services

Platform Services covers the private compute and governed operator access layer.

Use these notes to review private AKS, AVD secure workspace, FSLogix profile handling, private access patterns, and the paired AKS/AVD operating model.

- [Private AKS Platform](private-aks-platform.md)
- [AVD Secure Workspace](avd-secure-workspace.md)
- [Private AKS and AVD Architecture](private-aks-avd.md)

## Release 2 Operations Engineering

Operations Engineering covers the control planes used to operate, monitor, validate, back up, and recover the platform.

Use these notes to review AWX automation, Ansible source control, runtime secret handling, Sentinel, Defender for Cloud, Azure Monitor alerts, Recovery Services Vault controls, and BCDR evidence.

- [Automation Control Plane](automation-control-plane.md)
- [Monitoring, Backup and Resilience](monitoring-backup-resilience.md)

## Review paths

| Reviewer focus | Start here |
|---|---|
| Hybrid workplace, identity, endpoint security, and Microsoft 365 operations | [Hybrid Identity Engineering](hybrid-identity.md), [Exchange Hybrid and M365 Services](exchange-hybrid-m365-services.md), [Modern Endpoint Management](modern-endpoint-management.md), [Graph and PowerShell Operations](graph-powershell-operations.md), [Monitoring and Operational Visibility](release1-monitoring-operational-visibility.md) |
| Terraform, CI/CD, and delivery governance | [Terraform State Boundaries](terraform-state-boundaries.md), [GitHub Actions OIDC](github-actions-oidc.md), [Code Traceability](code-traceability.md) |
| FortiGate, Azure Firewall, IPSec, BGP, and AWS branch routing | [Hybrid Multi-Cloud Networking](hybrid-multicloud-networking.md), [Secure Transmission and Inspection](secure-transmission-inspection.md), [Hybrid BGP Multi-Cloud Transit](hybrid-bgp-multicloud-transit.md) |
| Private platform services | [Private AKS Platform](private-aks-platform.md), [AVD Secure Workspace](avd-secure-workspace.md), [Private AKS and AVD Architecture](private-aks-avd.md) |
| Operations, automation, monitoring, backup, and recovery | [Automation Control Plane](automation-control-plane.md), [Monitoring, Backup and Resilience](monitoring-backup-resilience.md) |
| AI governance and policy-mediated tool use | [AI Operations Enclave](/ai-operations/), [Companion Local AI Lab](/companion-project/) |

## Evidence standard

Each engineering note should include an evidence table with three fields:

| Field | Purpose |
|---|---|
| Claim | The implementation or design decision being routed to evidence. |
| Evidence path | The repository file, folder, screenshot set, workflow, manifest, or evidence directory that supports the claim. |
| What to verify | The specific signal reviewers should inspect. |

Evidence should point to stable, public-safe locations such as:

- `docs/release1/` for Release 1 implementation notes.
- `screenshots/release1/` for Microsoft 365, identity, endpoint, Purview, monitoring, and recovery evidence.
- `terraform/` for infrastructure source and root boundaries.
- `.github/workflows/` for workflow-controlled delivery.
- `ansible/` for Ansible playbooks, inventories, and AWX integration material.
- `kubernetes/` for Kubernetes manifests and platform support objects.
- `docs/release2/evidence/` for Release 2 validation output, workflow records, routing evidence, AWX evidence, AKS evidence, AVD evidence, backup evidence, and O6 evidence.

## Review standard

These notes are written as engineering records. They explain what was built, why the design was chosen, how the control boundary works, and where the evidence route starts.

The strongest signal is traceability: architecture decision, implementation source, validation evidence, and reviewer evidence route.

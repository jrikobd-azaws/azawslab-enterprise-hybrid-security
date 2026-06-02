# Engineering Deep Dive

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value portfolio-chip-value-active">Deep Dive</span>
  </a>
</div>

!!! summary "Scope"
    Engineering notes for the implementation decisions, control-plane boundaries, configuration patterns, and evidence paths behind AzAWSLab. Each note maps architecture claims to public-safe source files, screenshots, CLI output, workflow records, manifests, or evidence folders in the repository.

## Engineering map

The engineering material is grouped by platform lifecycle domain rather than by security as a separate bucket. Identity, delivery, network, platform services, and operations each carry their own security controls and evidence.

| Lifecycle domain | Engineering notes |
|---|---|
| Release 1 Hybrid Workplace | Hybrid Identity Engineering<br>Modern Endpoint Management<br>Graph and PowerShell Operations |
| Release 2 Delivery Engineering | [Terraform State Boundaries](terraform-state-boundaries.md)<br>[GitHub Actions OIDC](github-actions-oidc.md)<br>[Code Traceability](code-traceability.md) |
| Release 2 Network Engineering | [Hybrid Multi-Cloud Networking](hybrid-multicloud-networking.md)<br>[Secure Transmission and Inspection](secure-transmission-inspection.md)<br>[Hybrid BGP Multi-Cloud Transit](hybrid-bgp-multicloud-transit.md) |
| Release 2 Platform Services | [Private AKS Platform](private-aks-platform.md)<br>[AVD Secure Workspace](avd-secure-workspace.md)<br>[Private AKS and AVD Architecture](private-aks-avd.md) |
| Release 2 Operations Engineering | [Automation Control Plane](automation-control-plane.md)<br>Monitoring, Backup and Resilience |

## Review paths

| Reviewer focus | Start here |
|---|---|
| Hybrid identity and Microsoft workplace operations | Hybrid Identity Engineering, Modern Endpoint Management, Graph and PowerShell Operations |
| Terraform, CI/CD, and delivery governance | Terraform State Boundaries, GitHub Actions OIDC, Code Traceability |
| FortiGate, Azure Firewall, IPSec, BGP, and AWS branch routing | Hybrid Multi-Cloud Networking, Secure Transmission and Inspection, Hybrid BGP Multi-Cloud Transit |
| Private platform delivery | Private AKS Platform, AVD Secure Workspace, Private AKS and AVD Architecture |
| Day-2 operations, automation, monitoring, backup, and recovery | Automation Control Plane, Monitoring, Backup and Resilience |

## Evidence standard

Each engineering note should include an evidence table with three fields:

| Field | Purpose |
|---|---|
| Claim | The implementation or design decision being asserted. |
| Evidence path | The repository file, folder, screenshot set, workflow, manifest, or evidence directory that supports the claim. |
| What to verify | The specific signal a reviewer should inspect. |

Evidence should point to stable public-safe locations such as:

- `docs/release1/` for Release 1 implementation narratives.
- `screenshots/release1/` for Microsoft 365, identity, endpoint, Purview, monitoring, and recovery evidence.
- `terraform/` for infrastructure source and root boundaries.
- `.github/workflows/` for workflow-controlled delivery.
- `ansible/` for Ansible playbooks, inventories, and AWX integration material.
- `kubernetes/` for Kubernetes manifests and platform support objects.
- `docs/release2/evidence/` for Release 2 validation output, workflow evidence, routing proof, AWX evidence, AKS evidence, AVD evidence, backup evidence, and O6 evidence.

## Engineering tone

These notes are written as technical engineering records. They explain what was built, why the design was chosen, how the control boundary works, and where the evidence lives.

They should avoid marketing language, unsupported adjectives, and vague claims. The strongest signal is traceability: architecture decision, implementation source, validation artifact, and reviewer takeaway.

## Notes being added in this Engineering refresh

The following notes are intentionally listed without links until their pages are created and validated in this refresh sequence:

- Hybrid Identity Engineering
- Modern Endpoint Management
- Graph and PowerShell Operations
- Monitoring, Backup and Resilience
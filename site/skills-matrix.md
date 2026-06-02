# Skills Matrix

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/portfolio-case-study/">
    <span class="portfolio-chip-label">Journey</span>
    <span class="portfolio-chip-value portfolio-chip-value-ready">Public Ready</span>
  </a>
  <a class="portfolio-chip" href="/releases/release1/">
    <span class="portfolio-chip-label">R1</span>
    <span class="portfolio-chip-value">Workplace + M365</span>
  </a>
  <a class="portfolio-chip" href="/releases/release2/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Platform + Multi-Cloud</span>
  </a>
  <a class="portfolio-chip" href="/releases/release3/">
    <span class="portfolio-chip-label">R3</span>
    <span class="portfolio-chip-value portfolio-chip-value-muted">Roadmap</span>
  </a>
</div>

!!! summary "Capability-to-evidence map"
    This matrix maps AzAWSLab capabilities to engineering notes, evidence routes, and public-safe evidence indexes. It helps reviewers move from capability area to implementation detail without searching the repository manually.

## How to read this matrix

| Column | Purpose |
|---|---|
| Skill | The capability demonstrated in the platform. |
| Evidence signal | The concrete implementation signal a reviewer should look for. |
| Engineering note | The technical page that explains the design and implementation. |
| Proof route | The proof dashboard or evidence index that links to repository evidence. |

---

## Release 1 Hybrid Workplace

| Skill | Evidence signal | Engineering note | Evidence route |
|---|---|---|---|
| Hybrid identity architecture | Active Directory, Entra ID, Entra Connect, pilot identity scope, Conditional Access, MFA, and identity operations. | [Hybrid Identity](engineering/hybrid-identity.md) | [Release 1 evidence](proof-gallery.md#release-1-hybrid-workplace) |
| Conditional Access and access control | MFA, policy result visibility, compliant-device context, sign-in review, and access enforcement signals. | [Hybrid Identity](engineering/hybrid-identity.md) | [Release 1 Evidence Index](evidence/release1-evidence-index.md) |
| Exchange Hybrid and Microsoft 365 operations | Exchange Hybrid, Microsoft 365 operations, collaboration service validation, and workplace administration. | [Exchange Hybrid and M365 Services](engineering/exchange-hybrid-m365-services.md) | [Release 1 evidence](proof-gallery.md#release-1-hybrid-workplace) |
| Modern endpoint management | Intune, Autopilot, compliance policy, BitLocker, Windows LAPS, Defender controls, and managed-device lifecycle signals. | [Modern Endpoint Management](engineering/modern-endpoint-management.md) | [Release 1 Evidence Index](evidence/release1-evidence-index.md) |
| Information protection and data governance | Microsoft Purview, sensitivity labels, DLP, retention, and user-visible policy behavior. | [Modern Endpoint Management](engineering/modern-endpoint-management.md) | [Release 1 evidence](proof-gallery.md#release-1-hybrid-workplace) |
| Microsoft Graph PowerShell operations | Scripted pilot user state, managed device state, Microsoft Graph connection and consent validation, and controlled administrative action. | [Graph and PowerShell Operations](engineering/graph-powershell-operations.md) | [Release 1 Evidence Index](evidence/release1-evidence-index.md) |
| Monitoring and operational visibility | Sign-in review, audit-log visibility, Conditional Access result review, device compliance checks, alert review, and Graph-connected checks. | [Monitoring and Operational Visibility](engineering/release1-monitoring-operational-visibility.md) | [Release 1 evidence](proof-gallery.md#release-1-hybrid-workplace) |
| Microsoft workplace recovery operations | BitLocker recovery, stale or duplicate device cleanup, trust-break handling, rebuild, and re-enrollment evidence. | [Modern Endpoint Management](engineering/modern-endpoint-management.md) | [Release 1 Evidence Index](evidence/release1-evidence-index.md) |

---

## Release 2 Delivery Engineering

| Skill | Evidence signal | Engineering note | Evidence route |
|---|---|---|---|
| Terraform state boundary design | Multiple Terraform roots separate platform networking, management, AKS, AVD, shared services, governance, workloads, and AWS branch responsibility boundaries. | [Terraform State Boundaries](engineering/terraform-state-boundaries.md) | [Delivery evidence](proof-gallery.md#release-2-delivery-engineering) |
| Remote state and ownership discipline | Root-specific state boundaries, controlled plan/apply behaviour, and blast-radius separation. | [Terraform State Boundaries](engineering/terraform-state-boundaries.md) | [Release 2 Evidence Index](evidence/release2-evidence-index.md) |
| GitHub Actions OIDC | Workflow-controlled Azure authentication without routine long-lived deployment credentials. | [GitHub Actions OIDC](engineering/github-actions-oidc.md) | [Delivery evidence](proof-gallery.md#release-2-delivery-engineering) |
| CI/CD delivery governance | Plan, review, apply, workflow evidence, and pipeline guardrails. | [GitHub Actions OIDC](engineering/github-actions-oidc.md) | [Release 2 Evidence Index](evidence/release2-evidence-index.md) |
| Code traceability | Documentation, source, workflow records, and repository evidence connected to reviewable platform claims. | [Code Traceability](engineering/code-traceability.md) | [Delivery evidence](proof-gallery.md#release-2-delivery-engineering) |

---

## Release 2 Network Engineering

| Skill | Evidence signal | Engineering note | Evidence route |
|---|---|---|---|
| Hybrid and multi-cloud network architecture | Azure hub-spoke networking, route control, VPN, IPSec, BGP, AWS branch integration, and route validation evidence. | [Hybrid Multi-Cloud Networking](engineering/hybrid-multicloud-networking.md) | [Network evidence](proof-gallery.md#release-2-network-engineering) |
| Azure Firewall and route control | Forced routing, route tables, hub inspection context, and network boundary evidence. | [Hybrid Multi-Cloud Networking](engineering/hybrid-multicloud-networking.md) | [Release 2 Evidence Index](evidence/release2-evidence-index.md) |
| Secure transmission and inspection | FortiGate NVA, Azure Firewall, inspection path, routing, and validation signals. | [Secure Transmission and Inspection](engineering/secure-transmission-inspection.md) | [Network evidence](proof-gallery.md#release-2-network-engineering) |
| Hybrid BGP multi-cloud transit | BGP, IPSec, AWS branch routing, cross-cloud route validation, and transit-path signals. | [Hybrid BGP Multi-Cloud Transit](engineering/hybrid-bgp-multicloud-transit.md) | [Release 2 Evidence Index](evidence/release2-evidence-index.md) |
| Multi-vendor routing and branch integration | Azure, AWS branch, route propagation, route filtering context, and validated reachability. | [Hybrid BGP Multi-Cloud Transit](engineering/hybrid-bgp-multicloud-transit.md) | [Network evidence](proof-gallery.md#release-2-network-engineering) |

---

## Release 2 Platform Services

| Skill | Evidence signal | Engineering note | Evidence route |
|---|---|---|---|
| Private AKS platform delivery | Private AKS pattern, controlled access, Kubernetes manifests, network policy context, and validation signals. | [Private AKS Platform](engineering/private-aks-platform.md) | [Platform evidence](proof-gallery.md#release-2-platform-services) |
| Kubernetes source and validation | Kubernetes manifests, support objects, and platform validation evidence. | [Private AKS Platform](engineering/private-aks-platform.md) | [Release 2 Evidence Index](evidence/release2-evidence-index.md) |
| AVD secure workspace | Azure Virtual Desktop, FSLogix, private access orientation, privileged access separation, and secure workspace governance. | [AVD Secure Workspace](engineering/avd-secure-workspace.md) | [Platform evidence](proof-gallery.md#release-2-platform-services) |
| Private platform integration | AKS and AVD architecture, internal access paths, route context, and inspected private platform communication. | [Private AKS and AVD Architecture](engineering/private-aks-avd.md) | [Platform evidence](proof-gallery.md#release-2-platform-services) |

---

## Release 2 Operations Engineering

| Skill | Evidence signal | Engineering note | Evidence route |
|---|---|---|---|
| Ansible and AWX automation control plane | Ansible source, AWX control-plane evidence, inventories, job templates, execution records, and governed runbooks. | [Automation Control Plane](engineering/automation-control-plane.md) | [Operations evidence](proof-gallery.md#release-2-operations-engineering) |
| Source-controlled operational automation | Playbooks, inventories, operational runbooks, and controlled execution model. | [Automation Control Plane](engineering/automation-control-plane.md) | [Release 2 Evidence Index](evidence/release2-evidence-index.md) |
| Azure Monitor and Sentinel operations | Azure Monitor evidence, Sentinel context, alert validation, and operational visibility. | [Monitoring, Backup and Resilience](engineering/monitoring-backup-resilience.md) | [Operations evidence](proof-gallery.md#release-2-operations-engineering) |
| Defender for Cloud operations | Defender for Cloud, recommendations, posture visibility, and security operations context. | [Monitoring, Backup and Resilience](engineering/monitoring-backup-resilience.md) | [Release 2 Evidence Index](evidence/release2-evidence-index.md) |
| Backup and disaster recovery | Recovery Services Vault, backup policies, BCDR planning, soft-delete handling, immutability, and validation signals. | [Monitoring, Backup and Resilience](engineering/monitoring-backup-resilience.md) | [Operations evidence](proof-gallery.md#release-2-operations-engineering) |
| Operational resilience validation | Monitoring, backup, recovery, deletion protection, and documented resilience checks. | [Monitoring, Backup and Resilience](engineering/monitoring-backup-resilience.md) | [Release 2 Evidence Index](evidence/release2-evidence-index.md) |

---

## AI Operations and Innovation

| Skill | Evidence signal | Engineering note | Evidence route |
|---|---|---|---|
| AI Operations Enclave governance | Policy-mediated tool use, evidence capture, Kubernetes support context, and human approval boundaries in the AI Operations Enclave, evidenced through O6. | [AI Operations Enclave](ai-operations/index.md) | [AI evidence](proof-gallery.md#ai-operations-and-innovation) |
| O6 evidence model | O6 evidence folder, policy boundaries, namespace lifecycle, cleanup validation, and operational governance context. | [AI Operations Enclave](ai-operations/index.md) | [Release 2 Evidence Index](evidence/release2-evidence-index.md) |
| Companion local AI lab | Local-first multi-agent infrastructure workflow, RAG, provider routing, validation hooks, tool permissions, and human review boundaries. | [Companion Project](companion-project.md) | [AI evidence](proof-gallery.md#ai-operations-and-innovation) |

---

## Platform Evolution

| Skill | Evidence signal | Engineering note | Evidence route |
|---|---|---|---|
| Multi-cloud Kubernetes roadmap | Release 3 roadmap for multi-cloud Kubernetes, GitOps, DevSecOps, observability, and resilience. | [Release 3 Roadmap](releases/release3.md) | [Release 3 roadmap evidence](proof-gallery.md#release-3-roadmap) |
| Roadmap discipline | Release 3 is presented as future direction, not completed implementation evidence. | [Release 3 Roadmap](releases/release3.md) | [Release 3 documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release3){ target="_blank" } |

---

## Reviewer usage

| Reviewer | How to use this matrix |
|---|---|
| Recruiter | Scan the Skill column to identify coverage across Microsoft 365, Azure, networking, automation, Kubernetes, AVD, resilience, and AI operations. |
| Hiring manager | Use the Evidence signal column to assess implemented capability rather than generic familiarity. |
| Technical reviewer | Follow the Engineering note and Evidence route columns to inspect implementation context and evidence routes. |
| Security architect | Trace identity, endpoint, network inspection, private access, backup, and AI governance across the release lifecycle. |
| DevOps / SRE reviewer | Start with Delivery Engineering, Operations Engineering, and AI Operations and Innovation. |

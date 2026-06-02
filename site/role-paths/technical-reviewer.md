# Technical Reviewer Pathway

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value portfolio-chip-value-ready">Deep Dive</span>
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

!!! summary "Purpose of this page"
    A technical evaluation guide for cloud architects, platform engineers, and senior reviewers. It maps AzAWSLab to the lifecycle domains used throughout Engineering Deep Dive, with links to implementation rationale, configuration evidence, and public repository proof.

## Review framework

The platform is built across six lifecycle domains. Each domain has dedicated engineering pages that document design decisions, implementation patterns, and evidence. This pathway gives reviewers a structured validation path without duplicating the detailed evidence maps already maintained in Engineering Deep Dive.

---

## 1. Hybrid Workplace - Identity, Messaging, Endpoint, and Operations

**What to validate:** Hybrid identity, Exchange Hybrid and Microsoft 365 services, modern endpoint management, operational scripting, and Release 1 monitoring discipline.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Entra Connect model, Conditional Access enforcement, MFA, and identity operations | [Hybrid Identity Engineering](/engineering/hybrid-identity/) | Release 1 identity screenshots and evidence index |
| Exchange Hybrid and Microsoft 365 service operations | [Exchange Hybrid and M365 Services](/engineering/exchange-hybrid-m365-services/) | Release 1 modern workplace and Exchange evidence |
| Autopilot, Intune compliance, BitLocker, Windows LAPS, Defender, and Purview | [Modern Endpoint Management](/engineering/modern-endpoint-management/) | Release 1 endpoint and information-protection evidence |
| Microsoft Graph and PowerShell operations | [Graph and PowerShell Operations](/engineering/graph-powershell-operations/) | Release 1 scripts, Graph consent, and operational output evidence |
| Operational visibility: sign-in review, audit logs, policy checks, and alert review | [Monitoring and Operational Visibility](/engineering/release1-monitoring-operational-visibility/) | Release 1 monitoring and operations evidence |

### Technical validation checklist

- Verify that identity scope, access controls, and endpoint compliance are represented by evidence rather than narrative only.
- Inspect how Microsoft 365 service operations connect to identity and endpoint controls.
- Confirm that Graph and PowerShell operations are repeatable and supported by repository evidence.
- Review Release 1 monitoring as the operational bridge into Release 2 monitoring and resilience.

---

## 2. Delivery Engineering - IaC, CI/CD, and Traceability

**What to validate:** Terraform state isolation, secret-less pipelines, and traceability across source, workflow, and evidence.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Multi-root Terraform, remote state boundaries, and ownership separation | [Terraform State Boundaries](/engineering/terraform-state-boundaries/) | `terraform/`, state boundary documentation, and evidence index |
| OIDC-based GitHub Actions and workflow-controlled delivery | [GitHub Actions OIDC](/engineering/github-actions-oidc/) | Workflow and identity-federation evidence |
| Source, workflow, documentation, and platform claim traceability | [Code Traceability](/engineering/code-traceability/) | Traceability evidence, repository structure, and proof routes |

### Technical validation checklist

- Verify why Terraform roots are separated and what risk the boundary reduces.
- Inspect how OIDC changes the pipeline security model compared with stored credentials.
- Confirm that source files, workflow evidence, and proof routes form a reviewable chain.
- Check that delivery governance is presented as architecture rather than ad-hoc automation.

---

## 3. Network Engineering - Hybrid and Multi-Cloud Transit

**What to validate:** Hub-spoke design, routing control, IPSec, BGP, FortiGate NVA inspection, AWS branch integration, and validation evidence.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Hub-spoke fabric, Azure Firewall, UDR steering, and route control | [Hybrid Multi-Cloud Networking](/engineering/hybrid-multicloud-networking/) | Network Terraform, route tables, and Release 2 network evidence |
| IPSec, BGP, AWS branch routing, and cross-cloud transit | [Hybrid BGP Multi-Cloud Transit](/engineering/hybrid-bgp-multicloud-transit/) | VPN, BGP, AWS branch, and route-validation evidence |
| FortiGate NVA inspection and inspected traffic path | [Secure Transmission and Inspection](/engineering/secure-transmission-inspection/) | Inspection-path and firewall-validation evidence |

### Technical validation checklist

- Verify that route control and inspection are evidenced, not only diagrammed.
- Inspect BGP, IPSec, and AWS branch validation as part of the multi-cloud claim.
- Review how return paths and inspection paths are represented in the evidence.
- Confirm that network security is integrated into routing decisions.

---

## 4. Platform Services - Compute, Desktop, and Integration

**What to validate:** Private AKS architecture, AVD secure workspace design, and inspected integration between platform services.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Private AKS, controlled access, Kubernetes manifests, and network policy context | [Private AKS Platform](/engineering/private-aks-platform/) | O4 evidence and `kubernetes/` source |
| AVD secure workspace, FSLogix, private access, compliance context, and operator toolchain | [AVD Secure Workspace](/engineering/avd-secure-workspace/) | O5 evidence and private platform documentation |
| AVD-to-AKS private platform integration | [Private AKS and AVD Architecture](/engineering/private-aks-avd/) | Integration evidence and inspected path validation |

### Technical validation checklist

- Verify that AKS and AVD are treated as private platform services rather than default deployments.
- Inspect Kubernetes manifests and validation evidence.
- Review how AVD supports controlled administration rather than generic remote desktop.
- Confirm that cross-service private connectivity is validated.

---

## 5. Operations Engineering - Monitoring, Backup, and Resilience

**What to validate:** Monitoring, Sentinel, Defender for Cloud, Recovery Services Vault, backup validation, soft-delete handling, and BCDR.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Azure Monitor, Sentinel, Defender for Cloud, and alert validation | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Release 2 monitoring, alerting, Defender, and Sentinel evidence |
| Recovery Services Vault, backup policies, soft-delete handling, and recovery validation | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Backup, BCDR, and resilience evidence |
| Day-2 automation and runbook execution | [Automation Control Plane](/engineering/automation-control-plane/) | Ansible, AWX, job-template, and execution evidence |

### Technical validation checklist

- Verify that monitoring evidence includes validation, not only dashboard presence.
- Inspect backup and recovery controls as part of the platform resilience model.
- Review how runbooks and automation execution are governed and evidenced.
- Confirm that Release 2 operations build on Release 1 visibility.

---

## 6. AI Operations and Governance

**What to validate:** Policy-mediated tool use, approval boundaries, decision traces, and companion local AI lab implementation.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| AI operations enclave, policy boundary, evidence capture, and human approval | [AI Operations Enclave](/ai-operations/) | O6 evidence and AI operations documentation |
| Companion local AI lab for reproducible agent workflows | [Companion Project](/companion-project/) | `local-ai-lab-infra` repository and companion project page |

### Technical validation checklist

- Verify that AI-assisted operations are bounded by policy-mediated tool use and human approval.
- Inspect the O6 evidence route for decision traces, policy boundaries, and operational context.
- Review the companion local AI lab to understand how the governance pattern is reproduced for development use.

---

## Suggested review path

1. Start with the [Proof Gallery](/proof-gallery/) to understand evidence scope.
2. Pick a lifecycle domain above and open its engineering page.
3. Use each engineering page's evidence map to locate raw repository evidence.
4. Cross-check skills in the [Skills Matrix](/skills-matrix/).
5. Use the [Architecture Overview](/architecture/) and [Portfolio Case Study](/portfolio-case-study/) for the platform narrative.

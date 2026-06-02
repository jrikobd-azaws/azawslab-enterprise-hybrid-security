# Technical Reviewer Pathway

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
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

The platform is built across six lifecycle domains. Each domain has dedicated engineering pages that document design decisions, implementation patterns, and evidence. This pathway gives reviewers the technical questions to ask and the pages to inspect.

---

## 1. Hybrid Workplace - Identity, Messaging, Endpoint, and Operations

**What to verify:** Hybrid identity, Exchange Hybrid and Microsoft 365 services, modern endpoint management, operational scripting, and Release 1 monitoring discipline.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Entra Connect model, Conditional Access enforcement, MFA, and identity operations | [Hybrid Identity Engineering](/engineering/hybrid-identity/) | Release 1 identity screenshots and evidence index |
| Exchange Hybrid and Microsoft 365 service operations | [Exchange Hybrid and M365 Services](/engineering/exchange-hybrid-m365-services/) | Release 1 modern workplace and Exchange evidence |
| Autopilot, Intune compliance, BitLocker, Windows LAPS, Defender, and Purview | [Modern Endpoint Management](/engineering/modern-endpoint-management/) | Release 1 endpoint and information-protection evidence |
| Microsoft Graph and PowerShell operations | [Graph and PowerShell Operations](/engineering/graph-powershell-operations/) | Release 1 scripts, Graph consent, and operational output evidence |
| Operational visibility: sign-in review, audit logs, policy checks, and alert review | [Monitoring and Operational Visibility](/engineering/release1-monitoring-operational-visibility/) | Release 1 monitoring and operations evidence |

**Reviewer questions:**

- How does the identity design limit scope and enforce access control?
- What Conditional Access outcomes can be inspected in the sign-in evidence?
- How does the Microsoft 365 service layer extend the identity and endpoint story?
- Which Graph and PowerShell operations are repeatable, and what evidence do they produce?
- What is the cadence and scope of the Release 1 operational review?

---

## 2. Delivery Engineering - IaC, CI/CD, and Traceability

**What to verify:** Terraform state isolation, secret-less pipelines, and traceability across source, workflow, and evidence.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Multi-root Terraform, remote state boundaries, and ownership separation | [Terraform State Boundaries](/engineering/terraform-state-boundaries/) | 	erraform/, state boundary documentation, and evidence index |
| OIDC-based GitHub Actions and workflow-controlled delivery | [GitHub Actions OIDC](/engineering/github-actions-oidc/) | Workflow and identity-federation evidence |
| Source, workflow, documentation, and platform claim traceability | [Code Traceability](/engineering/code-traceability/) | Traceability evidence, repository structure, and proof routes |

**Reviewer questions:**

- Why are Terraform roots separated, and what risk does that reduce?
- How does OIDC change the pipeline security model compared with stored credentials?
- How does the project connect source, workflow evidence, and public proof?
- Where would a reviewer inspect the state boundary and pipeline model?

---

## 3. Network Engineering - Hybrid and Multi-Cloud Transit

**What to verify:** Hub-spoke design, routing control, IPSec, BGP, FortiGate NVA inspection, AWS branch integration, and validation evidence.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Hub-spoke fabric, Azure Firewall, UDR steering, and route control | [Hybrid Multi-Cloud Networking](/engineering/hybrid-multicloud-networking/) | Network Terraform, route tables, and Release 2 network evidence |
| IPSec, BGP, AWS branch routing, and cross-cloud transit | [Hybrid BGP Multi-Cloud Transit](/engineering/hybrid-bgp-multicloud-transit/) | VPN, BGP, AWS branch, and route-validation evidence |
| FortiGate NVA inspection and inspected traffic path | [Secure Transmission and Inspection](/engineering/secure-transmission-inspection/) | Inspection-path and firewall-validation evidence |

**Reviewer questions:**

- How are routes used to force traffic through the intended inspection path?
- What evidence proves BGP and IPSec transit rather than a diagram-only design?
- How is AWS branch integration represented in the network evidence?
- How is the return path validated across hybrid and multi-cloud traffic flows?

---

## 4. Platform Services - Compute, Desktop, and Integration

**What to verify:** Private AKS architecture, AVD secure workspace design, and inspected integration between platform services.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Private AKS, controlled access, Kubernetes manifests, and network policy context | [Private AKS Platform](/engineering/private-aks-platform/) | O4 evidence and kubernetes/ source |
| AVD secure workspace, FSLogix, private access, compliance context, and operator toolchain | [AVD Secure Workspace](/engineering/avd-secure-workspace/) | O5 evidence and private platform documentation |
| AVD-to-AKS private platform integration | [Private AKS and AVD Architecture](/engineering/private-aks-avd/) | Integration evidence and inspected path validation |

**Reviewer questions:**

- How is private platform access designed for AKS and AVD?
- What evidence shows Kubernetes manifests and platform validation?
- How does AVD support controlled administration rather than generic remote desktop?
- How is cross-service private connectivity validated?

---

## 5. Operations Engineering - Monitoring, Backup, and Resilience

**What to verify:** Monitoring, Sentinel, Defender for Cloud, Recovery Services Vault, backup validation, soft-delete handling, and BCDR.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| Azure Monitor, Sentinel, Defender for Cloud, and alert validation | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Release 2 monitoring, alerting, Defender, and Sentinel evidence |
| Recovery Services Vault, backup policies, soft-delete handling, and recovery validation | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Backup, BCDR, and resilience evidence |
| Day-2 automation and runbook execution | [Automation Control Plane](/engineering/automation-control-plane/) | Ansible, AWX, job-template, and execution evidence |

**Reviewer questions:**

- How does the project validate monitoring rather than only enabling dashboards?
- What evidence shows backup and recovery controls?
- How are automation runbooks governed and evidenced?
- Where is operational resilience documented?

---

## 6. AI Operations and Governance

**What to verify:** Policy-mediated tool use, approval boundaries, decision traces, and companion local AI lab implementation.

| Review focus | Engineering note | Evidence route |
|---|---|---|
| AI operations enclave, policy boundary, evidence capture, and human approval | [AI Operations Enclave](/ai-operations/) | O6 evidence and AI operations documentation |
| Companion local AI lab for reproducible agent workflows | [Companion Project](/companion-project/) | local-ai-lab-infra repository and companion project page |

**Reviewer questions:**

- What prevents AI-assisted operations from becoming autonomous infrastructure automation?
- What evidence shows policy-mediated tool use and approval boundaries?
- How does the companion local AI lab support the main platform story?

---

## Suggested review path

1. Start with the [Proof Gallery](/proof-gallery/) to understand evidence scope.
2. Pick a lifecycle domain above and open its engineering page.
3. Use each engineering page's evidence map to locate raw repository evidence.
4. Cross-check skills in the [Skills Matrix](/skills-matrix/).
5. Use the [Architecture Overview](/architecture/) and [Portfolio Case Study](/portfolio-case-study/) for the platform narrative.

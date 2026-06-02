# Architecture Overview

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

!!! summary "Purpose of this page"
    AzAWSLab architecture view covering design principles, lifecycle domains, layered security controls, and the engineering decisions behind the realistic Microsoft hybrid enterprise environment and Release 2 platform build-out.

## Design principles

Four principles shape the platform design across releases, Terraform roots, network paths, and automation workflows.

| Principle | What it means in AzAWSLab |
|---|---|
| **Evidence over assertion** | Platform claims are routed to screenshots, logs, source files, workflow records, or public-safe design documents. The [Proof Gallery](/proof-gallery/) organises those routes by lifecycle domain. |
| **Lifecycle-aligned boundaries** | Platform components are grouped by lifecycle domain: hybrid workplace, delivery engineering, network engineering, platform services, operations engineering, and AI governance. Those boundaries appear in Terraform root isolation, evidence routes, and Engineering Deep Dive notes. |
| **Secure by default, inspectable by design** | Core platform paths use controlled routing, inspection points, private access patterns, and validation evidence rather than default public exposure. |
| **Automation as a governed control plane** | GitHub Actions OIDC, Terraform state boundaries, Ansible, and AWX move automation from operator-local scripts into reviewable, repeatable execution paths. |

## Layered architecture model

Security is not treated as a separate workstream added after delivery. It is embedded across identity, endpoint, network, platform services, operations, and AI governance.

```text
+---------------------------------------------------+
|                Identity and Access                 |
|  Entra Connect, Conditional Access, MFA,           |
|  device compliance, Microsoft 365 access           |
+---------------------------------------------------+
                        |
+---------------------------------------------------+
|                Endpoint and Data                   |
|  Intune, Autopilot, BitLocker, Windows LAPS,       |
|  Defender controls, Purview, DLP, labels           |
+---------------------------------------------------+
                        |
+---------------------------------------------------+
|                Network and Inspection              |
|  Hub-spoke routing, Azure Firewall, FortiGate,     |
|  IPSec, BGP, AWS branch, private access paths      |
+---------------------------------------------------+
                        |
+---------------------------------------------------+
|                Platform Services                   |
|  Private AKS, Kubernetes policy context, AVD,      |
|  FSLogix, private platform administration          |
+---------------------------------------------------+
                        |
+---------------------------------------------------+
|                Operations and Resilience           |
|  Azure Monitor, Sentinel, Defender for Cloud,      |
|  Recovery Services Vault, backup validation, BCDR  |
+---------------------------------------------------+
                        |
+---------------------------------------------------+
|                AI Operations Governance            |
|  O6 evidence, policy-mediated tool use,            |
|  human review boundary, decision logs              |
+---------------------------------------------------+
```

Each layer has an [Engineering Deep Dive](/engineering/) route and a [Proof Gallery](/proof-gallery/) route.

## Lifecycle domains

The platform is organised across six lifecycle domains.

| Lifecycle domain | Scope | Entry point |
|---|---|---|
| **Hybrid Workplace** | Identity, Exchange Hybrid, Microsoft 365 services, endpoint management, Graph and PowerShell operations, and operational visibility. | [Engineering: Hybrid Workplace](/engineering/#release-1-hybrid-workplace) |
| **Delivery Engineering** | Terraform state boundaries, GitHub Actions OIDC, code traceability, and governed delivery workflows. | [Engineering: Delivery Engineering](/engineering/#release-2-delivery-engineering) |
| **Network Engineering** | Hub-spoke routing, Azure Firewall, FortiGate inspection, IPSec, BGP, AWS branch integration, and route validation. | [Engineering: Network Engineering](/engineering/#release-2-network-engineering) |
| **Platform Services** | Private AKS, AVD secure workspace, FSLogix, and private platform integration. | [Engineering: Platform Services](/engineering/#release-2-platform-services) |
| **Operations Engineering** | Azure Monitor, Sentinel, Defender for Cloud, Recovery Services Vault, backup validation, soft-delete handling, and BCDR. | [Engineering: Operations Engineering](/engineering/#release-2-operations-engineering) |
| **AI Governance** | AI Operations Enclave, evidenced through O6, policy-mediated tool use, human approval boundaries, and companion local AI lab context. | [AI Operations Enclave](/ai-operations/) |

## Key architectural decisions

### 1. Multi-root Terraform with isolated state

The platform avoids one monolithic Terraform root. Separate roots divide networking, management, shared services, AKS, AVD, governance, workload, and AWS branch ownership. That separation limits blast radius and makes ownership easier to review.

[Terraform State Boundaries](/engineering/terraform-state-boundaries/)

### 2. Secret-less CI/CD via OIDC

GitHub Actions uses OpenID Connect for workflow-controlled Azure authentication without routine long-lived deployment credentials. This keeps deployment identity tied to reviewable workflow evidence and reduces reliance on stored deployment secrets.

[GitHub Actions OIDC](/engineering/github-actions-oidc/)

### 3. Code traceability across source, workflow, and proof

The portfolio separates delivery authentication from implementation traceability. Code Traceability shows how source files, workflow records, documentation, and proof routes connect platform claims to reviewable implementation evidence.

[Code Traceability](/engineering/code-traceability/)

### 4. BGP-driven hybrid and multi-cloud transit

The network architecture includes on-premises routing, Azure hub-spoke design, IPSec, BGP, AWS branch routing, and inspection context. The architectural value is route control across hybrid and multi-cloud paths, not basic connectivity alone.

[Hybrid BGP Multi-Cloud Transit](/engineering/hybrid-bgp-multicloud-transit/) and [Hybrid Multi-Cloud Networking](/engineering/hybrid-multicloud-networking/)

### 5. Private platform services for AKS and AVD

AKS and AVD are presented as private platform services rather than default compute deployments. The design emphasises private access, route control, compliance context, Kubernetes source, and inspected integration paths.

[Private AKS Platform](/engineering/private-aks-platform/), [AVD Secure Workspace](/engineering/avd-secure-workspace/), and [Private AKS and AVD Architecture](/engineering/private-aks-avd/)

### 6. Governed automation with AWX

Ansible and AWX provide a governed automation control plane with source-controlled runbooks, inventories, job templates, and execution records. This keeps operations reviewable and repeatable beyond local script execution.

[Automation Control Plane](/engineering/automation-control-plane/)

### 7. Operational resilience and AI operations under policy governance

Operational resilience is routed through monitoring, alert validation, Defender for Cloud, Sentinel, backup controls, soft-delete handling, and BCDR planning. AI operations are represented through the AI Operations Enclave, evidenced through O6, with policy-mediated tool use, bounded agent access, structured decision records, namespace lifecycle evidence, and cleanup checks.

[Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/), [AI Operations Enclave](/ai-operations/), and [Companion Local AI Lab](/companion-project/)

## Platform evolution

Release 3 carries the existing multi-cloud routing, private platform, and operational governance work toward cross-cloud Kubernetes, GitOps, DevSecOps scanning, observability, and resilience.

[Release 3 Roadmap](/releases/release3/)

## Where to see the evidence

- **[Proof Gallery](/proof-gallery/)** - curated evidence dashboard for the major platform capabilities.
- **[Skills Matrix](/skills-matrix/)** - skills map with links to engineering notes and proof routes.
- **[Engineering Deep Dive](/engineering/)** - engineering notes with design rationale, implementation context, and evidence maps.
- **[GitHub Repository](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security)** - public-safe screenshots, logs, Terraform code, documentation, workflows, and evidence folders.

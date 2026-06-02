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
    The architecture narrative for AzAWSLab: design principles, lifecycle domains, layered security controls, and the key engineering decisions that turn a realistic Microsoft hybrid enterprise environment into a governed multi-cloud platform.

## Design principles

Four principles guide the platform design across releases, Terraform roots, network paths, and automation workflows.

| Principle | What it means in AzAWSLab |
|---|---|
| **Evidence over assertion** | Claimed capabilities are mapped to screenshots, logs, source files, workflow records, or public-safe design documents. The [Proof Gallery](/proof-gallery/) organises this evidence by lifecycle domain. |
| **Lifecycle-aligned boundaries** | Platform components are grouped by lifecycle domain: workplace, delivery, network, platform services, operations, and AI governance. Those boundaries are reflected in Terraform root isolation, evidence routes, and engineering notes. |
| **Secure by default, inspectable by design** | Core platform paths are designed around controlled routing, inspection points, private access patterns, and evidence-backed validation rather than default public exposure. |
| **Automation as a governed control plane** | GitHub Actions OIDC, Terraform state boundaries, Ansible, and AWX move automation away from operator-local scripts and into reviewable, repeatable execution paths. |

## Layered architecture model

Security is not a separate bucket bolted onto the project. It is embedded across the platform lifecycle.

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

Every layer is supported by engineering notes in the [Engineering Deep Dive](/engineering/) and evidence routes in the [Proof Gallery](/proof-gallery/).

## Lifecycle domains

The platform is built and documented across six lifecycle domains.

| Lifecycle domain | Scope | Entry point |
|---|---|---|
| **Hybrid Workplace** | Identity, Exchange Hybrid, Microsoft 365 services, endpoint management, Graph and PowerShell operations, operational visibility. | [Engineering: Hybrid Workplace](/engineering/#release-1-hybrid-workplace) |
| **Delivery Engineering** | Terraform state boundaries, GitHub Actions OIDC, code traceability, and delivery governance. | [Engineering: Delivery Engineering](/engineering/#release-2-delivery-engineering) |
| **Network Engineering** | Hub-spoke routing, Azure Firewall, FortiGate inspection, IPSec, BGP, AWS branch integration, and route validation. | [Engineering: Network Engineering](/engineering/#release-2-network-engineering) |
| **Platform Services** | Private AKS, AVD secure workspace, and private platform integration. | [Engineering: Platform Services](/engineering/#release-2-platform-services) |
| **Operations Engineering** | Azure Monitor, Sentinel, Defender for Cloud, Recovery Services Vault, backup validation, soft-delete handling, and BCDR. | [Engineering: Operations Engineering](/engineering/#release-2-operations-engineering) |
| **AI Governance** | AI Operations Enclave, O6 evidence, policy-mediated tool use, human approval boundaries, and companion local AI lab. | [AI Operations Enclave](/ai-operations/) |

## Key architectural decisions

### 1. Multi-root Terraform with isolated state

The platform avoids a single monolithic Terraform root. Separate roots divide networking, management, shared services, AKS, AVD, governance, workload, and AWS branch responsibilities. That separation reduces blast radius and makes ownership easier to reason about.

[Terraform State Boundaries](/engineering/terraform-state-boundaries/)

### 2. Secret-less CI/CD via OIDC

GitHub Actions uses OpenID Connect to support workflow-controlled Azure authentication without routine long-lived deployment credentials. This strengthens delivery security and keeps deployment identity tied to reviewable workflow evidence.

[GitHub Actions OIDC](/engineering/github-actions-oidc/)

### 3. Code traceability across source, workflow, and proof

The portfolio separates delivery authentication from traceability. Code Traceability focuses on how source files, workflow evidence, documentation, and proof routes connect platform claims to reviewable implementation evidence.

[Code Traceability](/engineering/code-traceability/)

### 4. BGP-driven hybrid and multi-cloud transit

The network story includes on-premises routing, Azure hub-spoke design, IPSec, BGP, AWS branch routing, and inspection context. The architectural value is not only connectivity; it is validated route control across hybrid and multi-cloud paths.

[Hybrid BGP Multi-Cloud Transit](/engineering/hybrid-bgp-multicloud-transit/) and [Hybrid Multi-Cloud Networking](/engineering/hybrid-multicloud-networking/)

### 5. Private platform services for AKS and AVD

AKS and AVD are presented as private platform services, not default compute deployments. The design emphasises private access, route control, compliance context, Kubernetes source, and inspected integration.

[Private AKS Platform](/engineering/private-aks-platform/), [AVD Secure Workspace](/engineering/avd-secure-workspace/), and [Private AKS and AVD Architecture](/engineering/private-aks-avd/)

### 6. Governed automation with AWX

Ansible and AWX provide a governed automation control plane with source-controlled runbooks, inventories, job templates, and execution evidence. This keeps day-2 operations reviewable and repeatable.

[Automation Control Plane](/engineering/automation-control-plane/)

### 7. Operational resilience and AI operations under policy governance

Operational resilience is evidenced through monitoring, alert validation, Defender for Cloud, Sentinel, backup controls, soft-delete handling, and BCDR planning. AI operations are represented through the O6 evidence set, policy-mediated tool use, bounded agent access, structured decision records, namespace lifecycle evidence, and cleanup checks.

[Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/), [AI Operations Enclave](/ai-operations/), and [Companion Local AI Lab](/companion-project/)

## Platform evolution

Release 3 extends the existing multi-cloud routing, private platform, and operational governance story toward cross-cloud Kubernetes, GitOps, DevSecOps scanning, observability, and resilience.

[Release 3 Roadmap](/releases/release3/)

## Where to see the evidence

- **[Proof Gallery](/proof-gallery/)** - curated evidence dashboard covering the major platform capabilities.
- **[Skills Matrix](/skills-matrix/)** - competency map with links to engineering notes and proof routes.
- **[Engineering Deep Dive](/engineering/)** - engineering notes with design rationale and evidence maps.
- **[GitHub Repository](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security)** - public-safe screenshots, logs, Terraform code, documentation, and evidence folders.

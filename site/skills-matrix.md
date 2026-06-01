# Skills Matrix

<div class="portfolio-chipline"><a class="portfolio-chip" href="/portfolio-case-study/"><span class="portfolio-chip-label">Journey</span><span class="portfolio-chip-value portfolio-chip-value-ready">Public Ready</span></a><a class="portfolio-chip" href="/releases/release1/"><span class="portfolio-chip-label">R1</span><span class="portfolio-chip-value">Workplace + M365</span></a><a class="portfolio-chip" href="/releases/release2/"><span class="portfolio-chip-label">R2</span><span class="portfolio-chip-value">Platform + Multi-Cloud</span></a><a class="portfolio-chip" href="/releases/release3/"><span class="portfolio-chip-label">R3</span><span class="portfolio-chip-value portfolio-chip-value-muted">Roadmap</span></a></div>

The matrix below translates the platform implementation into role-aligned engineering signals, showing where each capability is proven across identity, Azure platform engineering, automation, networking, security, resilience, and operations.

## Capability layers

<div class="grid cards" markdown>

-   **Identity and workplace operations**

    AD DS, Exchange Hybrid, Entra Connect, Conditional Access, MFA, Intune, Autopilot, BitLocker, LAPS, Purview, Sentinel, Defender for Cloud, and recovery workflows.

-   **Azure platform engineering**

    Terraform landing zones, management groups, Azure Policy, RBAC, remote state, separated roots, private AKS, AVD, monitoring, and platform governance.

-   **Networking and secure transit**

    Hub-spoke, Azure Firewall, forced tunneling, route tables, FortiGate NVA inspection, AWS branch, site-to-site VPN, BGP, and route validation.

-   **Automation, resilience, and CloudOps**

    GitHub Actions OIDC, Ansible, AWX, job templates, Recovery Services Vault, BCDR planning, soft-delete handling, and AI operations.

</div>

## Core skill domains

| Domain | Concrete capabilities |
|---|---|
| Azure platform engineering | Landing zones, Terraform root separation, governance, private AKS, AVD, monitoring |
| Microsoft hybrid identity | AD DS, Entra Connect, Conditional Access, MFA, identity protection |
| Modern endpoint management | Intune, Autopilot, compliance policies, BitLocker, LAPS, device recovery |
| Microsoft 365 operations and compliance | Exchange Hybrid, Exchange Online, Teams, SharePoint, Entra Connect, Conditional Access, Purview, DLP, sensitivity labels |
| Infrastructure as Code | Multi-root Terraform, remote state, plan/apply discipline, state drift detection |
| CI/CD and secretless delivery | GitHub Actions OIDC, workflow-controlled Terraform, no routine local apply |
| Hybrid networking | Hub-spoke, Azure Firewall, forced tunneling, service chaining |
| Advanced traffic inspection | FortiGate NVA integration, firewall policy validation |
| Multi-cloud networking | AWS branch, BGP, site-to-site VPN, cross-cloud route validation |
| Automation and operations | Ansible playbooks, AWX control plane, job templates, backup and recovery |
| Kubernetes platform engineering | Private AKS, network policies, manifest management |
| Secure virtual desktop | AVD with FSLogix, private endpoints, privileged access workspace |
| Security operations | Microsoft Sentinel, Defender for Cloud, alerting, DLP, Purview |
| AI operations | Governed AI enclave with policy mediation, local-ai-lab-infra companion |
| Backup and resilience | Recovery Services Vault, BCDR planning, soft-delete handling |

## Role alignment

| Target role | Strongest proof areas |
|---|---|
| Cloud Engineer | Azure, Terraform, networking, identity, automation |
| Cloud Platform Engineer | Landing zone, state boundaries, CI/CD, private AKS, AWX, multi-cloud routing |
| DevOps Engineer | GitHub Actions, Terraform validation, AWX, operational runbooks |
| Security Engineer | Conditional Access, Sentinel, FortiGate, private access, AI governance |
| Infrastructure Engineer | AD DS, Exchange Hybrid, Hyper-V, multi-cloud transit, Windows/Linux operations |
| Cloud Architect | End-to-end staged architecture, evidence-backed design, roadmap discipline |

## Deeper evidence

- [Proof Gallery](proof-gallery.md)
- [Technical Reviewer Path](role-paths/technical-reviewer.md)
- [Engineering Deep Dive: Terraform State Boundaries](engineering/terraform-state-boundaries.md)
- [Engineering Deep Dive: GitHub Actions OIDC](engineering/github-actions-oidc.md)
- [Engineering Deep Dive: Hybrid Multi-Cloud Networking](engineering/hybrid-multicloud-networking.md)
- [Engineering Deep Dive: Automation Control Plane](engineering/automation-control-plane.md)

The complete skills matrix source is maintained in the GitHub repository.
# Recruiter Overview

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
    A fast, evidence-backed briefing for recruiters and sourcing specialists who need to understand the platform scope, the skills demonstrated, and the proof available in under five minutes.

## Platform snapshot

AzAWSLab is not a collection of isolated labs. It is a staged enterprise platform built from a realistic on-premises hybrid environment into Azure, AWS-connected networking, private platform engineering, automation, and governed AI operations.

Major capabilities are evidenced through screenshots, logs, source files, workflow records, engineering notes, and public-safe repository documentation.

**Three releases, one platform journey:**

- **Release 1** - Hybrid workplace, identity, endpoint security, and Microsoft 365 operations.
- **Release 2** - Azure platform engineering, multi-cloud networking, automation, private compute, backup, and AI governance.
- **Release 3** - Multi-cloud Kubernetes, GitOps, and DevSecOps roadmap.

## Skills demonstrated

The [Skills Matrix](/skills-matrix/) maps specific capabilities to engineering notes and proof routes. Recruiter-relevant highlights:

| Domain | Key skills |
|---|---|
| Identity and Workplace | Entra Connect, Conditional Access, Intune, Autopilot, Exchange Hybrid, Microsoft Purview, Microsoft Graph and PowerShell |
| Infrastructure as Code | Multi-root Terraform, remote state boundaries, GitHub Actions OIDC, code traceability |
| Networking | Hub-spoke design, BGP, IPSec VPNs, Azure Firewall, FortiGate NVA inspection, AWS branch routing |
| Platform Services | Private AKS, Kubernetes policy context, Azure Virtual Desktop, FSLogix, private access patterns |
| Automation | Ansible, AWX control plane, source-controlled runbooks, governed job execution |
| Operations | Azure Monitor, Sentinel, Defender for Cloud, Recovery Services Vault, backup validation, BCDR planning |
| AI Governance | AI operations enclave, policy-mediated tool use, human approval boundaries, companion local AI lab |

## Proof highlights for screening calls

When speaking to a hiring manager, these points are backed by public evidence:

1. **Secret-less Terraform delivery** - GitHub Actions OIDC reduces reliance on long-lived Azure deployment credentials.
   Ask about CI/CD safety and traceability.

2. **Hybrid identity and endpoint security** - Active Directory, Entra ID, Conditional Access, Intune, Autopilot, BitLocker, LAPS, and Purview are represented in Release 1.
   Ask about zero-trust and endpoint management.

3. **Hybrid and multi-cloud network engineering** - The platform includes Azure hub-spoke networking, IPSec, BGP, Azure Firewall, FortiGate inspection, and AWS branch integration.
   Ask about multi-cloud routing and NVA integration.

4. **Private platform delivery** - Private AKS and AVD are used as controlled platform access patterns.
   Ask about private compute and secure administration.

5. **Governed AI operations** - AI tool use is framed through policy-mediated tool use and human approval boundaries.
   Ask about AI governance and operational safety.

## Where the proof lives

- [**Proof Gallery**](/proof-gallery/) - Curated evidence dashboard covering the major platform capabilities.
- [**Engineering Deep Dive**](/engineering/) - Implementation rationale, configuration decisions, and evidence maps.
- [**Skills Matrix**](/skills-matrix/) - Competency map with links to engineering notes and proof routes.

All evidence is public-safe, sanitised, and stored in the [GitHub repository](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security).

## Suggested screening questions

- Walk me through how you designed the Terraform state boundaries and why.
- How did you validate routing and inspection across the hybrid and multi-cloud network?
- What controls prevent AI-assisted operations from becoming autonomous infrastructure change?
- How do you prove backup and recovery rather than only enabling backup?
- How does the AVD workspace support secure platform administration?

## Candidate profile alignment

AzAWSLab aligns with roles that require hands-on implementation and architecture judgement, including:

- Cloud Platform Engineer
- Azure Infrastructure Engineer
- DevOps / Platform Engineer
- Cloud Security Engineer
- Site Reliability Engineer
- Platform Architect
- Technical Lead for hybrid or multi-cloud projects

## Next steps

1. Scan the [Proof Gallery](/proof-gallery/) to see evidence scope.
2. Review the [Skills Matrix](/skills-matrix/) for a competency inventory.
3. Use the [Portfolio Case Study](/portfolio-case-study/) for the platform narrative.
4. Direct the hiring manager or technical reviewer to the [Engineering Deep Dive](/engineering/).

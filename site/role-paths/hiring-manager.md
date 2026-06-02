# Hiring Manager Pathway

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
    A hiring-manager briefing that translates the platform's technical depth into delivery maturity, risk reduction, and operational judgement. The goal is to show what was built, why it matters, and where the proof lives.

## Platform overview

AzAWSLab is not a collection of isolated labs. It is a staged enterprise platform built from a realistic on-premises hybrid environment into Azure platform engineering, AWS-connected multi-cloud networking, private compute, automation, and governed AI operations.

The platform is delivered across three releases:

- **Release 1** - Hybrid workplace, identity, endpoint security, and Microsoft 365 operations.
- **Release 2** - Azure platform engineering, secure multi-cloud networking, automation, private AKS and AVD, backup, and AI operations.
- **Release 3** - Multi-cloud Kubernetes, GitOps, and DevSecOps roadmap.

## Business value delivered

| Business outcome | How the platform demonstrates it |
|---|---|
| Reduced credential exposure | GitHub Actions OIDC supports workflow-controlled Azure authentication without routine long-lived deployment credentials. |
| Controlled infrastructure change | Terraform state boundaries, plan-review-apply discipline, and separate platform roots reduce blast radius. |
| Operational resilience | Recovery Services Vault controls, soft-delete handling, backup validation, and BCDR planning show recovery thinking beyond deployment. |
| Zero-trust operating model | Conditional Access, MFA, device compliance, private endpoints, route control, and network inspection are embedded across the platform. |
| Audit-ready delivery | Source files, workflow evidence, engineering notes, and proof routes make platform claims traceable. |
| Private platform access | Private AKS, AVD, FSLogix, and inspected network paths show platform access treated as an architectural boundary. |
| Governed AI adoption | AI operations are framed with policy-mediated tool use and human approval boundaries, not autonomous infrastructure change. |

## Delivery maturity indicators

AzAWSLab demonstrates platform engineering maturity beyond basic automation:

- **Infrastructure as Code discipline** - Terraform root boundaries separate networking, management, shared services, AKS, AVD, governance, workload, and AWS branch concerns.
- **Pipeline governance** - GitHub Actions OIDC, plan/apply workflow evidence, and traceability patterns reduce delivery risk.
- **Automation control plane** - Ansible and AWX evidence show operational automation treated as a governed capability, not operator-local scripting.
- **Operational visibility** - Release 1 uses practical Microsoft 365 monitoring and Release 2 extends operations through Azure Monitor, Sentinel, Defender for Cloud, backup, and resilience evidence.
- **Private platform delivery** - AKS and AVD are presented as controlled access patterns with private networking, policy context, and validation evidence.
- **AI safety boundary** - O6 positions AI as an assisted operations enclave with policy, evidence, and approval boundaries.

## Risk reduction summary

| Risk | Mitigation evidenced in AzAWSLab |
|---|---|
| Credential leakage in CI/CD | OIDC-based delivery patterns reduce reliance on long-lived deployment credentials. |
| Uncontrolled infrastructure changes | Terraform state boundaries and reviewable workflow evidence reduce blast radius. |
| Data loss or recovery uncertainty | Recovery Services Vault evidence, backup validation, soft-delete handling, and BCDR documentation support recoverability. |
| Unauthorised cloud access | Conditional Access, MFA, compliant-device context, private endpoints, and governed administration paths. |
| Network misrouting or uninspected traffic | Hub-spoke routing, Azure Firewall, FortiGate inspection, IPSec, BGP, and AWS branch validation. |
| Unsafe AI-assisted operations | Policy-mediated tool use and human approval boundaries prevent AI from becoming autonomous infrastructure automation. |

## Role alignment

AzAWSLab aligns with roles that require hands-on delivery, architecture judgement, and evidence-backed communication, including:

- Cloud Platform Engineer
- Cloud Platform Architect
- Azure Infrastructure Engineer
- Infrastructure Architect for hybrid or multi-cloud environments
- DevOps / Platform Engineer
- Site Reliability Engineer
- Cloud Security Engineer
- Technical Lead for cloud transformation or platform engineering

The portfolio demonstrates not only technical execution, but also the discipline to design, document, validate, and explain a connected platform.

## Where to validate

- [**Skills Matrix**](/skills-matrix/) - Capability inventory mapped to engineering notes and proof routes.
- [**Proof Gallery**](/proof-gallery/) - Curated evidence dashboard covering the major platform capabilities.
- [**Engineering Deep Dive**](/engineering/) - Implementation rationale, configuration details, and evidence maps.
- [**Portfolio Case Study**](/portfolio-case-study/) - Executive narrative and platform transformation story.

All evidence is public-safe, sanitised, and stored in the [GitHub repository](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security).

## Suggested interview topics

- Ask the candidate to explain how Terraform state boundaries reduce blast radius.
- Ask why GitHub Actions OIDC was used instead of long-lived deployment credentials.
- Ask how the platform validates backup and recovery beyond checking that a backup job exists.
- Ask how BGP, IPSec, Azure Firewall, FortiGate, and AWS branch routing fit together.
- Ask how private AKS and AVD support controlled platform administration.
- Ask what controls stop AI-assisted operations from becoming autonomous infrastructure change.

## Hiring manager takeaway

AzAWSLab shows architecture, implementation, operational discipline, evidence capture, and communication. It is a strong signal for roles where the candidate must not only build cloud infrastructure, but explain risk, prove delivery, and operate within clear governance boundaries.

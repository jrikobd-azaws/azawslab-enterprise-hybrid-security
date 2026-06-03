---
title: Home
hide:
  - title
  - navigation
  - toc
---
<!-- azawslab-home-hero-compact-style:start -->
<style>
/* Homepage-only title trim.
   Keep this page-specific so the rest of the site keeps normal MkDocs spacing. */
.md-content__inner > h1:first-child {
  display: none;
}

.md-content__inner {
  padding-top: 0.45rem;
}
</style>
<!-- azawslab-home-hero-compact-style:end -->
<section class="home-hero hero hero--compact" markdown>


<p align="center">
  <img src="assets/brand/header-floating.svg" alt="" class="home-hero-logo">
</p>

<p class="hero-subtitle"><strong>Flagship Azure, AWS-connected hybrid, and multi-cloud platform engineering portfolio with public evidence routes.</strong></p>

AzAWSLab is the flagship portfolio project: a staged technical platform built from a realistic Microsoft hybrid enterprise environment into Azure platform engineering, AWS-connected secure networking, automation, private platform services, operations, and AI governance.

<div class="hero-proof-strip" markdown>

**Inside:** Terraform-driven Azure platform roots, AWS branch routing, OIDC-based delivery, hybrid identity, Exchange Hybrid, private AKS, AVD, AWX automation, backup resilience, and the AI Operations Enclave, evidenced through O6.

**Evidence route:** Proof Gallery, Engineering Deep Dive, and Skills Matrix connect implementation claims to screenshots, CLI output, workflow logs, source files, design notes, and evidence folders.

**Reviewers:** Cloud engineers, platform engineers, infrastructure architects, security architects, DevOps/SRE reviewers, and technical hiring teams.

</div>

[Explore Platform Journey](releases/index.md){ .role-button }
[View Proof Gallery](proof-gallery.md){ .role-button }
[Reviewer Pathways](role-paths/index.md){ .role-button }

</section>

!!! success "Public portfolio status"
    Published through a public GitHub repository, custom domain, HTTPS, evidence folders, strict documentation checks, and role-based reviewer paths.

[![Platform hero diagram](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/raw/main/diagrams/platform/hero-diagram.png)](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/diagrams/platform/hero-diagram.png)

*Platform architecture overview - [view full diagram on GitHub](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/diagrams/platform/hero-diagram.png)*

## What this platform contains

<div class="grid cards" markdown>

-   :material-numeric-1-circle: **Release 1: hybrid workplace, identity, endpoint security, and Microsoft 365 operations**

    Realistic Microsoft hybrid enterprise environment with Hyper-V, AD DS, Exchange Hybrid, Entra Connect, Conditional Access, Intune, Autopilot, BitLocker, Windows LAPS, Purview, Sentinel, Defender for Cloud, operational visibility, and Microsoft Graph PowerShell.

    [Open Release 1 summary](releases/release1.md)

-   :material-numeric-2-circle: **Release 2: platform engineering, secure networking, automation, private platform services, operations, and AI governance**

    Terraform-driven Azure platform roots, OIDC delivery, isolated state boundaries, Azure governance, hub-spoke networking, FortiGate inspection, BGP, AWS branch transit, AWX automation, backup resilience, private AKS, AVD secure workspace, and the AI Operations Enclave, evidenced through O6.

    [Open Release 2 summary](releases/release2.md)

-   :material-numeric-3-circle: **Release 3: multi-cloud Kubernetes, GitOps, and DevSecOps roadmap**

    Roadmap for AKS/EKS, Flux, Flagger, DevSecOps scanning, observability, resilience, and platform evolution.

    [Open Release 3 roadmap](releases/release3.md)

</div>

## Core architectural capabilities

<div class="grid cards" markdown>

-   :material-key-chain: **OIDC-based IaC delivery**

    GitHub Actions OIDC and workflow-controlled Terraform delivery reduce reliance on long-lived credentials and keep deployment behaviour reviewable.

    [Review OIDC delivery](engineering/github-actions-oidc.md)

-   :material-lan-connect: **Hybrid and multi-cloud fabric**

    Hub-spoke routing, Azure Firewall, FortiGate NVA inspection, VPN, BGP, and AWS branch patterns validate the transit and inspection model.

    [Review networking](engineering/hybrid-multicloud-networking.md)

-   :material-shield-lock: **Private platform services**

    Private AKS and secure AVD workspace patterns keep platform and operator access inside controlled network paths.

    [Review private platform](engineering/private-aks-avd.md)

-   :material-cog-sync: **Automation and resilience**

    AWX job templates, governed runbooks, Recovery Services Vault controls, soft-delete handling, backup validation, and BCDR plans provide the operations evidence route.

    [Review automation control plane](engineering/automation-control-plane.md)

-   :material-robot-outline: **AI operations boundary**

    The AI Operations Enclave, evidenced through O6, models policy-mediated tool use and human approval boundaries for AI-assisted platform operations.

    [Review AI operations](ai-operations/index.md)

</div>

## Platform journey and evidence routes

<div class="grid cards" markdown>

-   ### Platform journey

    ```mermaid
    flowchart LR
        R1["Release 1<br/>Hybrid workplace<br/>Microsoft 365 operations"]
        R2["Release 2<br/>Platform engineering<br/>AWS branch routing"]
        O6["O6<br/>AI Operations Enclave"]
        R3["Release 3<br/>Kubernetes<br/>GitOps and DevSecOps roadmap"]

        R1 --> R2 --> O6 --> R3
    ```

    **Release 1** - Hybrid workplace, identity, endpoint security, and Microsoft 365 operations.

    **Release 2** - Azure platform engineering, AWS-connected secure networking, automation, private platform services, operations, and AI governance.

    **Release 3** - Multi-cloud Kubernetes, GitOps, and DevSecOps roadmap.

-   ### Featured evidence

    **[Proof Gallery](proof-gallery.md)**

    Reviewer evidence dashboard for the major capability routes.

    **[Skills Matrix](skills-matrix.md)**

    Capability-to-evidence map across Microsoft 365, Azure, AWS-connected networking, automation, Kubernetes, AVD, resilience, and AI governance.

    **[Engineering Deep Dive](engineering/index.md)**

    Technical notes, implementation context, and evidence maps.

    **[GitHub source repository](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security)**

    Implementation source, workflows, Terraform roots, manifests, diagrams, and evidence folders.

</div>

## Choose your reviewer path

<div class="grid cards" markdown>

-   **[Recruiter path](role-paths/recruiter.md)**

    Fast skills scan, role alignment, priority evidence, and interview-ready talking points.

-   **[Hiring manager path](role-paths/hiring-manager.md)**

    Business context, delivery ownership, risk reduction, and platform operating model.

-   **[Technical reviewer path](role-paths/technical-reviewer.md)**

    IaC design, Terraform state boundaries, workflows, networking, AKS, AVD, and evidence routes.

-   **[Security architect path](role-paths/security-architect.md)**

    Identity governance, endpoint controls, network inspection, private access, resilience, and AI governance.

-   **[DevOps and SRE path](role-paths/devops-sre.md)**

    OIDC-based delivery, automation governance, observability, backup resilience, and operational runbooks.

</div>

## Source repository
The public GitHub repository contains the implementation, evidence folders, workflows, Terraform roots, Kubernetes manifests, diagrams, and Markdown documentation.

[:fontawesome-brands-github: Open GitHub repository](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security){ .md-button .md-button--primary }



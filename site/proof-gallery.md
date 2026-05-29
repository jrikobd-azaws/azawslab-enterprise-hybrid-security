---
title: Proof Gallery
---

# Evidence-Backed Verification Dashboard

This page is the reviewer-facing proof dashboard for the platform. Each proof card explains three things:

- **What it proves** - the technical capability demonstrated.
- **Why it matters** - the business, security, or operational risk it addresses.
- **Where to inspect** - the safest source path for deeper review.

!!! note "Evidence model"
    This gallery links to curated site pages and public-safe repository folders. It avoids unverified one-off file names, raw secrets, state files, credentials, kubeconfigs, private keys, and unredacted tenant data.

---

## Visual proof map

<div class="grid cards" markdown>

- ![Platform journey](assets/images/proof/01-platform-hero.jpg)
  **Platform Journey**  
  Executive view of the staged enterprise platform: identity, cloud foundation, private platform, and governed AI-assisted CloudOps.

- ![Release 2 architecture](assets/images/proof/02-release2-architecture.jpg)
  **Release 2 Platform Architecture**  
  Azure platform engineering, secure networking, private platform delivery, automation, monitoring, and evidence-driven validation.

- ![Terraform state boundaries](assets/images/proof/03-terraform-state-boundaries.jpg)
  **Terraform State Boundaries**  
  Multi-root Terraform ownership model showing how blast radius, lifecycle, and platform responsibilities are separated.

- ![AI operations enclave](assets/images/proof/04-ai-operations-enclave.jpg)
  **O6 AI Operations Enclave**  
  Governed AI-assisted CloudOps pattern with policy-mediated tool use, evidence capture, and human approval boundaries.

- ![Release 3 roadmap](assets/images/proof/05-release3-roadmap.jpg)
  **Release 3 Roadmap**  
  Multi-cloud Kubernetes, GitOps, DevSecOps, observability, and resilience direction.

</div>

---
## Release 1: Hybrid workplace and identity foundation

???+ example "Hybrid Microsoft foundation and local enterprise base"
    **What it proves:** The project starts from a realistic local enterprise base: Hyper-V, Active Directory DS, DNS, Windows Server workloads, and Microsoft hybrid identity patterns.

    **Why it matters:** This prevents the project from reading like a disconnected cloud click-through. It shows the platform was built from a foundation that resembles real enterprise infrastructure.

    **Where to inspect:**

    - [Release 1 screenshots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1){ target="_blank" }
    - [Platform foundation screenshots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1/platform-foundation){ target="_blank" }
    - [Release 1 documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release1){ target="_blank" }

    **Reviewer takeaway:** The candidate understands the dependency chain between local infrastructure, identity, endpoint management, and cloud adoption.

???+ example "Modern endpoint and identity governance"
    **What it proves:** Microsoft identity and endpoint controls were implemented and evidenced across Entra ID, Intune, Autopilot, compliance, BitLocker, LAPS, and operational recovery scenarios.

    **Why it matters:** Enterprise security is not only network or cloud security. Identity, device state, enrollment, and recovery determine whether access controls are enforceable.

    **Where to inspect:**

    - [Identity and access screenshots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1/identity-and-access){ target="_blank" }
    - [Endpoint management screenshots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1/endpoint-management){ target="_blank" }
    - [Information protection screenshots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1/information-protection){ target="_blank" }

    **Reviewer takeaway:** The project demonstrates practical Microsoft security operations, not only policy descriptions.

---

## Release 2: Azure platform engineering and security

???+ success "Secretless Terraform delivery through GitHub Actions OIDC"
    **What it proves:** Terraform delivery is controlled through GitHub Actions and OIDC instead of relying on long-lived deployment credentials.

    **Why it matters:** Static cloud deployment credentials are a common breach and drift risk. OIDC-based delivery reduces that exposure and aligns the platform with modern identity-first CI/CD.

    **Where to inspect:**

    - [P0 evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P0){ target="_blank" }
    - [Landing zone, IaC, and governance story](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/01-landing-zone-iac-governance.md){ target="_blank" }
    - [GitHub Actions workflows](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/.github/workflows){ target="_blank" }

    **Reviewer takeaway:** Infrastructure delivery is workflow-governed and identity-aware, not ad hoc local execution.

???+ success "Terraform root and state boundary discipline"
    **What it proves:** Terraform ownership is separated across platform networking, platform management, AKS, AVD, shared services, governance, workloads, and AWS branch roots.

    **Why it matters:** State separation and root ownership reduce blast radius. A mistake in one area should not casually mutate the management plane, network core, or unrelated workloads.

    **Where to inspect:**

    - [Terraform state and pipeline map](https://www.azawslab.co.uk/engineering/terraform-state-boundaries/)
    - [State and pipeline source document](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md){ target="_blank" }
    - [Platform management state split evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/platform-management-state-split){ target="_blank" }

    **Reviewer takeaway:** The candidate understands Terraform as an operational control plane, not just a provisioning tool.

???+ success "Hybrid and multi-cloud routing evidence"
    **What it proves:** The platform includes secure hybrid and multi-cloud network engineering with hub-spoke design, firewall inspection context, VPN/IPSec, BGP, and AWS branch integration.

    **Why it matters:** Multi-cloud architectures fail when routing, inspection, and ownership boundaries are not explicit. This evidence shows route path and branch connectivity thinking.

    **Where to inspect:**

    - [Hybrid multi-cloud networking page](https://www.azawslab.co.uk/engineering/hybrid-multicloud-networking/)
    - [P5 evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5){ target="_blank" }
    - [P5 VPN evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P5-vpn){ target="_blank" }
    - [Networking capability story](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/02-hybrid-multicloud-network-security.md){ target="_blank" }

    **Reviewer takeaway:** The project demonstrates practical routing and inspection design beyond a single-cloud demo.

???+ success "AWX automation control plane"
    **What it proves:** Automation moves beyond local scripts into a control-plane pattern with AWX, job templates, evidence, and governed operational execution.

    **Why it matters:** Enterprise automation needs repeatability, role boundaries, and reviewable execution history. AWX is used here as an operations layer, not just a tooling screenshot.

    **Where to inspect:**

    - [A2 AWX evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane){ target="_blank" }
    - [Automation, SecOps, and resilience story](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/03-automation-secops-resilience.md){ target="_blank" }
    - [DevOps and SRE path](role-paths/devops-sre.md)

    **Reviewer takeaway:** Day-2 operations are treated as architecture, not an afterthought.

???+ success "Private AKS platform boundary"
    **What it proves:** Private AKS is presented as a secure platform pattern with private access, controlled egress thinking, Kubernetes support manifests, and evidence-backed validation.

    **Why it matters:** Kubernetes platforms should not expose critical control paths casually. Private cluster design, private endpoints, and egress control reduce public exposure.

    **Where to inspect:**

    - [Private AKS and AVD page](https://www.azawslab.co.uk/engineering/private-aks-avd/)
    - [O4 evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4){ target="_blank" }
    - [Kubernetes manifests](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/kubernetes){ target="_blank" }

    **Reviewer takeaway:** The candidate can reason about private Kubernetes platform delivery and evidence-backed validation.

???+ success "AVD and FSLogix secure admin workspace"
    **What it proves:** AVD and FSLogix are used as part of a secure administrative workspace pattern.

    **Why it matters:** Privileged access should be separated from unmanaged daily-driver access. A secure workspace pattern supports private platform administration and controlled access paths.

    **Where to inspect:**

    - [O5 evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5){ target="_blank" }
    - [Private platform and secure workspace story](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/04-private-platform-secure-workspace.md){ target="_blank" }

    **Reviewer takeaway:** The project treats administration paths as part of the security architecture.

---

## O6: Governed AI-assisted CloudOps

???+ info "O6 AI operations enclave"
    **What it proves:** O6 defines a governed AI-assisted operations boundary with policy-mediated tool use, logging, Kubernetes support context, and human review.

    **Why it matters:** AI in infrastructure is risky when it can act without constraints. O6 frames AI as an assistant inside a governed workflow, not an autonomous infrastructure operator.

    **Where to inspect:**

    - [AI Operations Enclave page](ai-operations/index.md)
    - [O6 evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6){ target="_blank" }
    - [O6 capability story](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/05-ai-operations-enclave.md){ target="_blank" }

    **Reviewer takeaway:** The candidate is positioned at the intersection of platform engineering, AI governance, and operational safety.

???+ info "Companion implementation: local-ai-lab-infra"
    **What it proves:** The companion project implements a local-first multi-agent AI infrastructure workflow with local coding, cloud review options, RAG, tool permissions, validation hooks, and data-boundary controls.

    **Why it matters:** This makes O6 stronger than an architecture story alone. It shows practical implementation of governed AI-assisted infrastructure workflows.

    **Where to inspect:**

    - [Companion Project page](companion-project.md)
    - [local-ai-lab-infra repository](https://github.com/jrikobd-azaws/local-ai-lab-infra){ target="_blank" }

    **Reviewer takeaway:** The AI operations story includes both platform architecture and working lab/reference implementation.

---

## Release 3: Future direction

Release 3 is intentionally positioned as roadmap and platform evolution. It extends toward multi-cloud Kubernetes, GitOps, DevSecOps, observability, and resilience without presenting future work as already implemented.

- [Release 3 roadmap source](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release3){ target="_blank" }
- [Release 3 target roadmap diagram](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/diagrams/release3/release3-target-roadmap.png){ target="_blank" }

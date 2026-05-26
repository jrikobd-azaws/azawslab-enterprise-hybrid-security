# Azawslab Enterprise Hybrid Security Platform: A Case Study

## 1. Executive Summary

The Azawslab Enterprise Hybrid Security Platform is a flagship enterprise platform portfolio demonstrating a staged, evidence-backed transformation. It captures the comprehensive journey from a baseline hybrid Microsoft environment into a highly governed, multi-cloud platform driven by Infrastructure as Code, advanced security automation, and AI-assisted operations. Engineered with architectural precision, the portfolio showcases operationally validated implementations across identity, secure networking, private platform delivery, and a human-approved AI Operations Enclave.

---

## 2. Business Scenario

Modern enterprises rarely build greenfield platforms; they evolve legacy environments through controlled, risk-averse phases. The architectural challenge driving this portfolio was the transformation of a manually operated, small-enterprise hybrid Microsoft estate into a hardened, zero-trust cloud platform capable of secure workload hosting and multi-cloud transit.

The scenario demanded a measurable progression: securing the human and device edge first, establishing a rigid cloud governance and automation boundary second, and preparing the runway for multi-cloud Kubernetes and GitOps delivery third.

---

## 3. Starting Point

The starting point represented a typical fragmented hybrid setup: a legacy on-premises footprint requiring integration with Microsoft Entra ID and Microsoft 365. Identity synchronisation, endpoint management, and information protection were either siloed or manually configured, lacking a unified security posture, continuous compliance enforcement, and automated operational recovery mechanisms.

---

## 4. Release 1 Story — Hybrid Modern Workplace, Identity & Endpoint Security

**Status: Complete and evidenced**

Release 1 established the Hybrid Modern Workplace, Identity & Endpoint Security layer. Rather than treating synchronisation as a single event, identity was matured through controlled pilot scoping using Entra Connect Sync, Conditional Access, and MFA.

The endpoint boundary was secured via Intune across corporate, BYOD, Linux, and iOS scenarios, strictly enforced by compliance policies, Defender Antivirus, Attack Surface Reduction, and BitLocker. Information protection was operationalised through Purview sensitivity labels and DLP policy tips. Advanced validation further extended the baseline with zero-touch Windows Autopilot provisioning, automated identity lifecycle workflows, Windows LAPS credential retrieval, and Microsoft Graph API operational tooling.

*Diagram placeholder — Release 1 end-state hybrid identity and endpoint architecture.*

---

## 5. Release 2 Story — Azure Platform Engineering, Security, Automation, Private Platform & AI Operations

**Status: Implemented and evidenced**

Release 2 expanded the foundation into Azure Platform Engineering, Security, Automation, Private Platform, and AI Operations. Operations shifted from portal-based configurations to a strict Git-driven IaC delivery model using Terraform, Ansible, and GitHub Actions OIDC.

A secure multi-cloud networking and inspection architecture was deployed, combining Azure Firewall for controlled egress, FortiGate NVAs for inspection and hybrid traffic control, and VyOS/Cisco routing patterns over IPSec and BGP. The management plane was overhauled through an AWX automation control plane (A2) with runtime secrets retrieved dynamically from Azure Key Vault and AWS SSM, eliminating credential sprawl. Workload modernisation was achieved through Private AKS (O4), including private access paths, Azure Firewall egress validation, pod-level validation, managed monitoring, and controlled network boundaries, alongside Azure Virtual Desktop with FSLogix (O5).

### 5.1 O6 AI Operations Enclave

The O6 AI Operations Enclave is a fully implemented, human-approved AI-assisted CloudOps pattern. It spans two complementary repositories:

**`azawslab-enterprise-hybrid-security` (primary portfolio)**  
The main repository holds the enclave's operational evidence under `docs/release2/evidence/O6/`. This includes live validation artifacts: MCP gateway configuration (`o6-mcp-gateway-live.json`), policy decision logs (`o6-mcp-policy-decision-logs.json`), agent-specific policy enforcement records (FinOps, Runbook, SecOps), network policy verification, namespace lifecycle management, and post-cleanup resource validation. Every piece of evidence proves that the AI enclave was deployed, governed, and operationally verified — not merely described.

**`local-ai-lab-infra` (companion execution environment)**  
The companion project provides the multi-agent AI runtime that powers the O6 pattern. It is a local-first, LangGraph-orchestrated pipeline with five specialised agents:

| Agent | Role | Runtime |
|---|---|---|
| Architect | Topology design and documentation analysis | Cloud API or local |
| Coder | IaC generation (Terraform/Ansible) | Local Ollama (DeepSeek Coder 6.7B) |
| SecOps | Security posture review | Cloud API or local |
| FinOps | Cost estimation and budget checks | Cloud API or local |
| GitOps | Summaries, commit text, PR descriptions | Cloud API or local |

The security model is **deny-by-default**: every agent receives only the tools explicitly permitted in `configs/project_config.yaml`. Destructive or write-capable tools must be explicitly enabled per project. The orchestrator validates every tool call before execution. Code generation runs locally through DeepSeek Coder on Ollama — sensitive IaC never leaves the machine unless cloud review is explicitly configured with sanitised summaries.

Critically, the O6 boundary enforces a strict architectural separation: AI agents perform analysis, generate recommendations, and produce runbook drafts via MCP and RAG (Chroma vector DB), but **execution authority remains decoupled and gated behind human approval and the Terraform/AWX CI/CD pipelines**. AI does not mutate infrastructure autonomously. This is the hallmark of senior-level AI risk management.

Together, the two repositories form a complete story: `local-ai-lab-infra` is the engine; `azawslab-enterprise-hybrid-security` is the evidence vault that proves the engine was operated under governance.

*Diagram placeholder — O6 AI Operations Enclave: multi-agent pipeline with human approval gate and evidence capture.*

*Diagram placeholder — Release 2 transit and platform automation architecture.*

---

## 6. Release 3 Platform Evolution — Multi-Cloud Kubernetes, GitOps & DevSecOps

**Status: Roadmap / platform evolution**

Release 3 is presented as a deliberate platform evolution path, directly extending the governance, networking, security, and automation patterns proven in Release 2. This evolutionary phase targets AKS and EKS integrations managed via Argo CD. The planned architecture focuses on CI/CD quality gates, unit testing, SAST, DAST, automated image scanning with Trivy, strict policy gates through OPA/Gatekeeper, protected ingress through WAF and ingress controls, mTLS-enabled service communication through Istio, and deep observability through Prometheus, Grafana, and Loki, supported by resilience validation.

*Diagram placeholder — Release 3 target state: AKS, EKS, Argo CD, DevSecOps toolchain.*

---

## 7. Six-Track Engineering Journey

The portfolio is executed across six distinct capability tracks to manage complexity and isolate operational lifecycles:

| Track | Capability | Release | What It Proves |
|---|---|---|---|
| 1 | Hybrid Modern Workplace, Identity & Endpoint Security | Release 1 | Centralised identity, endpoint control, information protection, and operational recovery |
| 2 | Azure Landing Zone, IaC and Governance | Release 2 | Declarative cloud infrastructure, CI/CD-driven delivery, policy-enforced governance |
| 3 | Secure Hybrid and Multi-Cloud Networking | Release 2 | Multi-cloud transit, enterprise firewall and inspection integration, dynamic BGP routing, and segmentation |
| 4 | Automation, SecOps and Resilience | Release 2 | Zero-hardcoded-secret automation, AWX control plane, backup, monitoring, operational runbooks |
| 5 | Private Platform, Secure Workspace and AI Operations | Release 2 | Private AKS (private access, pod-level validation, Azure Firewall egress), AVD with FSLogix, and a governed, human-approved AI CloudOps enclave |
| 6 | Multi-Cloud Kubernetes, GitOps and DevSecOps | Release 3 | AKS, EKS, Argo CD, CI/CD quality gates, unit testing, SAST, DAST, image scanning, policy gates, protected ingress, observability, resilience validation (roadmap) |

---

## 8. Key Engineering Decisions

These decisions reflect deliberate architectural judgement, not defaults.

- **Staged delivery:** Designing the platform sequentially — Identity → Infrastructure → Automation → AI/Workloads — reduced blast radius and proved the ability to execute complex migrations systematically.
- **Zero-trust automation boundaries:** Moving from localised scripts to an AWX control plane (A2) ensured runtime secrets are retrieved dynamically from Azure Key Vault and AWS SSM, eliminating credential sprawl.
- **Human-in-the-loop AI:** The O6 AI Operations Enclave isolates AI analysis from direct infrastructure mutation. Insights are generated via local RAG and MCP, but execution remains securely gated by Terraform and Ansible CI/CD pipelines requiring human approval.
- **Terraform over Bicep or ARM:** Terraform was chosen for multi-cloud portability, enabling the same IaC approach across Azure and AWS without vendor lock-in.
- **OIDC over static credentials:** All CI/CD pipelines authenticate to Azure and AWS via OpenID Connect, eliminating stored service principal secrets.
- **Private AKS, not public API:** Deploying AKS with no public API endpoint eliminates a significant attack surface. All operations happen through private networking.
- **Branch office namespace isolation:** The `br1.azawslab.co.uk` namespace was established to cleanly delineate branch office identities and multi-cloud boundaries without polluting the core hybrid domain. It is a network namespace, not a Git branch.
- **Release 3 as roadmap, not concurrent:** By deferring Kubernetes, GitOps, and DevSecOps to a future phase, the portfolio demonstrates the ability to sequence complex platform work without over-reaching.

---

## 9. Evidence That Matters

The portfolio is anchored in verifiable artifacts: screenshots, CLI outputs, Terraform evidence, AWX job logs, policy records, validation files, and implementation notes.

- **Release 1 (UI & Narrative):** Verified via a comprehensive screenshot hub (`screenshots/release1/`) capturing Intune compliance, Autopilot ESP stages, DLP policy enforcement, Exchange hybrid mail flow, and operational recovery scenarios.
- **Release 2 (CLI & Engineering):** Verified via detailed execution logs, Terraform plan/apply outputs, AWX job stdout, and KQL queries located in `docs/release2/evidence/`.
- **O6 AI Operations Enclave:** Verified via live validation artifacts in `docs/release2/evidence/O6/`, including MCP gateway configuration, agent policy enforcement logs, network policy verification, namespace lifecycle management, and post-cleanup validation. The companion `local-ai-lab-infra` repository provides the executable multi-agent pipeline that generated these results.
- `proof link to be inserted` for any evidence path not yet confirmed.

---

## 10. What This Demonstrates for Target Roles

- **For Cloud Platform Engineers:** Demonstrates an architectural mindset capable of designing governed Azure landing zones, managing complex IaC state with remote backends and locking, and delivering private container platforms with no public API exposure.
- **For Hybrid Infrastructure Engineers:** Proves the ability to bridge legacy on-premises environments (Active Directory, Hyper-V, VyOS) with modern cloud endpoints via IPSec, BGP, and Entra Connect, while maintaining clean namespace boundaries through `br1.azawslab.co.uk`.
- **For Cloud Security Architects:** Highlights a zero-trust methodology, showcasing identity lifecycle automation, FortiGate and Azure Firewall multi-cloud inspection, Defender/Sentinel integration, credential-less automation pipelines, and governed AI operations with human-in-the-loop enforcement.
- **For Modern Workplace Engineers:** Validates deep expertise in Intune, Windows Autopilot, Purview information protection, and operational recovery scenarios, all integrated into a broader platform security story — not treated as a silo.

---

## 11. Production-Style Hardening Path

The portfolio avoids sandbox defaults in favour of production-style hardening:

- **Secrets management:** No secrets in code. Azure Key Vault and AWS SSM provide runtime values to AWX and pipelines.
- **Private endpoints:** Storage, Key Vault, and container registry are only accessible over private networks.
- **CI/CD guardrails:** GitHub Actions workflows are protected by branch policies; Terraform plans are reviewed before apply.
- **Workload isolation:** Azure management plane separated from workloads; workload VMs have no public IPs.
- **Policy enforcement:** Azure Policy deny rules (location and SKU restrictions) prevent configuration drift.
- **AI safety:** The O6 enclave enforces deny-by-default tool access, per-project isolation, local code generation for sensitive IaC, configurable cloud review with sanitised summaries, and human approval gates before any infrastructure mutation.
- **Backup and recovery:** Automated runbooks and Recovery Services vaults provide a last line of defence.

Future hardening (Release 3) will extend these patterns into container image signing, network policy enforcement at pod level, ingress gateway mTLS, and chaos-engineered resilience testing.

---

## 12. Interview Talking Points

### Senior Cloud Platform Engineer

**Q:** *"How do you handle state management and module reusability when scaling an Azure landing zone?"*

**Response strategy:** Detail the Phase P2a execution. Explain the decision to split Terraform state boundaries — Governance vs. Platform-Shared vs. Workloads — to align lifecycle boundaries and reduce destroy risk. Reference the GitHub Actions OIDC integration for secretless pipeline execution and the use of remote state with locking in Azure Storage. Evidence: Terraform plan/apply outputs and pipeline run logs in `docs/release2/evidence/`.

---

### Hybrid Cloud / Infrastructure Engineer

**Q:** *"Explain your approach to routing traffic between an on-premises edge, an Azure Hub, and an AWS branch."*

**Response strategy:** Walk through the O3b/O3c design. Discuss the use of VyOS for the on-prem edge, Azure VPN Gateway as the transit hub, and Cisco 8000V in AWS. Highlight the validation of segmented BGP route control, ensuring trusted subnets propagated while DMZ subnets were intentionally withheld. Reference the `br1.azawslab.co.uk` namespace as the branch office boundary that cleanly isolates on-premises identity from cloud routing domains. Evidence: routing tables, firewall policy screenshots, and CLI validation outputs in the networking evidence folders.

---

### Cloud Security Architect

**Q:** *"How do you securely integrate AI tooling into CloudOps without exposing the infrastructure to autonomous mutation?"*

**Response strategy:** Reference the O6 AI Operations Enclave's dual-repository architecture. Explain the boundary: the `local-ai-lab-infra` companion project runs a LangGraph multi-agent pipeline where the Coder agent generates IaC locally through DeepSeek Coder on Ollama — sensitive code never leaves the machine. Cloud agents (Architect, SecOps, FinOps, GitOps) receive only sanitised summaries unless explicitly configured otherwise. All tool access is deny-by-default, validated per project in `project_config.yaml`. Critically, AI-generated recommendations are never auto-applied: execution authority remains strictly decoupled, requiring human approval and CI/CD pipeline execution through Terraform and AWX. Evidence: MCP gateway logs, policy decision logs, and agent enforcement records in `docs/release2/evidence/O6/`.

---

### Modern Workplace / Endpoint Engineer

**Q:** *"How do you handle endpoint compliance failures and operational recovery in a remote-first environment?"*

**Response strategy:** Point to the Release 1 operational recovery scenarios. Discuss the induced trust-break scenario: retrieving the BitLocker key from Entra, rebuilding the device, executing Graph PowerShell scripts to clean up stale records, and validating the restored Intune compliance state. Emphasise that endpoint state directly gates cloud access through Conditional Access policies — a device that fails compliance cannot reach the Azure platform. Evidence: Intune policy screenshots, Autopilot deployment status, and endpoint compliance reports in `screenshots/release1/`.
# Platform Architecture Overview — Azawslab Enterprise Hybrid Security Platform

## 1. Platform Evolution Summary

The Azawslab platform is a staged architectural evolution across three releases. Each release builds on the proven security, governance, and automation layers of the previous one.

```
Identity → Platform Engineering → Multi-Cloud K8s/GitOps
 (Release 1)    (Release 2)          (Release 3)
```

The sequence reflects real-world enterprise priorities: control the human and device edge, harden the cloud foundation, automate operations, introduce governed AI assistance, and prepare for multi-cloud Kubernetes delivery.

---

## 2. Starting Point

The starting state was a typical small-enterprise hybrid Microsoft environment: on-premises Active Directory synchronised with Microsoft 365, basic services (Exchange Online, SharePoint, Teams), limited endpoint management, no cloud governance, manual server deployments, no Infrastructure as Code, and a flat network. This baseline makes the architecture progression measurable: each release introduces a new control plane, validates it, and then uses it as the foundation for the next stage.

---

## 3. Release 1 Architecture — Hybrid Modern Workplace, Identity & Endpoint Security

Release 1 establishes the human and device security boundary.

**Identity Plane**

```
Active Directory (On-Premises)
        │
        ▼
  Entra Connect Sync
        │
        ▼
 Microsoft Entra ID
   │
   ├── Conditional Access / MFA / SSPR
   ├── Intune device compliance
   └── Microsoft 365 / Exchange / SharePoint / Teams
```

Entra Connect Sync provides the bridge. Entra ID consumes the identity and enriches it with Conditional Access, MFA, and self-service password reset. Intune evaluates device compliance; Entra Conditional Access uses that state to make access decisions. Microsoft 365 services are governed by the same identity and compliance signals.

**Endpoint Management Plane**

- Windows 10/11 devices enrolled via Autopilot.
- Intune compliance policies and configuration profiles enforce BitLocker, Defender Antivirus, ASR rules.
- Purview sensitivity labels and DLP policies protect data across endpoints and cloud services.

All components are evidenced through screenshots in `screenshots/release1/`.

*Diagram placeholder — Detailed Release 1 architecture with Entra Connect Sync flow, Conditional Access rules, and endpoint protection layers.*

---

## 4. Release 2 Architecture — Azure Platform Engineering, Security, Automation, Private Platform & AI Operations

Release 2 is the architectural core: governed landing zone, multi-cloud networking, automation, private workloads, secure admin workspace, and an AI Operations Enclave.

### 4.1 Azure Landing Zone & Governance

- Management Group hierarchy for subscription organisation.
- Azure Policy deny rules restrict regions, VM SKUs, public IPs.
- RBAC with custom roles for least-privilege deployment.
- Terraform + GitHub Actions OIDC: all infrastructure as code, deployed via OIDC-authenticated pipelines. Remote state in Azure Storage with locking.

### 4.2 Multi-Cloud Networking & Inspection

```text
Azure Hub VNet
├── Azure Firewall
│   └── controlled egress / platform inspection
├── FortiGate NVA
│   └── hybrid and multi-cloud inspection
├── VPN Gateway
│   └── IPSec/BGP to branch and AWS
└── Spoke VNets
    ├── Private AKS (O4)
    ├── AVD / FSLogix (O5)
    └── Private endpoints
```

- Azure Firewall handles east-west and egress inspection.
- FortiGate NVAs provide advanced threat protection and hybrid traffic control.
- BGP (via VyOS and Cisco CSR) dynamically routes between Azure, AWS, and the branch namespace `br1.azawslab.co.uk`.

*Diagram placeholder — Release 2 multi-cloud networking with hub, spokes, and inspection devices.*

### 4.3 Automation & SecOps

- **Kubernetes-hosted AWX automation control plane** (A2): the single point of operational authority.
- GitHub Actions authenticates through OIDC for Terraform delivery. AWX retrieves runtime secrets from Azure Key Vault and AWS SSM, then executes controlled automation against approved targets.
- After approval, the controlled GitHub Actions apply stage runs — no auto-apply.
- Ansible playbooks perform network validation, backups, compliance checks.
- Monitoring via Azure Monitor, Log Analytics, and custom dashboards.

*Diagram placeholder — Automation architecture: CI/CD pipeline, AWX control plane, secret stores, managed nodes.*

### 4.4 O5 Secure Workspace — Azure Virtual Desktop + FSLogix

O5 is a **secure admin/developer workspace** used for controlled platform operations. It is not a generic virtual desktop feature; it is the governed access layer for Release 2 operations.

**Architecture components:**

- **Personal / single-user AVD model** — dedicated session host for platform operators.
- **AVD host pool, workspace, and desktop application group** — standard AVD control plane objects.
- **Session host** — runs in the AVD spoke VNet, with **no public IP**.
- **FSLogix profile container** — stores user profile on Azure Files, providing persistence across sessions.
- **Azure Files storage** — accessed over a **private endpoint**, with private DNS integration ensuring the FSLogix path resolves inside the VNet.
- **Controlled route table** — outbound traffic from the AVD host flows through Azure Firewall for egress control.
- **Admin/dev toolchain** — PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, Helm. All operational work is performed through this controlled environment.

**Why this matters architecturally:**

O5 reduces unmanaged workstation dependency. Privileged tools and access tokens are contained within a governed, private workspace. The FSLogix profile persists user state, but the session host itself can be re-imaged without losing tool configurations or command history.

**O5 operational flow:**

```text
Engineer
   │
   ▼
Entra ID / Conditional Access (device compliance required)
   │
   ▼
O5 AVD secure admin/dev workspace
   │
   +── PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, Helm
   │
   ▼
AWX automation control plane
   │
   ├── Private AKS (O4)
   └── Azure / AWS operational tooling
```

**Region decision:**

The O1–O4 platform is governed around Norway East / Norway West. AVD metadata and workspace planning had to respect Microsoft Desktop Virtualization regional availability. The final O5 model allows **North Europe** as the primary AVD secure workspace region and **West Europe** as alternate / future resiliency region, while preserving Norway East / Norway West for the existing platform and paired-region governance. This demonstrates senior architectural judgement: Azure service constraints, governance policy, paired-region design, and state-boundary discipline were all factored into the decision.

*Diagram placeholder — O5 secure workspace architecture: AVD host pool, private FSLogix path, toolchain, and access flow to AWX/AKS.*

### 4.5 AI Operations Enclave (O6)

The O6 enclave introduces governed AI-assisted CloudOps across two repositories:

- **Primary portfolio:** `docs/release2/evidence/O6/` holds MCP gateway configuration, policy decision logs, agent enforcement records, network policy verification, post-cleanup validation.
- **Companion project (`local-ai-lab-infra`):** Multi-agent LangGraph pipeline with deny-by-default tool permissions. Coder agent runs locally via Ollama (DeepSeek Coder 6.7B) — sensitive IaC never leaves the host. Cloud agents receive sanitised summaries unless configured otherwise.

**Architectural boundary:** AI agents analyse, recommend, draft runbooks; execution is gated behind human approval and the Terraform/AWX CI/CD pipelines. No autonomous mutation.

*Diagram placeholder — O6 AI Operations Enclave: multi-agent pipeline with human approval gate and evidence capture.*

---

## 5. Release 3 Target Direction — Multi-Cloud Kubernetes, GitOps & DevSecOps

Release 3 extends the platform into workload delivery governance: source control, CI/CD quality gates, unit testing, SAST, DAST, image scanning, signed image promotion, GitOps reconciliation, policy-as-code admission control, protected ingress, service-to-service encryption, observability, and resilience validation.

- **AKS & EKS** managed via Argo CD; cluster configs, apps, and policies in Git.
- **Image promotion gates:** Trivy scans, signed images, OPA/Gatekeeper admission.
- **Protected ingress:** Istio mTLS, NGINX/WAF, TLS termination.
- **Observability:** Prometheus, Grafana, Loki, OpenTelemetry tracing.
- **GitOps drift detection:** Argo CD continuously reconciles desired vs actual state.

```text
Git Repos (Apps, Infra, Policies)
        │
        ▼
     Argo CD
        │
   ┌────┴────┐
   ▼         ▼
 AKS       EKS
 (Istio,   (Istio,
  OPA,      OPA,
  Trivy)    Trivy)
        │
        ▼
 Observability Stack
 (Prometheus, Grafana, Loki)
```

*Diagram placeholder — Release 3 target multi-cloud Kubernetes and DevSecOps architecture.*

---

## 6. Trust Boundaries

- **Identity Boundary:** Entra ID + Conditional Access forms the outer perimeter. Only compliant, managed devices with MFA may access platform layers.
- **Operator Access Boundary:** O5 AVD provides a controlled admin/developer workspace, reducing unmanaged workstation dependency and keeping privileged tools inside a governed access path.
- **Network Boundary:** Azure Firewall and FortiGate NVAs separate hub, spokes, and external connections; east-west traffic is inspected.
- **Automation Boundary:** AWX is the only entity executing privileged operations. Runtime credentials never exposed.
- **AI Operations Boundary:** O6 isolates AI analysis from execution. Human approval required; CI/CD pipelines gate any mutation.
- **Namespace Boundary:** `br1.azawslab.co.uk` isolates branch identity and routing from the core domain.
- **Evidence Boundary:** Implementation proof is separated from narrative documentation. Screenshots, CLI outputs, pipeline logs, policy records, and validation artifacts are stored in evidence folders so architectural claims can be reviewed independently.

*Diagram placeholder — Trust boundary map overlay on Release 2 architecture.*

---

## 7. Network and Identity Flow

**Identity flow:**

1. Engineer authenticates to Entra ID (MFA, device compliance checked via Intune).
2. Conditional Access grants access to AVD, Azure portal, or workload endpoints.
3. GitHub Actions authenticates via OIDC for Terraform delivery.
4. AWX retrieves runtime secrets from Azure Key Vault and AWS SSM, authenticates to managed nodes.

**Network flow (on-premises to workload):**

1. Traffic enters via IPSec tunnel to Azure VPN Gateway.
2. Hub VNet routes traffic through Azure Firewall for egress/ingress inspection.
3. Spoke VNet receives approved traffic; workload endpoints (Private AKS, AVD) have no public IPs.
4. Outbound return traffic follows reverse path.
5. BGP dynamically updates routes across Azure, AWS, and `br1.azawslab.co.uk`.

*Diagram placeholder — End-to-end network and identity flow sequence diagram.*

---

## 8. Automation and Operations Flow

1. **Infrastructure Change:** Engineer pushes Terraform change; GitHub Actions runs plan via OIDC. After review and approval, controlled apply stage executes.
2. **Configuration Drift:** AWX periodically runs Ansible playbooks; secrets fetched from Key Vault/SSM at runtime.
3. **AI-Assisted Operations:** O6 pipeline invoked via `local-ai-lab-infra`. AI drafts runbook or IaC suggestion; human reviews, then commits and deploys through standard CI/CD — never auto-applied.
4. **Monitoring & Alerting:** Azure Monitor/Log Analytics collect signals; alerts trigger automated responses or engineer notification.

*Diagram placeholder — Operations flow from Git commit through AWX execution and AI-assisted review.*

---

## 9. Evidence and Diagram Index

- **Release 1:** `screenshots/release1/` — identity sync, Intune policies, Autopilot, Purview, DLP, recovery scenarios.
- **Release 2:**
  - `docs/release2/evidence/` — Terraform plan/apply logs, AWX job outputs, network validation, AKS evidence.
  - **O5 Secure Workspace Evidence:** `docs/release2/evidence/O5/`
    - governance paired-region validation
    - provider / SKU / network preflight
    - AVD region decision
    - FSLogix storage and private endpoint readiness
    - `platform-avd` state-boundary evidence
    - `proof link to be inserted`
  - **O6 AI Operations Enclave:** `docs/release2/evidence/O6/` — MCP gateway, policy logs, agent enforcement records, network policy, post-cleanup validation.
- **Release 3:** Roadmap / platform evolution evidence position — target architecture, planned control model, and proof placeholders to be replaced as implementation evidence is produced.

*Diagram placeholder — Visual evidence map linking architecture components to evidence folders.*

---

## 10. Architecture Reader Path

| Reader | Start with | Then |
|---|---|---|
| Platform Architect | Sections 1, 4, 6 | Sections 2, 3 for baseline context |
| Cloud Network Engineer | Sections 4.2, 7 | Section 9 for routing evidence |
| Security Architect | Sections 3, 4.2, 4.5, 6 | Section 9 for zero-trust controls |
| DevOps/SRE | Sections 4.3, 4.4, 8 | Sections 5 for future GitOps direction |
| AI/ML Engineer | Sections 4.5, 6 (AI boundary) | O6 evidence and companion project |
| Recruiter/Hiring Manager | Sections 1, 10 | README.md for high-level story |

*Diagram placeholder — Portfolio architecture hero overview.*
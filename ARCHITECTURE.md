# Platform Architecture Overview â€” Azawslab Enterprise Hybrid Security Platform

## 1. Platform Evolution Summary

The Azawslab platform is a staged architectural evolution across three releases. Each release builds on the proven security, governance, and automation layers of the previous one.

```
Identity â†’ Platform Engineering â†’ Multi-Cloud K8s/GitOps
 (Release 1)    (Release 2)          (Release 3)
```

The sequence reflects real-world enterprise priorities: control the human and device edge, harden the cloud foundation, automate operations, introduce governed AI assistance, and prepare for multi-cloud Kubernetes delivery.

---

## 2. Starting Point

The starting state was a typical small-enterprise hybrid Microsoft environment: on-premises Active Directory synchronised with Microsoft 365, basic services (Exchange Online, SharePoint, Teams), limited endpoint management, no cloud governance, manual server deployments, no Infrastructure as Code, and a flat network. This baseline makes the architecture progression measurable: each release introduces a new control plane, validates it, and then uses it as the foundation for the next stage.

---

## 3. Release 1 Architecture â€” Hybrid Modern Workplace, Identity & Endpoint Security

Release 1 establishes the human and device security boundary.

**Identity Plane**

```text
Active Directory (On-Premises)
        â”‚
        â–¼
  Entra Connect Sync
        â”‚
        â–¼
 Microsoft Entra ID
   â”‚
   â”œâ”€â”€ Conditional Access / MFA / SSPR
   â”œâ”€â”€ Intune device compliance
   â””â”€â”€ Microsoft 365 / Exchange / SharePoint / Teams
```

Entra Connect Sync provides the bridge. Entra ID consumes the identity and enriches it with Conditional Access, MFA, and self-service password reset. Intune evaluates device compliance; Entra Conditional Access uses that state to make access decisions. Microsoft 365 services are governed by the same identity and compliance signals.

**Endpoint Management Plane**

- Windows 10/11 devices enrolled via Autopilot.
- Intune compliance policies and configuration profiles enforce BitLocker, Defender Antivirus, ASR rules.
- Purview sensitivity labels and DLP policies protect data across endpoints and cloud services.

All components are evidenced through screenshots in `screenshots/release1/`.

*Diagram placeholder â€” Detailed Release 1 architecture with Entra Connect Sync flow, Conditional Access rules, and endpoint protection layers.*

---

## 4. Release 2 Architecture â€” Azure Platform Engineering, Security, Automation, Private Platform & AI Operations

Release 2 is the architectural core: governed landing zone, multi-cloud networking, automation, private workloads, secure admin workspace, and an AI Operations Enclave.

### 4.1 Azure Landing Zone & Governance

- Management Group hierarchy for subscription organisation.
- Azure Policy deny rules restrict regions, VM SKUs, public IPs.
- RBAC with custom roles for least-privilege deployment.
- Terraform + GitHub Actions OIDC: all infrastructure as code, deployed via OIDC-authenticated pipelines. Remote state in Azure Storage with locking.

### 4.2 Multi-Cloud Networking & Inspection

```text
Azure Hub VNet
â”œâ”€â”€ Azure Firewall
â”‚   â””â”€â”€ controlled egress / platform inspection
â”œâ”€â”€ FortiGate NVA
â”‚   â””â”€â”€ hybrid and multi-cloud inspection
â”œâ”€â”€ VPN Gateway
â”‚   â””â”€â”€ IPSec/BGP to branch and AWS
â””â”€â”€ Spoke VNets
    â”œâ”€â”€ Private AKS (O4)
    â”œâ”€â”€ AVD / FSLogix (O5)
    â””â”€â”€ Private endpoints
```

- Azure Firewall handles east-west and egress inspection.
- FortiGate NVAs provide advanced threat protection and hybrid traffic control.
- BGP (via VyOS and Cisco CSR) dynamically routes between Azure, AWS, and the branch namespace `br1.azawslab.co.uk`.

*Diagram placeholder â€” Release 2 multi-cloud networking with hub, spokes, and inspection devices.*

### 4.3 Automation & SecOps

- **Kubernetes-hosted AWX automation control plane** (A2): the single point of operational authority.
- GitHub Actions authenticates through OIDC for Terraform delivery. AWX retrieves runtime secrets from Azure Key Vault and AWS SSM, then executes controlled automation against approved targets.
- After review and approval, infrastructure changes are applied through the controlled GitHub Actions workflow, preserving the repository's GitHub Actions controlled-apply model.
- Ansible playbooks perform network validation, backups, compliance checks.
- Monitoring via Azure Monitor, Log Analytics, and custom dashboards.

*Diagram placeholder â€” Automation architecture: CI/CD pipeline, AWX control plane, secret stores, managed nodes.*

### 4.4 O4 Private AKS â€” Private Platform Runtime

O4 delivers the private container platform for Release 2 workloads. The AKS cluster is deployed with no public API server, ensuring all control-plane operations happen over private endpoints.

**Architecture components:**

- Private AKS cluster with private API access pattern.
- Azure Container Registry (ACR) for workload images, accessed over private endpoints.
- Egress traffic from AKS pods flows through Azure Firewall for inspection â€” validated via firewall egress tests and pod-level egress checks.
- Internal applications served from the cluster are accessed through private network paths; browser validation confirms end-to-end reachability.
- Managed Prometheus and Grafana provide monitoring and dashboarding, with dedicated dashboards for private-AKS health.
- AWX control plane readiness and tier-execution evidence confirm the automation platform can manage AKS workloads.

*Diagram placeholder â€” O4 Private AKS: private API access, egress through Azure Firewall, managed monitoring, AWX integration.*

### 4.5 O5 Secure Workspace â€” Azure Virtual Desktop + FSLogix

O5 is the secure admin/developer workspace for Release 2 platform operations. It is not a generic virtual desktop; it is the governed access layer for AWX, AKS, Terraform, and cloud management.

**Architecture components:**

- Personal/single-user AVD host pool, workspace, and desktop application group.
- Session host runs in the AVD spoke VNet with **no public IP**.
- FSLogix profile container stores user state on Azure Files, providing profile persistence across sessions.
- Azure Files is accessed over a **private endpoint**, with private DNS integration ensuring the FSLogix path resolves inside the VNet.
- Controlled route table routes outbound traffic from the AVD host through Azure Firewall.
- Admin/dev toolchain includes PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, and Helm â€” all operations executed from this controlled environment.

**Region decision (evidence-backed):**

The O5 governance validation confirms **Norway East** as the primary O5 region, with **Norway West** enabled for paired-region backup, DR, and geo-redundant service requirements. The design also validates Microsoft Desktop Virtualization provider readiness, Windows 11 image availability, VM SKU/quota readiness, non-overlapping AVD VNet CIDR planning, and FSLogix private endpoint prerequisites. This demonstrates senior architectural judgement: Azure service regional constraints, governance policy, paired-region design, and state-boundary discipline were all factored into the deployment model.

**Operational flow:**

```text
Engineer
   â”‚
   â–¼
Entra ID / Conditional Access (device compliance required)
   â”‚
   â–¼
O5 AVD secure admin/dev workspace
   â”‚
   +â”€â”€ PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, Helm
   â”‚
   â–¼
AWX automation control plane
   â”‚
   â”œâ”€â”€ Private AKS (O4)
   â””â”€â”€ Azure / AWS operational tooling
```

O5 reduces unmanaged workstation dependency by containing privileged tools and access tokens within a governed, private workspace. The FSLogix profile persists user state independently, so the session host can be re-imaged without losing tool configurations or command history.

*Diagram placeholder â€” O5 secure workspace architecture: AVD host pool, private FSLogix path, toolchain, and access flow to AWX/AKS.*

### 4.6 O6 AI Operations Enclave

The O6 enclave introduces a governed AI-assisted CloudOps pattern across two repositories:

- **Primary portfolio:** `docs/release2/evidence/O6/` holds MCP gateway configuration, policy decision logs, agent enforcement records, network policy verification, and post-cleanup validation.
- **Companion project (`local-ai-lab-infra`):** Multi-agent LangGraph pipeline with deny-by-default tool permissions. The Coder agent runs locally via Ollama (DeepSeek Coder 6.7B) â€” sensitive IaC never leaves the host. Cloud agents receive sanitised summaries unless configured otherwise.

**Architectural boundary:** AI agents analyse, recommend, and draft runbooks, but execution is gated behind human approval and the Terraform/AWX CI/CD pipelines. No autonomous mutation.

*Diagram placeholder â€” O6 AI Operations Enclave: multi-agent pipeline with human approval gate and evidence capture.*

---

## 5. Release 3 Target Direction â€” Multi-Cloud Kubernetes, GitOps & DevSecOps

Release 3 extends the platform into workload delivery governance: source control, CI/CD quality gates, unit testing, SAST, DAST, image scanning, signed image promotion, GitOps reconciliation, policy-as-code admission control, protected ingress, service-to-service encryption, observability, and resilience validation.

- AKS and EKS managed via Argo CD; cluster configs, apps, and policies defined in Git.
- Trivy for image scanning; signed images enforced by OPA/Gatekeeper admission policies.
- Istio service mesh for mTLS-encrypted communication; NGINX/WAF for ingress protection.
- Prometheus, Grafana, and Loki for observability; OpenTelemetry for distributed tracing.
- GitOps drift detection continuously reconciles desired vs actual state.

```text
Git Repos (Apps, Infra, Policies)
        â”‚
        â–¼
     Argo CD
        â”‚
   â”Œâ”€â”€â”€â”€â”´â”€â”€â”€â”€â”
   â–¼         â–¼
 AKS       EKS
 (Istio,   (Istio,
  OPA,      OPA,
  Trivy)    Trivy)
        â”‚
        â–¼
 Observability Stack
 (Prometheus, Grafana, Loki)
```

*Diagram placeholder â€” Release 3 target multi-cloud Kubernetes and DevSecOps architecture.*

---

## 6. Trust Boundaries

- **Identity Boundary:** Entra ID + Conditional Access forms the outer perimeter. Only compliant, managed devices with MFA may access platform layers.
- **Operator Access Boundary:** O5 AVD provides a controlled admin/developer workspace, reducing unmanaged workstation dependency and keeping privileged tools inside a governed access path.
- **Network Boundary:** Azure Firewall and FortiGate NVAs separate hub, spokes, and external connections; east-west traffic is inspected.
- **Automation Boundary:** AWX is the only entity executing privileged operations. Runtime credentials never exposed.
- **AI Operations Boundary:** O6 isolates AI analysis from execution. Human approval required; CI/CD pipelines gate any mutation.
- **Namespace Boundary:** `br1.azawslab.co.uk` isolates branch identity and routing from the core domain.
- **Evidence Boundary:** Implementation proof is separated from narrative documentation. Screenshots, CLI outputs, pipeline logs, policy records, and validation artifacts are stored in evidence folders so architectural claims can be reviewed independently.

*Diagram placeholder â€” Trust boundary map overlay on Release 2 architecture.*

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

*Diagram placeholder â€” End-to-end network and identity flow sequence diagram.*

---

## 8. Automation and Operations Flow

1. **Infrastructure Change:** Engineer pushes Terraform change; GitHub Actions runs plan via OIDC. After review and approval, the controlled apply stage executes.
2. **Configuration Drift:** AWX periodically runs Ansible playbooks; secrets fetched from Key Vault/SSM at runtime.
3. **AI-Assisted Operations:** O6 pipeline invoked via `local-ai-lab-infra`. AI drafts runbook or IaC suggestion; human reviews, then commits and deploys through standard CI/CD â€” never auto-applied.
4. **Monitoring & Alerting:** Azure Monitor/Log Analytics collect signals; alerts trigger automated responses or engineer notification.

*Diagram placeholder â€” Operations flow from Git commit through AWX execution and AI-assisted review.*

---

## 9. Evidence and Diagram Index

- **Release 1:** `screenshots/release1/` â€” identity sync, Intune policies, Autopilot, Purview, DLP, recovery scenarios.
- **Release 2:**
  - `docs/release2/evidence/` â€” Terraform plan/apply logs, AWX job outputs, network validation.
  - **O4 Private AKS Evidence:** `docs/release2/evidence/O4/`
    - AKS running-state evidence
    - Azure Firewall egress validation
    - pod-level egress validation
    - internal application validation
    - managed Prometheus/Grafana validation
    - AWX control plane readiness and tier execution evidence
    - `proof link to be inserted`
  - **O5 Secure Workspace Evidence:** `docs/release2/evidence/O5/`
    - governance paired-region validation (Norway East primary, Norway West paired)
    - preflight: provider registration, SKU/quota readiness, network overlap check, AVD endpoint dependency, FSLogix private endpoint prerequisites
    - `proof link to be inserted`
  - **O6 AI Operations Enclave:** `docs/release2/evidence/O6/` â€” MCP gateway, policy logs, agent enforcement records, network policy, post-cleanup validation.
- **Release 3:** Roadmap / platform evolution evidence position â€” target architecture, planned control model, and proof placeholders to be replaced as implementation evidence is produced.

*Diagram placeholder â€” Visual evidence map linking architecture components to evidence folders.*

---

## 10. Architecture Reader Path

| Reader | Start with | Then |
|---|---|---|
| Platform Architect | Sections 1, 4, 6 | Sections 2, 3 for baseline context |
| Cloud Network Engineer | Sections 4.2, 7 | Section 9 for routing evidence |
| Security Architect | Sections 3, 4.2, 4.6, 6 | Section 9 for zero-trust controls |
| DevOps/SRE | Sections 4.3, 4.4, 4.5, 8 | Section 5 for future GitOps direction |
| AI/ML Engineer | Sections 4.6, 6 (AI boundary) | O6 evidence and companion project |
| Recruiter/Hiring Manager | Sections 1, 10 | README.md for high-level story |

*Diagram placeholder â€” Portfolio architecture hero overview.*
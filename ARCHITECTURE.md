# Platform Architecture Overview - Azawslab Enterprise Hybrid Security Platform

> Part of: [Azawslab Enterprise Hybrid Security Platform](README.md)  
> Best for: technical reviewers, security architects, platform architects, and hiring managers  
> Purpose: architecture narrative, design boundaries, and platform evolution

## 1. Platform Evolution Summary

The Azawslab platform is a staged architectural evolution across three releases. Each release builds on the proven security, governance, and automation layers of the previous one.

```text
Identity -> Platform Engineering -> Multi-Cloud K8s/GitOps
 (Release 1)    (Release 2)          (Release 3)
```

The sequence reflects real-world enterprise priorities: control the human and device edge, harden the cloud foundation, automate operations, introduce governed AI assistance, and prepare for multi-cloud Kubernetes delivery.

![Azawslab staged platform journey](./diagrams/platform/hero-diagram.png)

---

## 2. Starting Point

The starting state was a typical small-enterprise hybrid Microsoft environment: on-premises Active Directory synchronized with Microsoft 365, basic services such as Exchange Online, SharePoint, and Teams, limited endpoint management, no cloud governance, manual server deployments, no Infrastructure as Code, and a flat network.

This baseline makes the architecture progression measurable: each release introduces a new control plane, validates it, and then uses it as the foundation for the next stage.

---

## 3. Release 1 Architecture - Hybrid Modern Workplace, Identity & Endpoint Security

Release 1 establishes the human and device security boundary.

**Identity Plane**

```text
Active Directory (On-Premises)
        |
        v
Entra Connect Sync
        |
        v
Microsoft Entra ID
   |
   +-- Conditional Access / MFA / SSPR
   +-- Intune device compliance
   +-- Microsoft 365 / Exchange / SharePoint / Teams
```

Entra Connect Sync provides the bridge. Entra ID consumes the identity and enriches it with Conditional Access, MFA, and self-service password reset. Intune evaluates device compliance; Entra Conditional Access uses that state to make access decisions. Microsoft 365 services are governed by the same identity and compliance signals.

**Endpoint Management Plane**

- Windows 10/11 devices enrolled via Autopilot.
- Intune compliance policies and configuration profiles enforce BitLocker, Defender Antivirus, and attack-surface-reduction controls.
- Purview sensitivity labels and DLP policies protect data across endpoints and cloud services.
- Recovery operations include BitLocker recovery, LAPS workflows, and Microsoft Graph operational scripts.

All components are evidenced through screenshots in `screenshots/release1/`.

![Release 1 detailed architecture](./diagrams/release1/release1-architecture.png)

---

## 4. Release 2 Architecture - Azure Platform Engineering, Security, Automation, Private Platform & AI Operations

Release 2 is the architectural core: governed landing zone, multi-cloud networking, automation, private workloads, secure admin workspace, and an AI Operations Enclave.

### 4.1 Azure Landing Zone & Governance

- Management Group hierarchy for subscription organization.
- Azure Policy deny rules restrict regions, VM SKUs, public IPs, and other governance-sensitive settings.
- RBAC with custom roles supports least-privilege deployment.
- Terraform and GitHub Actions OIDC provide secretless infrastructure delivery.
- Azure Terraform roots use Azure Storage remote state with locking.
- The AWS branch Terraform root uses AWS-backed state, including S3-based state storage.

![Release 2 landing zone IaC and governance](./diagrams/release2/landing-zone-iac-governance.png)

### 4.2 Multi-Cloud Networking & Inspection

```text
Azure Hub VNet
+-- Azure Firewall
|   +-- validated egress and Azure-native platform inspection paths
+-- FortiGate NVA
|   +-- hybrid and multi-cloud inspection paths
+-- VPN Gateway
|   +-- IPSec/BGP to branch and AWS
+-- Spoke VNets
    +-- Private AKS (O4)
    +-- AVD / FSLogix (O5)
    +-- Private endpoints
```

- Azure Firewall handles validated egress and Azure-native platform inspection paths.
- FortiGate NVAs provide advanced threat-protection and hybrid traffic-control paths.
- BGP, through VyOS and Cisco CSR, dynamically routes between Azure, AWS, and the branch namespace `br1.azawslab.co.uk`.
- `br1.azawslab.co.uk` is a network identity boundary, not a Git branch.

![Release 2 hybrid multi-cloud network security](./diagrams/release2/hybrid-multicloud-network-security.png)

### 4.3 Automation & SecOps

- Kubernetes-hosted AWX automation control plane (A2) provides governed Ansible execution.
- GitHub Actions authenticates through OIDC for Terraform delivery.
- AWX retrieves runtime secrets from Azure Key Vault and AWS SSM, then executes controlled automation against approved targets.
- Terraform changes are reviewed and applied through the GitHub Actions controlled-apply path.
- Ansible playbooks perform network validation, backups, and operational checks.
- Monitoring and security operations use Azure Monitor, Log Analytics, Microsoft Defender for Cloud, Sentinel, and Recovery Services Vault controls.

![Release 2 automation SecOps and resilience](./diagrams/release2/automation-secops-resilience.png)

### 4.4 O4 Private AKS - Private Platform Runtime

O4 delivers the private container platform for Release 2 workloads. The AKS cluster is deployed with no public API server, ensuring all control-plane operations happen over private endpoints.

**Architecture components:**

- Private AKS cluster with private API access pattern.
- Azure Container Registry for workload images, accessed through governed platform paths.
- Egress traffic from AKS pods flows through Azure Firewall for validated egress inspection; evidence includes firewall egress tests and pod-level egress checks.
- Internal applications are accessed through private network paths; browser validation confirms end-to-end reachability.
- Managed Prometheus and Grafana provide monitoring and dashboarding.
- AWX control plane readiness and tier-execution evidence confirm the automation platform can manage AKS workloads.

![Release 2 private platform and secure workspace](./diagrams/release2/private-platform-secure-workspace.png)

### 4.5 O5 Secure Workspace - Azure Virtual Desktop + FSLogix

O5 is the secure admin/developer workspace for Release 2 platform operations. It is not a generic virtual desktop; it is the governed access layer for AWX, AKS, Terraform, and cloud management.

**Architecture components:**

- Personal/single-user AVD host pool, workspace, and desktop application group.
- Session host runs in the AVD spoke VNet with no public IP.
- FSLogix profile container stores user state on Azure Files.
- Azure Files is accessed over a private endpoint, with private DNS integration ensuring the FSLogix path resolves inside the VNet.
- Controlled route table routes outbound traffic from the AVD host through Azure Firewall.
- Admin/dev toolchain includes PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, and Helm.

**Region decision:**

The O5 governance validation confirms Norway East as the primary O5 region, with Norway West enabled for paired-region backup, disaster recovery, and geo-redundant service requirements. The design also validates Microsoft Desktop Virtualization provider readiness, Windows 11 image availability, VM SKU/quota readiness, non-overlapping AVD VNet CIDR planning, and FSLogix private endpoint prerequisites.

**Operational flow:**

```text
Engineer
   |
   v
Entra ID / Conditional Access
   |
   v
O5 AVD secure admin/dev workspace
   |
   +-- PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, Helm
   |
   v
AWX automation control plane
   |
   +-- Private AKS (O4)
   +-- Azure / AWS operational tooling
```

O5 reduces unmanaged workstation dependency by containing privileged tools and access tokens within a governed, private workspace. The FSLogix profile persists user state independently, so the session host can be re-imaged without losing tool configurations or command history.

![Release 2 private platform and secure workspace](./diagrams/release2/private-platform-secure-workspace.png)

### 4.6 O6 AI Operations Enclave

The O6 enclave introduces a governed AI-assisted CloudOps pattern across the primary portfolio and the companion `local-ai-lab-infra` project.

- **Primary portfolio:** `docs/release2/evidence/O6/` holds MCP gateway configuration, policy decision logs, agent enforcement records, network policy verification, and post-cleanup validation.
- **Companion project:** `local-ai-lab-infra` provides the local-first multi-agent CloudOps pipeline.
- Local model execution is available through Ollama; sensitive IaC remains on the host unless explicitly sanitized for approved cloud API use.
- Optional cloud model APIs receive sanitized context only when configured.

**Architectural boundary:** AI agents analyze, recommend, and draft runbooks, but execution is gated behind human approval and the Terraform/AWX/GitHub Actions delivery paths. No autonomous infrastructure mutation is implied.

![Release 2 O6 AI Operations Enclave](./diagrams/release2/ai-operations-enclave.png)

---

## 5. Release 3 Target Direction - Multi-Cloud Kubernetes, GitOps & DevSecOps

Release 3 extends the platform into workload delivery governance: source control, CI/CD quality gates, unit testing, SAST, DAST, image scanning, signed image promotion, GitOps reconciliation, policy-as-code admission control, protected ingress, service-to-service encryption, observability, and resilience validation.

Release 3 is roadmap / platform evolution. It is not presented as implemented evidence.

- AKS and EKS managed through Argo CD.
- Cluster configs, applications, and policies defined in Git.
- Image scanning, signed images, and admission policies planned for workload governance.
- Service mesh, ingress control, observability, and resilience controls planned as the next platform layer.

```text
Git Repos (Apps, Infra, Policies)
        |
        v
     Argo CD
        |
   +----+----+
   v         v
 AKS       EKS
        |
        v
 Observability Stack
```

![Release 3 multi-cloud Kubernetes GitOps and DevSecOps roadmap](./diagrams/release3/release3-target-roadmap.png)

---

## 6. Trust Boundaries

- **Identity Boundary:** Entra ID and Conditional Access form the outer access-control layer. Compliant managed devices and MFA are required for privileged access paths.
- **Operator Access Boundary:** O5 AVD provides a controlled admin/developer workspace, reducing unmanaged workstation dependency.
- **Network Boundary:** Azure Firewall, FortiGate NVAs, hub/spoke routing, VPN, and BGP separate trusted, branch, cloud, and private workload paths.
- **Automation Boundary:** AWX is the governed automation control plane for Ansible operations. Terraform changes are executed through the GitHub Actions controlled-apply path.
- **AI Operations Boundary:** O6 isolates AI analysis from execution. Human approval is required, and CI/CD or AWX execution paths gate any mutation.
- **Namespace Boundary:** `br1.azawslab.co.uk` isolates branch identity and routing from the core domain.
- **Evidence Boundary:** Implementation proof is separated from narrative documentation. Screenshots, CLI outputs, pipeline logs, policy records, and validation artifacts are stored in evidence folders so architectural claims can be reviewed independently.

![Release 2 trust boundary map](./diagrams/release2/trust-boundaries.png)

---

## 7. Network and Identity Flow

**Identity flow:**

1. Engineer authenticates to Entra ID with MFA and device compliance checked through Intune.
2. Conditional Access grants access to AVD, Azure portal, or workload endpoints.
3. GitHub Actions authenticates via OIDC for Terraform delivery.
4. AWX retrieves runtime secrets from Azure Key Vault and AWS SSM, then authenticates to managed nodes.

**Network flow:**

1. Traffic enters via IPSec tunnel to Azure VPN Gateway.
2. Hub VNet routes approved traffic through validated inspection paths.
3. Spoke VNet receives approved traffic; workload endpoints such as Private AKS and AVD use private access patterns.
4. Return traffic follows the approved route path.
5. BGP dynamically updates routes across Azure, AWS, and `br1.azawslab.co.uk`.

![Release 2 network and identity flow](./diagrams/release2/network-identity-flow.png)

---

## 8. Automation and Operations Flow

1. **Infrastructure Change:** Engineer pushes Terraform change; GitHub Actions runs plan via OIDC. After review and approval, the controlled apply stage executes.
2. **Configuration Drift:** AWX periodically runs Ansible playbooks; secrets are fetched from Key Vault or SSM at runtime.
3. **AI-Assisted Operations:** O6 can provide analysis, recommendations, and runbook drafts. Human review remains the execution gate.
4. **Monitoring & Alerting:** Azure Monitor and Log Analytics collect signals; alerts trigger engineer review or controlled automation.

![Release 2 controlled operations flow with AI assistance](./diagrams/release2/operations-flow.png)

---

## 9. Evidence and Diagram Index

- **Release 1:** `screenshots/release1/` - identity sync, Intune policies, Autopilot, Purview, DLP, and recovery scenarios.
- **Release 2:** `docs/release2/evidence/` - Terraform plan/apply logs, AWX job outputs, network validation, monitoring validation, policy records, and O4/O5/O6 operational evidence.
  - **O4 Private AKS Evidence:** `docs/release2/evidence/O4/`
  - **O5 Secure Workspace Evidence:** `docs/release2/evidence/O5/`
  - **O6 AI Operations Enclave Evidence:** `docs/release2/evidence/O6/`
- **Release 3:** roadmap / platform evolution. Implementation evidence should only be added after the work begins and is validated.

![Release 2 capability-to-evidence map](./diagrams/release2/evidence-map.png)

---

## 10. Architecture Reader Path

| Reader | Start with | Then |
|---|---|---|
| Platform Architect | Sections 1, 4, 6 | Sections 2, 3 for baseline context |
| Cloud Network Engineer | Sections 4.2, 7 | Section 9 for routing evidence |
| Security Architect | Sections 3, 4.2, 4.6, 6 | Section 9 for zero-trust controls |
| DevOps/SRE | Sections 4.3, 4.4, 4.5, 8 | Section 5 for future GitOps direction |
| AI/ML Engineer | Sections 4.6, 6 | O6 evidence and companion project |
| Recruiter/Hiring Manager | Sections 1, 10 | README.md for high-level story |
---

## Navigation

- [Live portfolio showroom](https://www.azawslab.co.uk/)
- [Repository home](README.md)
- [Reviewer guide](REVIEWER_GUIDE.md)
- [Proof gallery](PROOF_GALLERY.md)
- [Evidence guide](EVIDENCE_GUIDE.md)

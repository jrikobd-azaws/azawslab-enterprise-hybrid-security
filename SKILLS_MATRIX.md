# Skills Matrix - Azawslab Enterprise Hybrid Security Platform

> Part of: [Azawslab Enterprise Hybrid Security Platform](README.md)  
> Best for: recruiters, hiring managers, and role-alignment reviewers  
> Purpose: skills-to-evidence mapping across the portfolio

## 1. Purpose

This skills matrix maps portfolio evidence directly to target cloud platform, infrastructure, security, and modern workplace roles. It is designed to give recruiters and hiring managers a fast, evidence-backed view of demonstrated capabilities, and to give technical reviewers a clear path from role requirements to verified proof.

---

## 2. Target Roles

The matrix addresses four senior roles and one adjacent role:

1. **Senior Cloud Platform Engineer** - Azure platform architecture, IaC, CI/CD, landing zones, private container platforms, secure operator workspace.
2. **Hybrid Cloud / Infrastructure Engineer** - Multi-cloud networking, hybrid identity, on-premises integration, branch office connectivity, secure admin workspace.
3. **Cloud Security Architect** - Zero-trust architecture, identity security, network inspection, secrets management, AI operations governance, secure workspace controls.
4. **Modern Workplace / Endpoint Engineer** - Microsoft 365, Intune, Autopilot, Purview, endpoint security, operational recovery, AVD + FSLogix design integration.
5. **DevOps / SRE** (adjacent) - CI/CD pipeline design, automation control planes, monitoring, resilience validation, private platform operations, AI-assisted workflows.

---

## 3. Six Capability Tracks

| Track | Capability | Release | Status |
|---|---|---|---|
| 1 | Hybrid Modern Workplace, Identity & Endpoint Security | Release 1 | Complete and evidenced |
| 2 | Azure Landing Zone, IaC & Governance | Release 2 | Implemented and evidenced |
| 3 | Secure Hybrid & Multi-Cloud Networking | Release 2 | Implemented and evidenced |
| 4 | Automation, SecOps & Resilience | Release 2 | Implemented and evidenced |
| 5 | Private Platform, Secure Workspace & AI Operations | Release 2 | Implemented and evidenced |
| 6 | Multi-Cloud Kubernetes, GitOps & DevSecOps | Release 3 | Roadmap / platform evolution |

---

## 4. Role-to-Skill-to-Evidence Table

### Senior Cloud Platform Engineer

| Skill | Demonstrated Through | Evidence Location |
|---|---|---|
| Azure landing zone design | Management group hierarchy, Azure Policy deny rules, RBAC custom roles | `docs/release2/evidence/` (governance) |
| Terraform IaC + remote state | Terraform configurations, Azure Storage backend, state locking | `docs/release2/evidence/` (Terraform plan/apply outputs) |
| GitHub Actions CI/CD with OIDC | OIDC-authenticated pipelines, plan/apply separation | GitHub Actions workflow files; pipeline evidence under `docs/release2/evidence/` where captured |
| Private AKS runtime platform | Private API posture, ACR integration, internal application validation, firewall egress validation | `docs/release2/evidence/O4/` |
| AKS operational validation | Pod-level egress checks, managed Prometheus/Grafana, AWX readiness and tier execution | `docs/release2/evidence/O4/` |
| Secure operations workspace | AVD + FSLogix secure admin/developer workspace, private access model, no-public-IP session host posture | `docs/release2/evidence/O5/` |
| AI operations integration | O6 AI Operations Enclave human-in-the-loop model, MCP policy enforcement | `docs/release2/evidence/O6/` |

### Hybrid Cloud / Infrastructure Engineer

| Skill | Demonstrated Through | Evidence Location |
|---|---|---|
| Hybrid identity (AD + Entra ID) | Entra Connect Sync, Conditional Access, MFA | `screenshots/release1/` |
| Exchange hybrid migration | Readiness check, pilot mailbox validation, mail flow verification | `screenshots/release1/modern-workplace/exchange-hybrid/` |
| Multi-cloud networking (Azure + AWS) | IPSec tunnels, BGP routing, AWS branch connectivity, Cisco CSR validation | `docs/release2/evidence/O3b/`; `docs/release2/evidence/O3c/` |
| NVA integration (FortiGate, VyOS, Cisco) | Firewall policies, routing tables, device configs | `docs/release2/evidence/A1-ansible-network-baseline/`; `docs/release2/evidence/O1/`; `docs/release2/evidence/O3b/`; `docs/release2/evidence/O3c/` |
| Branch office namespace isolation | `br1.azawslab.co.uk` design and route separation | Architecture documentation, routing evidence |
| AWS integration | AWS Transit Gateway, BGP peering, Cisco CSR deployment | `docs/release2/evidence/O3b/`; `docs/release2/evidence/O3c/` |
| Secure workspace for operations | O5 AVD + FSLogix toolchain workspace used for multi-cloud management | `docs/release2/evidence/O5/` |
| Cross-platform endpoint management | Intune policies for Windows corp, Windows BYOD, Ubuntu Linux, iPhone BYOD | `screenshots/release1/endpoint-management/intune/` |
| Ansible Linux baseline automation | Linux baseline playbook, configuration management for non-Windows devices | `ansible/`; `screenshots/release1/endpoint-management/ansible/` |

### Cloud Security Architect

| Skill | Demonstrated Through | Evidence Location |
|---|---|---|
| Zero-trust identity architecture | Conditional Access, device compliance, MFA enforcement | `screenshots/release1/` |
| Email security & anti-phishing | Defender for Office 365 anti-phishing policies, Safe Links, Safe Attachments | `screenshots/release1/modern-workplace/email-security/` |
| Network security & inspection | Azure Firewall, FortiGate NVA, NSG rules, segmentation | `docs/release2/evidence/A1-ansible-network-baseline/`; `docs/release2/evidence/O1/` |
| Secrets management | Azure Key Vault + AWS SSM, no hardcoded credentials, AWX runtime retrieval | AWX job outputs, Terraform configs |
| AI operations governance | O6 AI Operations Enclave: human-in-the-loop, MCP policy enforcement, deny-by-default tool access | `docs/release2/evidence/O6/` |
| AI policy enforcement | MCP gateway, policy decision logs, agent-specific enforcement records | `docs/release2/evidence/O6/` |
| Policy-as-code & RBAC | Azure Policy deny rules, custom RBAC roles | `docs/release2/evidence/` (governance) |
| Secure workspace design | AVD + FSLogix access boundary for privileged operations, private storage access, no-public-IP posture | `docs/release2/evidence/O5/` |
| Advanced information protection | Purview document fingerprinting, DLP policies, sensitivity labels | `screenshots/release1/information-protection/purview/purview-fingerprint/` |
| Compliance mapping & architecture | Security and compliance mapping diagram, evidence alignment | `docs/release1/09-compliance-mapping.md`; `diagrams/06-release1-security-and-compliance-mapping.png` |

### Modern Workplace / Endpoint Engineer

| Skill | Demonstrated Through | Evidence Location |
|---|---|---|
| Intune device management | Autopilot enrolment, compliance policies, configuration profiles | `screenshots/release1/` |
| Multi-platform endpoint enrollment | Windows corp, Windows BYOD, Ubuntu Linux, iPhone BYOD management | `screenshots/release1/endpoint-management/intune/` |
| Endpoint security | BitLocker, Defender Antivirus, ASR rules, Windows LAPS retrieval | `screenshots/release1/`; `screenshots/release1/endpoint-management/intune/intune-autopilot-laps/` |
| Win32 application packaging & deployment | Intune Win32 app preparation and deployment validation | `screenshots/release1/endpoint-management/intune/intune-app-deployment/` |
| Information protection | Purview sensitivity labels, DLP policies, document fingerprinting | `screenshots/release1/information-protection/purview/purview-fingerprint/` |
| Operational recovery | BitLocker key retrieval, device rebuild, Graph API cleanup | `screenshots/release1/` (recovery scenarios) |
| Identity lifecycle automation | Graph API scripts for disable, revoke, enable, mover scenario, device rename | `screenshots/release1/identity-and-access/identity-operations/` |
| Conditional Access integration | Device compliance gating cloud access | `screenshots/release1/` |
| Workspace extension into AVD | AVD + FSLogix architecture awareness, integration with identity and endpoint controls | `docs/release2/evidence/O5/`; `screenshots/release1/` |
| PowerShell scripting & automation | Exchange management scripts, identity automation tooling | `scripts/exchange/` |
| Compliance framework alignment | Release 1 security and compliance mapping, evidence collection | `docs/release1/09-compliance-mapping.md`; `diagrams/06-release1-security-and-compliance-mapping.png` |

### DevOps / SRE (adjacent)

| Skill | Demonstrated Through | Evidence Location |
|---|---|---|
| CI/CD pipeline design | GitHub Actions workflows, plan/apply gating | `.github/workflows/`; pipeline evidence under `docs/release2/evidence/` where captured |
| AWX automation control plane | Kubernetes-hosted AWX, job templates, runtime secrets | `docs/release2/evidence/A2-awx-control-plane/` |
| Monitoring & observability | Azure Monitor, Log Analytics, managed Prometheus/Grafana on AKS | `docs/release2/evidence/O4/` (managed monitoring) |
| Backup & recovery automation | Recovery Services vaults, automated runbooks | `docs/release2/evidence/` |
| Private platform operations | O4 Private AKS operational validation, pod-level checks, AWX integration | `docs/release2/evidence/O4/` |
| Secure operator workspace | O5 AVD + FSLogix as the governed toolchain workspace for platform operations | `docs/release2/evidence/O5/` |
| AI-assisted operations workflow | O6 runbook drafting, SecOps/FinOps/GitOps agent policy records, human approval gates | `docs/release2/evidence/O6/`; `local-ai-lab-infra` |

---

## 5. Recruiter Quick Scan

| Role | Key Signal | Where to Verify |
|---|---|---|
| Senior Cloud Platform Engineer | Designed and delivered a governed Azure platform with private AKS, AVD secure workspace, and AI operations integration | `ARCHITECTURE.md` Ã‚sections 4.1-4.5; `docs/release2/evidence/O4/`; `docs/release2/evidence/O5/` |
| Hybrid Cloud / Infrastructure Engineer | Built multi-cloud transit with BGP, FortiGate, AWS, branch namespace, AVD operations workspace, and multi-platform endpoint management | `ARCHITECTURE.md` Ã‚section 4.2, Ã‚section 4.5; `docs/release2/evidence/O3b/`; `docs/release2/evidence/O3c/`; `docs/release2/evidence/O5/`; `screenshots/release1/endpoint-management/intune/` |
| Cloud Security Architect | Enforced zero-trust from identity through AI operations, including AVD secure workspace, email security, and AI policy enforcement | `ARCHITECTURE.md` Ã‚section 3, Ã‚section 6; `docs/release2/evidence/O6/`; `docs/release2/evidence/O5/`; `screenshots/release1/modern-workplace/email-security/` |
| Modern Workplace / Endpoint Engineer | Delivered Intune multi-platform, Autopilot, Purview fingerprinting, Graph identity automation, LAPS, Win32 apps, operational recovery, and AVD workspace awareness | `screenshots/release1/` (endpoint, identity, info protection, recovery); `docs/release2/evidence/O5/` |
| DevOps / SRE | Operates AWX control plane, CI/CD pipelines, private platform monitoring, secure workspace, and AI-assisted runbook workflows | `ARCHITECTURE.md` Ã‚sections 4.3-4.5; `docs/release2/evidence/A2-awx-control-plane/`; `docs/release2/evidence/O4/`; `docs/release2/evidence/O6/` |

---

## 6. Technical Reviewer Evidence Path

For technical reviewers conducting a deep-dive assessment:

1. **Start with `ARCHITECTURE.md`** - understand the platform evolution, trust boundaries, and component relationships.
2. **Select a role from Ã‚section 4** - identify the skills relevant to the position.
3. **Follow the evidence locations** - each skill maps to a specific evidence folder. Reviewers can verify claims directly:
   - Screenshots for UI-based validation.
   - CLI outputs and Terraform logs for infrastructure verification.
   - AWX job logs for automation proof.
   - Policy records for governance and AI enclave controls.
4. **Cross-reference `EVIDENCE_GUIDE.md`** once Cycle 5 is complete - for redaction standards and evidence organisation rules.
5. **Review `PORTFOLIO.md`** - for the full narrative case study and interview talking points aligned to each role.
6. **Check `STATUS.md`** - for the canonical release status and source-truth lock.

This matrix is maintained as a living document. Evidence paths are updated as proof links are finalised.
---

## Navigation

- [Live portfolio showroom](https://www.azawslab.co.uk/)
- [Repository home](README.md)
- [Reviewer guide](REVIEWER_GUIDE.md)
- [Proof gallery](PROOF_GALLERY.md)
- [Evidence guide](EVIDENCE_GUIDE.md)

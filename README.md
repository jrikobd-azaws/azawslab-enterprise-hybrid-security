# azawslab Enterprise Hybrid Security Platform

[![Documentation](https://img.shields.io/badge/docs-latest-blue)](docs/README.md)
[![Release 1 Status](https://img.shields.io/badge/Release%201-Complete-brightgreen)](docs/release1/README.md)
[![Skills](https://img.shields.io/badge/Skills-Index-success)](docs/foundation/05-skills-and-evidence-index.md)

> **A flagship enterprise infrastructure portfolio** – transforming a legacy small-enterprise environment into a secure, cloud-integrated, and operationally manageable Microsoft-centric platform.

This repository goes beyond portal screenshots. It presents **architecture, implementation, validation, and operational recovery** across hybrid identity, Microsoft 365, endpoint management, endpoint compliance and security, information protection, monitoring, and Azure security roadmap work. Narrative documentation lives under `/docs`, while `/screenshots` contains a guided evidence archive organised by release and operational domain.

---

## Why This Project Matters

Today’s enterprise platforms are rarely built from scratch – they evolve. This project demonstrates **practical engineering judgment**, not a “happy-path” lab build:

- **Delivery maturity** – phased, pilot-first rollouts instead of vague “enterprise transformation” claims.
- **Validated outcomes** – every capability is backed by explicit screenshots and documented validation, not just portal configuration.
- **Operational recovery** – proven ability to handle broken trust relationships, stale Entra records, migration friction, and post-provisioning remediation.

**Target Role Alignment**  
The implemented scope strongly aligns with roles such as:

- Modern Workplace Engineer / Microsoft 365 Administrator
- Endpoint Administrator / Intune Specialist
- Hybrid Identity & Access / Entra ID Administrator
- Information Protection / Purview Specialist

---

## Key Capabilities (Release 1 - Implemented & Evidenced)

| Capability Area | What Has Been Validated |
|----------------|--------------------------|
| **Hybrid Identity** | Entra Connect Sync (OU filtering, PHS), Conditional Access, MFA, SSPR, identity lifecycle automation via Graph PowerShell (disable, session revoke, enable, mover scenario). |
| **Microsoft 365 Core** | Exchange hybrid pilot migration validation, including HCW endpoint recovery, plus Teams and SharePoint baseline validation. |
| **Email Security** | Anti-phishing, Safe Links, and Safe Attachments policies (advanced validation). |
| **Endpoint Enrollment** | Windows Corporate and BYOD, iPhone BYOD, and Ubuntu Linux visibility. |
| **Modern Provisioning** | Windows Autopilot + ESP (zero-touch, custom branding, device preparation stage). |
| **Endpoint Security** | Intune compliance policies, Windows security baseline, Defender Antivirus, ASR, BitLocker escrow and recovery, Windows Update for Business. |
| **Windows LAPS** | Full password retrieval (Entra / Intune admin center) plus post-Autopilot remediation via device-targeted script. |
| **Application Lifecycle** | Win32 app packaging, creation, assignment, and install-status validation (Notepad++ as example). |
| **Information Protection** | Purview sensitivity labels, DLP policy tips, retention baseline, and document fingerprinting (custom SIT from HR form). |
| **Operational Tooling** | Graph PowerShell scripts for user/device state, device rename, and helpdesk-oriented operational support. |
| **Recovery** | BitLocker key retrieval, device rebuild, stale record cleanup, and restored compliance. |

*All advanced validation items are clearly marked as “added after baseline” in the documentation.*

---

## Technology Stack & Skills Highlight

| Category | Technologies / Skills Demonstrated |
|----------|------------------------------------|
| **Identity & Access** | Active Directory, Microsoft Entra ID, Entra Connect Sync, Conditional Access, MFA, SSPR, Graph API, PowerShell automation |
| **Modern Workplace** | Exchange hybrid, Exchange Online, Teams, SharePoint, anti-phishing / Safe Links / Safe Attachments policies |
| **Endpoint Management** | Intune (enrollment, compliance, security baselines, update rings, Autopilot, Win32 app deployment) |
| **Endpoint Security** | Windows security baseline, Defender Antivirus, ASR, BitLocker, Windows LAPS |
| **Information Protection** | Microsoft Purview (sensitivity labels, DLP, retention, document fingerprinting) |
| **Operational Tooling** | PowerShell, Microsoft Graph SDK, dry-run scripts, helpdesk diagnostic and support tooling |
| **Infrastructure** | Hyper-V (internal switching, host NAT, differencing disks), Windows Server, Ubuntu Linux, Ansible (baseline automation) |

---

## Release Roadmap

| Release | Focus | Status |
| :--- | :--- | :--- |
| **Release 1** | Hybrid identity, Microsoft 365 baseline, endpoint management & security, Purview, operational recovery, advanced validation (Autopilot, LAPS retrieval, Graph lifecycle, email security, document fingerprinting) | **Complete & evidenced** |
| **Release 2** | Azure landing zone, infrastructure as code (Terraform), RBAC governance, network security, Sentinel / Defender for Cloud | *Roadmap* |
| **Release 3** | Secure workload hosting, containerisation (Docker), protected ingress (WAF), observability | *Roadmap* |

---

## Skills Alignment for Recruiters & Hiring Managers

The implemented capabilities map directly to the most-requested skills in Modern Workplace, Intune, and Entra ID roles:

- **Microsoft Intune** – enrollment, compliance, security baselines, update rings, Autopilot + ESP, Win32 app deployment.
- **Entra ID / hybrid identity** – Conditional Access, MFA, SSPR, identity lifecycle automation via **Graph PowerShell**.
- **PowerShell & Microsoft Graph API** – user/device state queries, session revoke, department-driven dynamic group membership, controlled device rename, consent/permission scoping.
- **Microsoft 365** – Exchange hybrid, Teams, SharePoint, email security (anti-phishing / Safe Links / Safe Attachments).
- **Microsoft Purview** – sensitivity labels, DLP, document fingerprinting (custom SIT from structured HR form).
- **Operational support** – helpdesk-oriented scripts, BitLocker recovery, LAPS retrieval, device rebuild, stale record cleanup.

---

## Repository Navigation

### 1. Foundation (Cross-Release Context)
- [Platform Overview](docs/foundation/01-platform-overview.md)
- [Current-State Architecture](docs/foundation/02-current-state-architecture.md)
- [Target-State Architecture](docs/foundation/03-target-state-architecture.md)
- [Skills & Evidence Index](docs/foundation/05-skills-and-evidence-index.md)
- [Future Roadmap](docs/foundation/04-roadmap.md)

### 2. Release 1 (Deep Dives & Evidence)
- [Release 1 README](docs/release1/README.md) – role-targeted landing page
- [Release 1 Summary](docs/release1/00-summary.md) – executive proof
- [Hybrid Identity](docs/release1/01-hybrid-identity.md)
- [Modern Workplace](docs/release1/02-modern-workplace.md)
- [Endpoint Enrollment](docs/release1/04-endpoint-enrollment.md)
- [Endpoint Compliance & Security](docs/release1/05-endpoint-compliance-and-security.md)
- [Purview Information Protection](docs/release1/07-purview.md)
- [Monitoring & Operations](docs/release1/08-monitoring.md)
- [Recovery Scenarios](docs/release1/06-recovery-scenarios.md)

> Raw evidence screenshots are located under `/screenshots`, organised by operational domain.

---

## Scope Transparency - What Is Deferred

To maintain engineering integrity, the following areas are **not** fully evidenced in Release 1 and remain future enhancements:

- Android BYOD / MAM validation
- Full enterprise PKI / AD CS deployment (Let’s Encrypt / `win-acme` was used for hybrid validation)
- Full Microsoft Defender for Endpoint product-depth maturity
- Broader Azure platform security and DevOps workflows (reserved for Releases 2 and 3)

> Each deferred item is tracked with notes in the [Extensions and Future Enhancements](docs/release1/12-extensions-and-future-enhancements.md) document.

---

## Getting Started

For Modern Workplace, Intune, Entra ID, or hybrid Microsoft roles, the best starting point is the **[Release 1 README](docs/release1/README.md)**.

To understand the full three-release journey, begin with the **[Platform Overview](docs/foundation/01-platform-overview.md)** and the **[Skills & Evidence Index](docs/foundation/05-skills-and-evidence-index.md)**.

---

**Author** – Hashibur Rahman  
Senior Hybrid Cloud & Infrastructure Engineer, Belfast, UK


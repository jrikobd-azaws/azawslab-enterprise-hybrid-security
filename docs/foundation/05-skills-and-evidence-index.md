# Skills and Evidence Index

This page maps the platform’s implemented capabilities to the documentation and evidence that support them.

It is designed to help:
- recruiters quickly recognise role-relevant skills
- hiring managers verify scope and maturity
- technical reviewers jump directly from capability to proof

This index is intentionally evidence-led. It focuses on what is documented and supported in the repository, while keeping future or partial scope clearly separated.

---

## How to Use This Page

Use this page in one of three ways:

- **Role matching:** scan the capability names against a job description
- **Proof checking:** jump from a skill area to the most relevant documentation and screenshot evidence
- **Scope review:** identify what is implemented now versus what is deferred to later roadmap work

This page is especially useful for roles centered on:
- Intune and Windows endpoint engineering
- Entra ID / hybrid identity administration
- Microsoft 365 operations
- Microsoft Graph API and PowerShell automation
- compliance, monitoring, and support-oriented platform operations

---

## Capability-to-Evidence Map

| Capability / Skill Area | Release | Current Scope | Main Documentation | Evidence / Proof |
| :--- | :--- | :--- | :--- | :--- |
| **Hybrid Identity (Active Directory + Entra ID)** | Release 1 | Implemented & evidenced | [Hybrid Identity](../release1/01-hybrid-identity.md) | [Release 1 Summary](../release1/00-summary.md), `screenshots/release1/identity-and-access/` |
| **Entra Connect Sync / Password Hash Sync / OU Filtering** | Release 1 | Implemented & evidenced | [Hybrid Identity](../release1/01-hybrid-identity.md) | `screenshots/release1/identity-and-access/entra-sync/` |
| **Conditional Access / Identity Protection Baseline** | Release 1 | Implemented & evidenced | [Hybrid Identity](../release1/01-hybrid-identity.md), [Monitoring](../release1/08-monitoring.md) | `screenshots/release1/identity-and-access/identity-protection/`, `screenshots/release1/monitoring-and-operations/` |
| **MFA / SSPR** | Release 1 | Implemented & evidenced | [Hybrid Identity](../release1/01-hybrid-identity.md) | `screenshots/release1/identity-and-access/identity-protection/` |
| **Windows LAPS Policy Configuration** | Release 1 | Implemented & evidenced | [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md) | `screenshots/release1/identity-and-access/identity-protection/laps/` |
| **Windows LAPS Full Retrieval (Entra/Intune)** | Release 1 | **Completed (advanced validation added after baseline)** | [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md) | `screenshots/release1/identity-and-access/identity-protection/laps/` |
| **LAPS Remediation after Autopilot** | Release 1 | **Completed (advanced validation added after baseline)** | [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md) | `screenshots/release1/endpoint-management/intune/intune-autopilot-laps/` |
| **Exchange Hybrid / Hybrid Migration Validation** | Release 1 | Implemented & evidenced | [Modern Workplace](../release1/02-modern-workplace.md) | `screenshots/release1/modern-workplace/exchange-hybrid/` |
| **Microsoft 365 Baseline (Exchange Online, Teams, SharePoint)** | Release 1 | Implemented & evidenced | [Modern Workplace](../release1/02-modern-workplace.md) | `screenshots/release1/modern-workplace/` |
| **Email Security (Anti-Phishing, Safe Links, Safe Attachments)** | Release 1 | **Completed (advanced validation added after baseline)** | [Modern Workplace](../release1/02-modern-workplace.md) | `screenshots/release1/modern-workplace/email-security/` |
| **Endpoint Management with Intune** | Release 1 | Implemented & evidenced | [Endpoint Overview](../release1/03-endpoint-overview.md), [Endpoint Enrollment](../release1/04-endpoint-enrollment.md) | `screenshots/release1/endpoint-management/intune/` |
| **Windows 10/11 Corporate Enrollment** | Release 1 | Implemented & evidenced | [Endpoint Enrollment](../release1/04-endpoint-enrollment.md) | `screenshots/release1/endpoint-management/intune/intune-windows-corp/` |
| **Windows BYOD Enrollment / Ownership Separation** | Release 1 | Implemented & evidenced | [Endpoint Enrollment](../release1/04-endpoint-enrollment.md) | `screenshots/release1/endpoint-management/intune/intune-windows-byod/` |
| **iPhone BYOD Enrollment** | Release 1 | Implemented & evidenced | [Endpoint Enrollment](../release1/04-endpoint-enrollment.md) | `screenshots/release1/endpoint-management/intune/intune-ios/` |
| **Ubuntu Linux Enrollment / Visibility** | Release 1 | Implemented & evidenced | [Endpoint Enrollment](../release1/04-endpoint-enrollment.md) | `screenshots/release1/endpoint-management/intune/intune-linux/`, `ansible/` |
| **Windows Autopilot + ESP (Zero-Touch Provisioning)** | Release 1 | **Completed (advanced validation added after baseline)** | [Endpoint Enrollment](../release1/04-endpoint-enrollment.md) | `screenshots/release1/endpoint-management/intune/intune-autopilot-esp/` |
| **Graph-Assisted Autopilot Operational Support** | Release 1 | **Completed (advanced validation added after baseline)** | [Endpoint Enrollment](../release1/04-endpoint-enrollment.md), [Monitoring](../release1/08-monitoring.md) | `scripts/release1/autopilot/graph-support/`, `screenshots/release1/identity-and-access/identity-operations/graph-powershell/` |
| **Win32 Application Packaging and Deployment** | Release 1 | **Completed (advanced validation added after baseline)** | [Endpoint Enrollment](../release1/04-endpoint-enrollment.md) | `screenshots/release1/endpoint-management/intune/intune-app-deployment/` |
| **Endpoint Compliance Policies** | Release 1 | Implemented & evidenced | [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md) | `screenshots/release1/endpoint-management/intune/intune-compliance-policy/` |
| **Endpoint Security Baselines** | Release 1 | Implemented & evidenced | [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md) | `screenshots/release1/endpoint-management/intune/intune-security-baseline/` |
| **Defender Antivirus Baseline** | Release 1 | Implemented & evidenced | [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md) | `screenshots/release1/endpoint-management/intune/intune-security-baseline/` |
| **Attack Surface Reduction (ASR)** | Release 1 | Implemented & evidenced | [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md) | `screenshots/release1/endpoint-management/intune/intune-security-baseline/` |
| **BitLocker Key Escrow / Recovery** | Release 1 | Implemented & evidenced | [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md), [Recovery Scenarios](../release1/06-recovery-scenarios.md) | `screenshots/release1/endpoint-management/intune/intune-bitlocker-recovery-scenario/` |
| **Windows Update for Business (WUfB)** | Release 1 | Implemented & evidenced | [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md) | `screenshots/release1/endpoint-management/intune/intune-windows-update/` |
| **Identity Lifecycle (Access-State: Disable, Revoke, Enable)** | Release 1 | **Completed (advanced validation added after baseline)** | [Hybrid Identity](../release1/01-hybrid-identity.md) | `screenshots/release1/identity-and-access/identity-operations/lifecycle/` |
| **Identity Lifecycle (Mover: Department Change → Dynamic Group → App Access)** | Release 1 | **Completed (advanced validation added after baseline)** | [Hybrid Identity](../release1/01-hybrid-identity.md) | `screenshots/release1/identity-and-access/identity-operations/lifecycle/` |
| **Microsoft Graph API + PowerShell Automation** | Release 1 | **Completed (advanced validation added after baseline)** | [Hybrid Identity](../release1/01-hybrid-identity.md), [Monitoring](../release1/08-monitoring.md) | `screenshots/release1/identity-and-access/identity-operations/graph-powershell/`, `scripts/release1/identity/graph-lifecycle/` |
| **Operational Recovery / Device Rebuild / Stale Record Cleanup** | Release 1 | Implemented & evidenced | [Recovery Scenarios](../release1/06-recovery-scenarios.md), [Lessons Learned](../release1/10-lessons-learned.md) | `screenshots/release1/endpoint-management/intune/intune-bitlocker-recovery-scenario/` |
| **Purview Sensitivity Labels** | Release 1 | Implemented & evidenced | [Purview](../release1/07-purview.md) | `screenshots/release1/information-protection/purview/purview-sensitivity-labels/` |
| **Purview DLP (Policy Tip)** | Release 1 | Implemented & evidenced | [Purview](../release1/07-purview.md) | `screenshots/release1/information-protection/purview/purview-dlp/` |
| **Purview Retention** | Release 1 | Implemented & evidenced | [Purview](../release1/07-purview.md) | `screenshots/release1/information-protection/purview/purview-retention/` |
| **Purview Document Fingerprinting** | Release 1 | **Completed (advanced validation added after baseline)** | [Purview](../release1/07-purview.md) | `screenshots/release1/information-protection/purview/purview-fingerprint/` |
| **Monitoring / Audit / Sign-In Review** | Release 1 | Implemented & evidenced | [Monitoring](../release1/08-monitoring.md) | `screenshots/release1/monitoring-and-operations/monitoring/` |
| **Graph/PowerShell Operational Scripts (Device State, Rename, User State)** | Release 1 | **Completed (advanced validation added after baseline)** | [Monitoring](../release1/08-monitoring.md) | `screenshots/release1/identity-and-access/identity-operations/graph-powershell/`, `scripts/release1/autopilot/graph-support/` |
| **Security / Compliance Mapping** | Release 1 | Implemented & evidenced | [Compliance Mapping](../release1/09-compliance-mapping.md) | [Security and compliance diagram](../../diagrams/06-release1-security-and-compliance-mapping.png) |
| **Operational Documentation / Lessons Learned** | Release 1 | Implemented & evidenced | [Lessons Learned](../release1/10-lessons-learned.md), [Build Checklist](../release1/11-build-checklist.md) | Release 1 documentation set |
| **Ansible Linux Baseline Automation** | Release 1 | Implemented (baseline) | [Endpoint Enrollment](../release1/04-endpoint-enrollment.md), [Platform Overview](01-platform-overview.md) | `ansible/`, `screenshots/release1/endpoint-management/ansible/` |
| **PowerShell Scripting (General / Exchange)** | Release 1 | Implemented (baseline) | [Modern Workplace](../release1/02-modern-workplace.md), [Build Checklist](../release1/11-build-checklist.md) | `scripts/exchange/` |
| **Azure Landing Zone / Governance / IaC / Sentinel** | Release 2 | Planned roadmap | [Roadmap](04-roadmap.md) | Release 2 documentation set |
| **Secure Workload Hosting / Docker / WAF / Observability** | Release 3 | Planned roadmap | [Roadmap](04-roadmap.md) | Release 3 documentation set |

---

## Scope Notes

### Implemented & evidenced
These capabilities are both documented and backed by visible proof in the repository.

### Completed (advanced validation added after baseline)
These capabilities were added after the original release baseline. They are fully implemented and evidenced, but clearly marked as later additions to maintain scope honesty.

### Implemented (baseline)
The capability is configured and functional, but the evidence set is not as comprehensive as for full **Implemented & evidenced** items. See the linked documentation and screenshot folders for the exact scope of validation.

### Planned roadmap
These capabilities belong to Release 2 or Release 3 and should not be presented as completed implementation.

---

## Important Scope Boundaries

The following terms may appear in role descriptions and market terminology, but they should be used carefully in the documentation:

- **Enterprise PKI / AD CS** – do not claim full implementation where Release 1 used Let’s Encrypt / `win-acme` for hybrid validation
- **Broad Azure security platform delivery** – reserved for Release 2
- **Secure workload modernization / WAF / observability stack** – reserved for Release 3
- **Full Defender for Endpoint stack** – not fully implemented; baseline AV/ASR only
- **Android BYOD / MAM** – deferred, not yet evidenced

These scope boundaries should always be consistent with:
- [Build Checklist](../release1/11-build-checklist.md)
- [Extensions and Future Enhancements](../release1/12-extensions-and-future-enhancements.md)
- [Roadmap](04-roadmap.md)

---

## Best Starting Points by Role

### Modern Workplace / Microsoft 365 / Intune roles
Start with:
- [Release 1 Summary](../release1/00-summary.md)
- [Endpoint Enrollment](../release1/04-endpoint-enrollment.md)
- [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md)
- [Monitoring](../release1/08-monitoring.md)

### Hybrid identity / systems administration roles
Start with:
- [Hybrid Identity](../release1/01-hybrid-identity.md)
- [Monitoring](../release1/08-monitoring.md)
- [Build Checklist](../release1/11-build-checklist.md)

### Azure governance / security roles
Start with:
- [Roadmap](04-roadmap.md)
- Release 2 documentation as it is completed

### Broader portfolio / flagship project review
Start with:
- [Root README](../../README.md)
- [Platform Overview](01-platform-overview.md)
- [Target-State Architecture](03-target-state-architecture.md)

---

## Why This Index Matters

This page is one of the most important recruiter and hiring-manager entry points in the repo.

It helps translate the repository from “lots of Microsoft screenshots and docs” into a clear capability map covering:

- Intune and Windows 11 endpoint engineering
- Entra ID and hybrid identity
- Microsoft 365 operations
- Microsoft Graph API and PowerShell automation
- compliance, monitoring, and operational recovery
- Purview information protection

That clarity is important because the project is strongest when readers can quickly connect implementation depth to role-relevant skills.
# Release 1 Build Checklist

## Purpose

This page records the implemented scope of the phase in a concise, reviewable format.

It is intended to show what was completed, what was completed later as advanced validation added after baseline, what remains partially evidenced, and what is still deferred. It should be read as an implementation ledger rather than as a narrative summary.

---

## Status Definitions

| Status | Meaning |
| :--- | :--- |
| **Completed** | Implemented and supported by clear documentation and evidence in the repository |
| **Completed (advanced validation added after baseline)** | Implemented after the original baseline freeze; fully evidenced and documented as an extension to the core release |
| **Partial** | Implemented or configured in some form, but not fully evidenced or not validated to the same depth as completed items |
| **Deferred** | Intentionally outside the implemented scope of this phase and reserved for later work |

---

## Platform Foundation

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Hyper-V platform | Multi-VM lab platform with internal switching, host NAT, and differencing-disk reuse | **Completed** | Core platform used to deliver the implemented environment |
| Core infrastructure | Domain, DNS, and supporting on-premises services | **Completed** | Forms the basis of the hybrid environment |
| Namespace design | Separation of root business namespace and pilot hybrid namespace | **Completed** | `corp.azawslab.co.uk` used for the hybrid pilot path |
| Certificate handling | Certificate path sufficient for hybrid validation using Let's Encrypt / `win-acme` | **Completed** | Sufficient for scoped hybrid validation; not a full enterprise PKI / AD CS deployment |

---

## Hybrid Identity and Access

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Active Directory to Entra ID | Entra Connect Sync with pilot filtering | **Completed** | Controlled pilot-first synchronization path |
| Authentication baseline | Password Hash Synchronization (PHS) | **Completed** | Used as the practical hybrid authentication model |
| Access control baseline | Conditional Access | **Completed** | Evidenced through sign-in visibility and access review |
| Authentication hardening | MFA | **Completed** | Included as part of the identity baseline |
| Identity self-service | SSPR | **Completed** | Included as part of the baseline identity-support posture |
| Local admin protection | Windows LAPS policy configuration | **Completed** | Baseline policy configuration established; later retrieval and remediation are documented below as advanced validation |
| Graph API identity lifecycle - access-state (leaver) | Disable, session revoke, enable via Graph PowerShell | **Completed (advanced validation added after baseline)** | Evidenced in `identity-operations/lifecycle/` and `graph-powershell/` |
| Graph API identity lifecycle - mover scenario | Department change, dynamic group, Slack access via Graph PowerShell | **Completed (advanced validation added after baseline)** | Evidenced in `identity-operations/lifecycle/` using interactive script |
| Windows LAPS retrieval | Password retrieval from Entra admin center / Intune admin center | **Completed (advanced validation added after baseline)** | Retrieval fully validated for pilot Windows device scope |

---

## Modern Workplace

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Exchange hybrid readiness | Hybrid configuration and migration readiness validation | **Completed** | Evidenced through readiness and pilot validation screenshots |
| Pilot mailbox migration | Post-migration mailbox access validation | **Completed** | Pilot users validated successfully |
| Exchange Online baseline | Mailbox service access for pilot users | **Completed** | Demonstrated through post-migration access |
| Teams baseline | Basic collaboration validation | **Completed** | Teams activity evidenced at baseline level |
| SharePoint baseline | File access and usability validation | **Completed** | SharePoint file interaction evidenced |
| Email security (anti-phishing, Safe Links, Safe Attachments) | Policy configuration and validation | **Completed (advanced validation added after baseline)** | Evidenced in `modern-workplace/email-security/` |

---

## Endpoint Enrollment and Management

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Windows corporate onboarding | Managed corporate Windows enrollment path | **Completed** | One of the strongest endpoint evidence areas |
| Windows BYOD onboarding | Personal Windows enrollment path | **Completed** | Ownership distinction demonstrated |
| iPhone BYOD onboarding | Company Portal-based mobile enrollment | **Completed** | Mobile onboarding evidenced |
| Ubuntu Linux visibility | Linux device represented in the endpoint estate | **Completed** | Included as part of platform-diversity evidence |
| Intune as management layer | Device visibility and policy context | **Completed** | Central management plane across the endpoint story |
| Android BYOD / MAM | Mobile application management for Android | **Deferred** | Not yet evidenced in this phase |
| Windows Autopilot + ESP | Modern provisioning, profile assignment, ESP stages, zero-touch OOBE | **Completed (advanced validation added after baseline)** | Evidenced in `intune-autopilot-esp/`; local VM workflow used |
| Graph-assisted Autopilot operational support | Device-state queries and rename via Graph PowerShell | **Completed (advanced validation added after baseline)** | Evidenced through Graph PowerShell scripts and related operational screenshots |
| Win32 application deployment | Packaging, creation, assignment, install status (Notepad++) | **Completed (advanced validation added after baseline)** | Evidenced in `intune-app-deployment/` |

---

## Endpoint Compliance and Security

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Compliance policy | Compliant / non-compliant device-state evaluation | **Completed** | Clearly evidenced |
| Security baseline | Managed Windows hardening baseline | **Completed** | Assignment and visibility evidenced |
| Defender Antivirus | Baseline protection policy | **Completed** | Implemented and evidenced as baseline protection control; not presented as full Defender for Endpoint stack |
| Attack Surface Reduction (ASR) | ASR policy coverage | **Completed** | Implemented and evidenced as baseline control coverage |
| BitLocker-related controls | Protection with recovery-key visibility | **Completed** | Strongly supported by recovery scenario evidence |
| Windows Update for Business | Pilot update-ring policy | **Completed** | Update governance clearly represented |
| Full Defender for Endpoint stack | Advanced product-depth capability | **Deferred** | Outside implemented scope of this phase |
| LAPS remediation after Autopilot | Missing account fix via script and device targeting | **Completed (advanced validation added after baseline)** | Evidenced in `intune-autopilot-laps/` |

---

## Recovery and Lifecycle Handling

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| BitLocker recovery | Recovery prompt and key retrieval workflow | **Completed** | One of the strongest operational proof areas |
| Device rebuild | Rebuild after trust disruption | **Completed** | Included in the recovery path |
| Re-enrollment | Return to managed state after rebuild | **Completed** | Evidenced clearly |
| Stale / duplicate record cleanup | Lifecycle hygiene after recovery | **Completed** | Important realism signal in the endpoint story |
| Restored compliance | Healthy state after recovery workflow | **Completed** | Explicitly evidenced |

---

## Information Protection

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Sensitivity labels | Label availability and user-visible application | **Completed** | Clearly evidenced in Word |
| DLP | User-facing DLP policy-tip behavior | **Completed** | Strong flagship evidence area |
| Retention baseline | Retention-related configuration | **Completed** | Included as baseline governance scope; validation depth is lighter than labels and DLP |
| Document fingerprinting | Custom SIT from HR form, DLP linkage, policy tip validation | **Completed (advanced validation added after baseline)** | Evidenced in `purview-fingerprint/` with renamed screenshots |
| Broad auto-labeling / advanced automation | Larger-scale Purview automation | **Deferred** | Outside current scope |

---

## Monitoring and Operational Visibility

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Sign-in visibility | Sign-in logs with Conditional Access result review | **Completed** | Clearly evidenced |
| Audit visibility | Administrative audit-log review | **Completed** | Clearly evidenced |
| Device-state visibility | Device compliance and operational status views | **Completed** | Included in monitoring proof |
| Alert visibility | Example operational alerting in the admin view | **Completed** | Supports day-to-day supportability |
| Full SIEM / SOC monitoring | Sentinel-led enterprise monitoring model | **Deferred** | Reserved for later Azure-focused work |
| Graph / PowerShell operational scripts | User state, device state, rename via Graph API | **Completed (advanced validation added after baseline)** | Evidenced in `graph-powershell/` and scripts folder |

---

## Documentation and Evidence

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Root README | Flagship project storefront | **Completed** | Primary entry point for the repository |
| Foundation docs | Scenario, architecture, roadmap, and skills/evidence mapping | **Completed** | Cross-release framing layer |
| Release 1 landing page | Release 1 README | **Completed** | Role-targeted landing page |
| Release 1 deep docs | Identity, workplace, endpoint, recovery, Purview, monitoring | **Completed** | Main implementation narrative now includes baseline + advanced validation |
| Evidence hubs | Screenshot dashboards by release and domain | **Partial** | Should be completed and polished during publication pass |
| Diagram set | Architecture, flow, proof, and mapping diagrams | **Completed** | Key diagrams available for major pages |

---

## Deferred or Future Enhancement Areas

The following remain intentionally outside the implemented scope of this phase:

- Android BYOD / MAM
- full enterprise PKI / AD CS deployment
- broader Azure platform governance and security engineering
- Sentinel-led monitoring / SIEM
- secure workload modernization capabilities reserved for later releases
- full Defender for Endpoint advanced stack
- broader Purview auto-labeling and automation

See:
- [Extensions and Future Enhancements](12-extensions-and-future-enhancements.md)
- [Roadmap](../foundation/04-roadmap.md)

---

## Overall Status View

| Category | Overall Status |
| :--- | :--- |
| Platform foundation | **Completed** |
| Hybrid identity and access | **Completed** (baseline + advanced lifecycle) |
| Modern Workplace baseline | **Completed** (baseline + email security) |
| Endpoint enrollment and management | **Completed** (baseline + Autopilot + Graph support + app deployment) |
| Endpoint compliance and security | **Completed** (baseline + LAPS retrieval + remediation) |
| Recovery and lifecycle handling | **Completed** |
| Information protection | **Completed** (baseline + document fingerprinting) |
| Monitoring and operational visibility | **Completed** (baseline + Graph operational scripts) |
| Future enhancements | **Deferred by design** |

---

## Related Documents

- [Release 1 Summary](00-summary.md)
- [Lessons Learned](10-lessons-learned.md)
- [Extensions and Future Enhancements](12-extensions-and-future-enhancements.md)
- [Skills and Evidence Index](../foundation/05-skills-and-evidence-index.md)
- [Roadmap](../foundation/04-roadmap.md)
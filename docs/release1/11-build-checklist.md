# Release 1 Build Checklist

## Purpose

This page records the implemented scope of the phase in a concise, reviewable format.

It is intended to show what was completed, what was partially evidenced, and what remains deferred. It should be read as an implementation ledger rather than as a narrative summary.

---

## Status Definitions

| Status | Meaning |
| :--- | :--- |
| **Completed** | Implemented and supported by clear documentation and evidence in the repository |
| **Partial** | Implemented or configured in some form, but not fully evidenced or not validated to the same depth as completed items |
| **Deferred** | Intentionally outside the implemented scope of this phase and reserved for later work |

---

## Platform Foundation

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Hyper-V platform | Multi-VM lab platform with internal switching, host NAT, and differencing-disk reuse | **Completed** | Core platform used to deliver the implemented environment |
| Core infrastructure | Domain, DNS, and supporting on-premises services | **Completed** | Forms the basis of the hybrid environment |
| Namespace design | Separation of root business namespace and pilot hybrid namespace | **Completed** | `corp.azawslab.co.uk` used for the hybrid pilot path |
| Certificate handling | Certificate path sufficient for hybrid validation using Letâ€™s Encrypt / `win-acme` | **Partial** | Sufficient for scoped hybrid validation; not a full enterprise PKI / AD CS deployment |

---

## Hybrid Identity and Access

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Active Directory to Entra ID | Entra Connect Sync with pilot filtering | **Completed** | Controlled pilot-first synchronization path |
| Authentication baseline | Password Hash Synchronization (PHS) | **Completed** | Used as the practical hybrid authentication model |
| Access control baseline | Conditional Access | **Completed** | Evidenced through sign-in visibility and access review |
| Authentication hardening | MFA | **Completed** | Included as part of the identity baseline |
| Identity self-service | SSPR | **Completed** | Included as part of the baseline identity-support posture |
| Local admin protection | Windows LAPS policy configuration | **Partial** | Policy scope discussed carefully; retrieval/recovery evidence not treated as fully complete |

---

## Modern Workplace

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Exchange hybrid readiness | Hybrid configuration and migration readiness validation | **Completed** | Evidenced through readiness and pilot validation screenshots |
| Pilot mailbox migration | Post-migration mailbox access validation | **Completed** | Pilot users validated successfully |
| Exchange Online baseline | Mailbox service access for pilot users | **Completed** | Demonstrated through post-migration access |
| Teams baseline | Basic collaboration validation | **Completed** | Teams activity evidenced at baseline level |
| SharePoint baseline | File access and usability validation | **Completed** | SharePoint file interaction evidenced |
| OneDrive governance / administration | Full service-depth management | **Deferred** | Not a focus of the implemented phase |

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
| Autopilot / ESP | Modern provisioning and enrollment-status optimization | **Deferred** | Reserved for future enhancement work |

---

## Endpoint Compliance and Security

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Compliance policy | Compliant / non-compliant device-state evaluation | **Completed** | Clearly evidenced |
| Security baseline | Managed Windows hardening baseline | **Completed** | Assignment and visibility evidenced |
| Defender Antivirus | Baseline protection policy | **Partial** | Implemented baseline control; not presented as full Defender for Endpoint stack |
| Attack Surface Reduction (ASR) | ASR policy coverage | **Partial** | Evidenced as baseline control coverage |
| BitLocker-related controls | Protection with recovery-key visibility | **Completed** | Strongly supported by recovery scenario evidence |
| Windows Update for Business | Pilot update-ring policy | **Completed** | Update governance clearly represented |
| Full Defender for Endpoint stack | Advanced product-depth capability | **Deferred** | Outside implemented scope of this phase |

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
| Retention baseline | Retention-related configuration | **Partial** | Included as baseline governance scope; not deeply validated |
| Document fingerprinting | Advanced Purview content matching | **Deferred** | Not claimed in this phase |
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

---

## Documentation and Evidence

| Area | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| Root README | Flagship project storefront | **Completed** | Primary entry point for the repository |
| Foundation docs | Scenario, architecture, roadmap, and skills/evidence mapping | **Completed** | Cross-release framing layer |
| Release 1 landing page | Release 1 README | **Completed** | Role-targeted landing page |
| Release 1 deep docs | Identity, workplace, endpoint, recovery, Purview, monitoring | **Completed** | Main implementation narrative |
| Evidence hubs | Screenshot dashboards by release and domain | **Partial** | Should be completed and polished during publication pass |
| Diagram set | Architecture, flow, proof, and mapping diagrams | **Completed** | Key diagrams available for major pages |

---

## Deferred or Future Enhancement Areas

The following remain intentionally outside the implemented scope of this phase:

- Android BYOD / MAM
- Windows Autopilot / ESP optimization
- full enterprise PKI / AD CS deployment
- advanced Purview automation and document fingerprinting
- broader Azure platform governance and security engineering
- Sentinel-led monitoring / SIEM
- secure workload modernization capabilities reserved for later releases

See:
- [Extensions and Future Enhancements](12-extensions-and-future-enhancements.md)
- [Roadmap](../foundation/04-roadmap.md)

---

## Overall Status View

| Category | Overall Status |
| :--- | :--- |
| Platform foundation | **Completed** |
| Hybrid identity and access | **Completed** |
| Modern Workplace baseline | **Completed** |
| Endpoint enrollment and management | **Completed** |
| Endpoint compliance and security | **Mostly completed with some partial areas** |
| Recovery and lifecycle handling | **Completed** |
| Information protection | **Mostly completed with some partial areas** |
| Monitoring and operational visibility | **Completed** |
| Future enhancements | **Deferred by design** |

---

## Related Documents

- [Release 1 Summary](00-summary.md)
- [Lessons Learned](10-lessons-learned.md)
- [Extensions and Future Enhancements](12-extensions-and-future-enhancements.md)
- [Skills and Evidence Index](../foundation/05-skills-and-evidence-index.md)
- [Roadmap](../foundation/04-roadmap.md)

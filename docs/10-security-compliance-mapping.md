# Security and Compliance Mapping

## Purpose

This document maps project controls implemented or planned within the `azawslab Enterprise Hybrid Security Platform` against common security, governance, and compliance expectations.

The purpose is not to claim full certification or formal compliance, but to demonstrate how design and implementation choices align with recognized control objectives relevant to enterprise environments.

This document should always reflect actual implementation state rather than aspirational planning language.

---

## Standards / Frameworks Referenced

This project references the following frameworks and control perspectives:

- GDPR
- NIST Cybersecurity Framework (CSF)
- CIS Controls / CIS-aligned endpoint and access hardening intent

These mappings are used for engineering and governance context only.

They do not represent a claim of formal certification or audited compliance.

---

## Mapping Approach

Release 1 mapping is based on:

- implemented control state
- pilot-scope validation where appropriate
- supporting documentation and screenshots
- practical alignment to recognized control objectives

The project uses evidence-led mapping.

This means a control should not be presented as implemented unless there is meaningful implementation and validation behind it.

---

## Release 1 Position

Release 1 focuses on building the hybrid identity, messaging, Microsoft 365, endpoint, Zero Trust, monitoring, and governance foundations for a realistic enterprise-style hybrid environment.

By this point in Release 1, the project materially demonstrates:

- on-premises Active Directory identity foundation
- Entra Connect synchronization
- pilot licensing and cloud sign-in validation
- Exchange hybrid readiness and pilot migration
- Microsoft 365 workload baseline progression
- Intune and endpoint baseline progression
- pilot MFA, SSPR, and Conditional Access implementation
- compliant-device access logic
- monitoring tied to identity-access rollout

The tables below should be interpreted as Release 1 pilot and engineering evidence, not tenant-wide enterprise completion.

---

## Release 1 Control Mapping

| Control Area | Implementation / Evidence | GDPR | NIST CSF | CIS / Security Intent | Notes |
|---|---|---|---|---|---|
| MFA enforcement | Conditional Access pilot policies require MFA for Microsoft Admin Portals and all cloud apps for pilot users | Supports protection of access to personal and business data | PR.AA | Strong authentication | Implemented through staged pilot rollout with report-only first |
| Self-service password reset | SSPR enabled for selected pilot users through Entra group targeting | Supports identity resilience and user recovery capability | PR.AA / PR.IP | Secure account recovery | Pilot-scoped enablement only |
| Pilot identity targeting | `SG-Pilot-MFA-SSPR-CA` used to scope SSPR, MFA, and Conditional Access rollout | Supports controlled processing and minimized rollout risk | PR.AC | Controlled policy targeting | Prevents unnecessary tenant-wide blast radius during pilot phase |
| Emergency admin exclusion | `SG-CA-Exclude-BreakGlass` used to exclude emergency admin account from pilot CA policies | Supports availability and administrative continuity | PR.AC / RC.RP | Administrative resilience | Lab implementation of controlled exclusion, not full production emergency-access design |
| Security Defaults transition | Security Defaults disabled before Conditional Access rollout | Supports deliberate control-plane transition and avoids overlapping enforcement | PR.AC | Policy consistency | Required before CA-based enforcement |
| Hybrid identity control | AD + Entra ID synchronization with scoped OU and group-based filtering | Supports controlled access and accountability | PR.AC / ID.AM | Identity governance | Pilot-first rollout approach |
| Role separation / admin discipline | pilot users and emergency admin path were separated through policy targeting and exclusion design | Supports accountability and least-risk administration | PR.AC | Role-aware control design | Administrative targeting remains intentionally narrow in Release 1 |
| Conditional Access for admin portals | CA01 targeted Microsoft Admin Portals and required MFA | Supports protection of privileged access paths | PR.AA / PR.AC | Protect administrative interfaces | Pilot-scoped, enforced after report-only review |
| Conditional Access for cloud apps | CA02 targeted all cloud apps and required MFA | Supports stronger access control across cloud services | PR.AA / PR.AC | Broader cloud-access protection | Pilot-scoped enforcement model |
| Compliant-device logic | CA03 required both MFA and a compliant device for Office 365 pilot access | Supports secure processing and device trust requirements | PR.AC / PR.PT | Device-aware access control | Links Entra policy enforcement to Intune compliance state |
| Device compliance | Intune compliance policies and managed-device validation underpin pilot compliant-device access decisions | Supports secure device processing and policy-based access control | PR.PT / DE.CM | Endpoint posture validation | Release 1 uses pilot-scale endpoint scope |
| Windows security baseline | Windows security baseline implemented through Intune and endpoint hardening work | Supports secure endpoint configuration | PR.IP | Secure configuration management | CIS-aligned hardening intent |
| Windows Update / patching intent | update-ring and patching direction documented as part of endpoint governance | Supports resilience and risk reduction | PR.IP | Vulnerability reduction | May still be expanding within Release 1 |
| BitLocker / recovery posture | device protection and recovery-oriented endpoint controls included in baseline | Supports protection and recovery capability | PR.DS / RC.RP | Data-at-rest and recovery posture | Exact evidence should match implemented state |
| Exchange hybrid migration control | Exchange hybrid configuration, migration endpoint recovery, and pilot remote moves validated successfully | Supports controlled service transition and operational resilience | PR.AC / PR.IP | Secure migration governance | Includes recovery from HCW endpoint-creation failure |
| Microsoft 365 access readiness | pilot licensing, sign-in validation, and post-migration mailbox access confirmed | Supports controlled cloud-access enablement | PR.AA / PR.AC | Access lifecycle governance | Scoped to pilot users |
| Staged rollout validation | Conditional Access policies were introduced in report-only before being switched to On | Supports safer implementation and change control | PR.IP / DE.AE | Controlled change validation | Evidence of operational maturity rather than blind enforcement |
| Sign-in visibility for access control | sign-in behavior and Conditional Access evaluation were reviewed during pilot rollout | Supports traceability and early detection of access-control outcomes | DE.AE / DE.CM | Access monitoring and validation | Evidence may include report-only views, sign-in results, and pilot access testing |
| Audit visibility | Entra, Microsoft 365, and policy-related activity reviewed as part of operational validation | Supports traceability and accountability | DE.AE | Logging and monitoring | Baseline only in Release 1 |
| Monitoring and alerting baseline | pilot monitoring linked to identity and access behavior; broader alerting direction documented | Supports early detection and operational response awareness | DE.CM / RS.AN | Baseline detection capability | Further expansion remains later in Release 1 |
| Information protection planning | sensitivity labels, DLP, SITs, and document fingerprinting remain part of Release 1 planned scope | Supports data protection and classification controls | PR.DS | Information protection | Mark as implemented only when evidence exists |
| GDPR / NIST / CIS mapping discipline | control implementation is mapped to recognized objectives with evidence-driven notes | Supports accountability and governance transparency | ID.GV / PR.IP | Governance-aligned engineering | Documentation-centered control mapping, not certification |

---

## Release 1 Identity, Access, and Endpoint Control Refresh

The following areas were materially strengthened during the pilot MFA, SSPR, and Conditional Access phase.

### Identity Control Gains

This phase added meaningful control maturity by demonstrating:

- pilot-scoped SSPR enablement
- MFA policy enforcement for high-value access paths
- staged Conditional Access rollout
- explicit emergency admin exclusion
- modern access control linked to device compliance

### Why This Matters

These additions improve the Release 1 story significantly because they show that:

- identity and access controls are no longer passive or planning-only
- endpoint state can influence access decisions
- rollout risk was managed through report-only and pilot targeting
- monitoring was used to observe control behavior, not just configuration state

---

## Notes on Release 1 Position

These controls should be represented as:

- pilot-scoped and evidence-driven
- implemented for Release 1 practical validation
- not yet full tenant-wide enterprise enforcement

The project should not claim:

- complete production-level identity governance maturity
- full enterprise-wide alert engineering
- formal compliance certification
- control coverage beyond documented evidence

Instead, the project demonstrates how identity, access, endpoint, and monitoring controls can be implemented and mapped to recognized control objectives in a staged enterprise-style rollout.

---

## Release 2 Planned Mapping

Release 2 expands controls into Azure platform governance, delegated administration, network security, and broader monitoring.

Planned examples include:

- Azure landing zone governance
- Azure Policy
- RBAC at scale
- Azure Lighthouse delegated administration
- Global Secure Access / Entra Private Access
- VPN / routing / network-control patterns
- Microsoft Sentinel onboarding
- Defender for Cloud
- expanded alerting and incident response visibility

These areas should remain clearly marked as planned until materially implemented.

---

## Release 3 Planned Mapping

Release 3 extends controls into workload modernization and resilience.

Planned examples include:

- secure workload deployment
- application segmentation
- container-security considerations
- observability
- application protection patterns
- high availability and disaster recovery design patterns

These areas should remain clearly marked as planned until materially implemented.

---

## Important Note

This project is intended as an architecture, engineering, and governance demonstration platform.

It does not claim:

- formal GDPR certification
- formal NIST certification
- formal CIS certification
- any audited regulatory attestation

Instead, it shows how practical technical controls can be mapped to recognized enterprise security and governance expectations through a staged, evidence-led implementation approach.

---

## Summary

Release 1 now demonstrates materially stronger identity, access, endpoint, and monitoring control mapping than earlier planning-only stages.

The strongest implemented mappings now include:

- hybrid identity governance
- pilot licensing and cloud-access control
- MFA and SSPR pilot rollout
- Conditional Access enforcement
- compliant-device access logic
- staged rollout discipline
- sign-in visibility and monitoring alignment

The key principle of this mapping document is simple:

**implemented controls should be mapped honestly, and planned controls should remain clearly marked as planned until supported by evidence.**
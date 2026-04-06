
# Security & Compliance Mapping

## Purpose

This document maps project controls implemented or planned within the `azawslab Enterprise Hybrid Security Platform` against common security, governance, and compliance expectations.

The purpose is not to claim full certification or formal compliance, but to demonstrate how design and implementation choices align with recognised control objectives relevant to enterprise environments.

---

## Standards / Frameworks Referenced

- GDPR
- NIST Cybersecurity Framework
- CIS Controls / CIS-aligned endpoint hardening concepts

---

## Release 1 Control Mapping

| Control Area | Implementation / Evidence | GDPR | NIST CSF | CIS / Security Intent | Notes |
|---|---|---|---|---|---|
| MFA enforcement | Entra ID Conditional Access requiring MFA | Supports protection of personal data access | PR.AA | Strong authentication | Applies to cloud identity access |
| Hybrid identity control | AD + Entra ID sync with role separation | Supports controlled access and accountability | PR.AC / ID.AM | Identity governance | Pilot-first rollout approach |
| Role separation | Global Admin / Security Admin / Intune Admin separation | Supports accountability and minimisation | PR.AC | Least privilege | Administrative separation documented |
| Device compliance | Intune compliance policies for managed endpoints | Supports secure processing and device control | PR.PT / DE.CM | Endpoint posture | Linked to Conditional Access |
| Windows security baseline | Intune security baseline configuration | Supports secure endpoint configuration | PR.IP | Secure configuration management | CIS-aligned hardening intent |
| Windows Update for Business | Update rings and patch deployment logic | Supports system resilience and risk reduction | PR.IP | Continuous vulnerability reduction | Pilot and broad deployment model |
| Attack Surface Reduction | ASR rules for endpoint hardening | Supports prevention of malicious execution paths | PR.PT / DE.CM | Malware and exploit reduction | Limited lab scope |
| OneDrive KFM | Known Folder Move for resilience and recovery | Supports availability and recovery of user data | PR.IP / RC.RP | Data resilience | Recovery-oriented control |
| Android MAM | App Protection Policies for BYOD | Supports separation and protection of organisational data | PR.DS | Data protection on mobile endpoints | BYOD scenario |
| Linux compliance support | Linux registration/compliance validation | Supports endpoint governance consistency | PR.IP | Secure administration | Supporting scope only |
| Sensitivity labels | Labels for content classification | Supports data classification and controlled sharing | PR.DS | Information protection | Lab-scale example labels |
| DLP policy | Purview DLP policy targeting sensitive content | Supports prevention of data leakage | PR.DS / DE.CM | Data loss prevention | Example GDPR-aligned scope |
| SIT-based detection | Sensitive Information Types in policy logic | Supports detection of regulated data patterns | DE.CM | Content inspection | Example UK/EU data patterns |
| Document fingerprinting | Fingerprint example for protected form/template | Supports document-aware protection | PR.DS | Content-based protection | Scenario-based evidence |
| Audit visibility | Entra, M365, and device-related logging | Supports traceability and accountability | DE.AE | Logging and monitoring | Baseline only in Release 1 |
| Alerting baseline | Example alert for high-risk sign-in or non-compliant device | Supports incident visibility | DE.CM / RS.AN | Early detection | Expanded in Release 2 |

---

## Release 2 Planned Mapping

Release 2 expands controls into Azure platform governance and network security, including:

- Azure landing zone governance
- Azure Policy
- RBAC at scale
- Azure Lighthouse delegated administration
- Global Secure Access
- VPN / routing / monitoring controls
- Microsoft Sentinel onboarding
- Defender for Cloud
- Expanded alerting and incident response playbooks

---

## Release 3 Planned Mapping

Release 3 extends controls into workload modernisation and resilience, including:

- Secure workload deployment
- Application segmentation
- Container security
- Observability
- WAF / application protection
- High availability and disaster recovery design patterns

---

## Important Note

This project is intended as an architecture, engineering, and governance demonstration platform. It does not claim formal compliance certification against GDPR, NIST, CIS, or any regulatory standard.

Instead, it shows how practical technical controls can be mapped to recognised enterprise security and governance expectations.

# Security and Compliance Mapping

**Navigation:** [README](../README.md) | [Release 1 Build Checklist](16-release1-build-checklist.md) | [Release 1 Final Summary](17-release1-final-summary.md)

**Related docs:** [Hybrid Identity](05-hybrid-identity.md) | [Modern Workplace](06-m365-modern-workplace.md) | [Endpoint Security and Intune](07-endpoint-security-intune.md) | [Information Protection and Purview](10-information-protection-purview.md) | [Monitoring and Alerting](11-monitoring-alerting.md) | [Lessons Learned](15-lessons-learned.md)

---

## Purpose

This document maps the implemented Release 1 controls in the `azawslab Enterprise Hybrid Security Platform` to recognizable security and compliance themes.

It is **not** a formal audit, certification, or legal compliance statement.

Instead, it shows how the technical controls implemented in Release 1 align with common requirements and good practice drawn from:

- GDPR-oriented security and governance expectations
- NIST-style security control thinking
- CIS-style baseline hardening and operational discipline

The purpose is to help readers understand that the project is not only a lab build, but also a control-aware platform implementation.

---

## How to Read This Document

This mapping is intentionally practical.

Each row links:

- a Release 1 control area
- what was implemented
- the main business/security purpose
- representative alignment themes
- where to verify the implementation in the project documentation

This should be read as a **control mapping and design-awareness document**, not as a claim of formal compliance attestation.

---

## Scope Boundary

This mapping covers **implemented Release 1 controls** and the main supporting governance logic behind them.

It does **not** claim:

- full enterprise policy maturity
- formal ISO 27001 control ownership
- full GDPR legal interpretation
- complete NIST 800-53 mapping depth
- complete CIS Benchmark implementation depth
- formal audit readiness

Later phases may deepen this mapping, but Release 1 focuses on evidence-backed baseline alignment.

---

## Release 1 Mapping Summary

At a high level, Release 1 demonstrates control alignment across these themes:

- identity and access control
- secure configuration and hardening
- hybrid messaging security and trust
- endpoint enrollment and compliance
- encryption and recovery preparedness
- information protection and retention awareness
- monitoring and operational visibility
- evidence-backed administrative governance

---

## Control Mapping Table

| Release 1 Area | Implemented Control / Capability | Primary Security or Compliance Purpose | Example Alignment Themes | Main Evidence / Docs |
|---|---|---|---|---|
| Core identity foundation | Active Directory domain services, DC1/DC2, DNS, replication, tiered OU structure | Establish authoritative identity source and controlled admin structure | Identity governance, least privilege structure, secure admin boundary thinking | `03-current-state-architecture.md`, `05-hybrid-identity.md`, `16-release1-build-checklist.md` |
| Hybrid identity | Entra Connect Sync with Password Hash Synchronization, pilot sync scoping, group-based filtering | Control which identities reach cloud services and reduce unnecessary sync scope | Identity lifecycle control, scoped synchronization, cloud identity governance | `05-hybrid-identity.md`, `16-release1-build-checklist.md` |
| Namespace governance | Separation of `azawslab.co.uk` and `corp.azawslab.co.uk` | Reduce business disruption while enabling controlled hybrid pilot execution | Change control, service continuity, staged migration governance | `05-hybrid-identity.md`, `06-m365-modern-workplace.md`, `README.md` |
| Hybrid messaging trust | Public-trust SAN certificate covering `mail` and `exch1`, IIS binding correction, hybrid troubleshooting | Ensure externally trusted hybrid service presentation and successful migration readiness | Certificate governance, secure service trust, transport/service assurance | `05-hybrid-identity.md`, `15-lessons-learned.md`, `16-release1-build-checklist.md` |
| Exchange hybrid migration | Modern Hybrid, Hybrid Agent, migration endpoint recovery, remote move validation, pilot mailbox migration | Secure staged migration from on-premises messaging to Exchange Online | Secure transition planning, service migration governance, operational validation | `06-m365-modern-workplace.md`, `15-lessons-learned.md`, `16-release1-build-checklist.md` |
| Collaboration baseline | Teams and SharePoint pilot validation | Prove modern workplace services are available in a controlled pilot scope | Collaboration governance, controlled rollout, service validation | `06-m365-modern-workplace.md`, `16-release1-build-checklist.md` |
| Intune endpoint onboarding | Windows corporate, Windows BYOD, Linux, iPhone enrollment | Bring endpoints into managed visibility and administrative control | Asset visibility, endpoint governance, device management baseline | `07-endpoint-security-intune.md`, `08-endpoint-platforms-and-enrollment.md`, `16-release1-build-checklist.md` |
| Ownership-aware endpoint management | Corporate vs personal device distinction in Intune | Differentiate governance and control expectations by ownership model | Data protection proportionality, BYOD governance, policy scoping | `08-endpoint-platforms-and-enrollment.md`, `16-release1-build-checklist.md` |
| Compliance control | Windows compliance policy baseline | Evaluate whether devices meet required security conditions before trust is extended | Device compliance, configuration governance, access-condition enforcement | `09-endpoint-compliance-and-security-baseline.md`, `16-release1-build-checklist.md` |
| Secure configuration baseline | Windows security baseline, configuration profiles, update rings | Move managed endpoints toward a controlled, hardened, and maintainable state | Secure configuration, patch governance, baseline hardening | `09-endpoint-compliance-and-security-baseline.md`, `16-release1-build-checklist.md` |
| Endpoint protection | Defender baseline, antivirus policy, ASR policy, ransomware-resilience controls | Reduce endpoint attack surface and improve malware/ransomware resistance | Malware protection, attack-surface reduction, resilience | `09-endpoint-compliance-and-security-baseline.md`, `16-release1-build-checklist.md` |
| Encryption and recoverability | BitLocker policy path, recovery-key escrow, recovery-key retrieval evidence | Protect device storage while preserving recovery capability | Encryption at rest, recoverability, key-management governance | `09-endpoint-compliance-and-security-baseline.md`, `14-advanced-recovery-scenarios.md`, `16-release1-build-checklist.md` |
| Endpoint lifecycle recovery | Rebuild, re-enrollment, stale-record cleanup | Restore secure management state after disruptive recovery events | Asset lifecycle control, recovery operations, inventory hygiene | `14-advanced-recovery-scenarios.md`, `15-lessons-learned.md`, `16-release1-build-checklist.md` |
| Local admin recovery direction | Windows LAPS policy implementation and assignment | Improve endpoint recovery posture and local admin governance | Privileged access control, recovery preparedness, endpoint supportability | `09-endpoint-compliance-and-security-baseline.md`, `15-lessons-learned.md`, `16-release1-build-checklist.md` |
| Identity protection | MFA, SSPR, Conditional Access, break-glass exclusion thinking | Strengthen identity assurance and access control for cloud workloads | Strong authentication, account recovery control, conditional access, Zero Trust | `05-hybrid-identity.md`, `11-monitoring-alerting.md`, `16-release1-build-checklist.md` |
| Device-based access control | Compliant-device access logic for Microsoft 365 pilot scope | Tie endpoint state to access-control decisions | Zero Trust, device trust, conditional access enforcement | `09-endpoint-compliance-and-security-baseline.md`, `11-monitoring-alerting.md`, `16-release1-build-checklist.md` |
| Linux operational governance | Linux visibility through Intune plus baseline automation with Ansible | Extend governance beyond Windows and prove platform diversity with control | Mixed-platform administration, configuration automation, operational consistency | `08-endpoint-platforms-and-enrollment.md`, `15-lessons-learned.md`, `16-release1-build-checklist.md` |
| Mobile governance baseline | Apple MDM Push Certificate and iPhone BYOD enrollment | Establish controlled mobile management path with required platform trust prerequisite | Mobile device governance, BYOD onboarding, platform prerequisite awareness | `08-endpoint-platforms-and-enrollment.md`, `15-lessons-learned.md`, `16-release1-build-checklist.md` |
| Information classification | Sensitivity labels and label publishing | Classify information and make handling expectations visible to users | Data classification, information governance, user awareness | `10-information-protection-purview.md`, `16-release1-build-checklist.md` |
| Data loss prevention | U.K. Financial Data DLP policy and policy-tip validation | Detect sensitive content and trigger user-visible protection behavior | Data protection, policy enforcement, content-aware control | `10-information-protection-purview.md`, `16-release1-build-checklist.md` |
| Retention awareness | Retention-policy baseline | Begin governance of information lifecycle, not just access and labeling | Retention governance, lifecycle awareness, information stewardship | `10-information-protection-purview.md`, `16-release1-build-checklist.md` |
| Monitoring baseline | Entra visibility, device visibility, Purview visibility, sign-in logs, audit logs, example alerting evidence | Establish operational visibility and control-state awareness | Logging, monitoring, administrative review, early detection | `11-monitoring-alerting.md`, `16-release1-build-checklist.md` |
| Evidence governance | Structured screenshot archive, diagrams, scripts, Ansible files, lessons learned | Improve traceability, verification, and professional presentation of implemented controls | Auditability, documentation discipline, evidence management | `README.md`, `15-lessons-learned.md`, `16-release1-build-checklist.md` |

---

## GDPR-Oriented Alignment Themes

Release 1 is not a GDPR compliance certification project, but several implemented controls align well with GDPR-style security and accountability expectations.

### Relevant themes demonstrated

- controlled identity and access management
- conditional access and strong authentication
- encryption and recoverability
- endpoint compliance and security baselines
- information classification and DLP
- retention-awareness through Purview
- logging and administrative visibility
- documented design decisions and evidence preservation

### Practical interpretation

The project demonstrates that Release 1 was designed with:

- confidentiality
- integrity
- recoverability
- accountability
- administrative traceability

in mind.

That is the correct level of GDPR-oriented claim for this repository.

---

## NIST-Oriented Alignment Themes

Release 1 also maps well to broad NIST-style control thinking, especially around:

- identity and access control
- system and communications trust
- secure configuration
- audit and accountability
- system monitoring
- media / storage protection through BitLocker
- incident/recovery readiness in the endpoint lifecycle story

### Practical interpretation

The project does not attempt a full NIST catalog mapping.

Instead, it demonstrates that Release 1 includes practical controls in the spirit of:

- access control
- auditability
- secure system configuration
- protected data handling
- recovery-oriented administration

That is a strong and defensible alignment position.

---

## CIS-Oriented Alignment Themes

Release 1 also aligns well with CIS-style baseline thinking, especially through:

- secure administrative structure
- endpoint baseline hardening
- antivirus and ASR controls
- patching / update-ring direction
- MFA and access hardening
- inventory visibility
- logging and review visibility
- control documentation discipline

### Practical interpretation

The project does not claim benchmark-by-benchmark CIS implementation.

It does show that Release 1 follows CIS-style priorities such as:

- secure configuration
- controlled asset visibility
- strong authentication
- malware protection
- recovery preparedness
- evidence-backed administration

---

## What This Mapping Does Not Claim

To keep the project credible, this mapping does **not** claim:

- formal compliance certification
- legal assurance of GDPR completeness
- complete NIST control-family implementation
- complete CIS Benchmark hardening depth
- complete mobile governance maturity
- full production SOC/IR maturity
- full records-management maturity

This mapping is best understood as a **technical control-alignment view** of what Release 1 implemented and evidenced.

---

## Strongest Release 1 Alignment Areas

The strongest control-alignment areas in Release 1 are:

### 1. Hybrid identity and access control
Because the project demonstrates:
- AD + Entra integration
- pilot sync scoping
- MFA
- SSPR
- Conditional Access
- device-based access logic

### 2. Endpoint governance and recovery awareness
Because the project demonstrates:
- mixed-platform management
- compliance policy
- security baseline
- BitLocker escrow
- rebuild / stale-record cleanup
- LAPS design awareness

### 3. Information protection baseline
Because the project demonstrates:
- labels
- DLP
- retention baseline
- visible user-facing content controls

### 4. Evidence-backed operational visibility
Because the project demonstrates:
- administrative visibility
- sign-in and audit review baseline
- endpoint and policy-state visibility
- lessons learned with supporting evidence

---

## Control Gaps and Deferred Areas

The following areas are intentionally not overstated and may remain future or deferred maturity items:

- Android BYOD / MAM scenario
- full document fingerprinting availability if feature readiness remains blocked
- deeper LAPS retrieval/recovery validation if not fully evidenced
- broader formalized alert-response workflow
- later Release 2 Azure governance and Sentinel work
- later Release 3 workload security and resilience depth

These do not invalidate Release 1. They simply define its maturity boundary clearly.

---

## How This Supports the Portfolio

This mapping strengthens the overall portfolio because it shows that the project is not just a collection of screenshots and admin tasks.

It demonstrates:

- control awareness
- security reasoning
- governance thinking
- evidence discipline
- realistic boundary-setting around what is and is not implemented

That makes the repository stronger for both:

- technical reviewers
- recruiters or hiring managers who want to see that the work maps to real enterprise priorities

---

## Reader Guide

Use this page together with:

- [Release 1 Build Checklist](16-release1-build-checklist.md) for implementation status
- [Release 1 Final Summary](17-release1-final-summary.md) for the closeout narrative
- [Hybrid Identity](05-hybrid-identity.md) for identity and certificate-trust design
- [Endpoint Security and Intune](07-endpoint-security-intune.md) for endpoint lifecycle and governance
- [Information Protection and Purview](10-information-protection-purview.md) for labels, DLP, and retention
- [Monitoring and Alerting](11-monitoring-alerting.md) for visibility and review baseline
- [Lessons Learned](15-lessons-learned.md) for operational design lessons

---

## Summary

Release 1 demonstrates meaningful alignment with common enterprise security and compliance expectations across:

- identity and access control
- secure configuration
- endpoint governance
- encryption and recovery preparedness
- content protection
- retention awareness
- monitoring and audit visibility
- documentation and evidence governance

This mapping should be read as a **practical control-alignment view** of the Release 1 implementation, not as a formal compliance attestation.
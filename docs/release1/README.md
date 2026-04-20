# Release 1 - Hybrid Microsoft Platform Foundation

Release 1 is the most complete and strongly evidenced phase of the project. It establishes the hybrid Microsoft foundation of the platform across identity, messaging, collaboration, endpoint management and security, information protection, monitoring, and operational recovery.

This phase is designed to demonstrate more than initial setup. It focuses on **validated delivery**, **supportable operations**, and **scope-controlled engineering** across a small-enterprise hybrid environment built and tested in a local lab.

> **For recruiters:** This release maps directly to Modern Workplace, Intune, Entra ID, and Microsoft 365 roles. See the [Skills and Evidence Index](../foundation/05-skills-and-evidence-index.md) for capability-to-proof mapping.

---

## What Release 1 Delivers

This phase delivers a functional hybrid platform spanning:

- **Platform foundation** built on Hyper-V with internal switching, host NAT, differencing-disk reuse, and multi-VM orchestration
- **Hybrid identity** using Active Directory, Microsoft Entra ID, and Entra Connect Sync with controlled pilot scope
- **Modern Workplace baseline** across Exchange hybrid, Exchange Online, Teams, and SharePoint
- **Endpoint management** for Windows corporate, Windows BYOD, Ubuntu Linux, and iPhone BYOD scenarios
- **Endpoint compliance and security** using Intune compliance policies, security baselines, Defender Antivirus, Attack Surface Reduction (ASR), BitLocker controls, and update policies
- **Information protection** through Purview sensitivity labels, DLP policy-tip validation, and retention configuration
- **Monitoring and operational visibility** through sign-in logs, audit logs, device status reviews, and control visibility
- **Operational recovery** through BitLocker recovery, stale-record cleanup, device rebuilds, and re-enrollment validation

---

## What This Release Proves

Release 1 proves that the project is not just a collection of cloud portal configurations. It demonstrates a connected hybrid platform with visible validation and operational realism. Specifically, this release proves:

- hybrid identity can be introduced in a controlled way without treating synchronization as an all-or-nothing event
- Exchange hybrid and Microsoft 365 baseline services can be validated with pilot-first discipline rather than broad unsupported claims
- endpoint onboarding can be separated by ownership model and operating system while maintaining a coherent control strategy
- compliance and endpoint security controls can be tied to visible device state and recovery outcomes
- information protection controls can be validated through user-visible behavior rather than policy definition alone
- troubleshooting and recovery are treated as core platform capabilities, not afterthoughts

---

## Why It Matters

From an operational perspective, this release demonstrates:

- **risk reduction** through device trust, compliance, and policy enforcement
- **control maturity** through identity, endpoint, and information protection baselines
- **supportability** through monitoring, visibility, and recovery scenarios
- **engineering judgment** through phased scoping, honest limitations, and evidence-backed claims

---

## Main Capability Areas

### 1. Hybrid Identity and Access

Establishes a controlled hybrid identity path between on-premises Active Directory and Microsoft Entra ID. It includes Entra Connect Sync design choices, pilot scoping, synchronization filtering, and the supporting identity-control baseline around Conditional Access, MFA, SSPR, and related protection controls.

- **Documentation:** [Hybrid Identity](01-hybrid-identity.md)
- **Evidence:** [Identity and Access Evidence Hub](../../screenshots/release1/identity-and-access/README.md)

### 2. Modern Workplace

Validates the Microsoft 365 service baseline through Exchange hybrid migration readiness and pilot mailbox validation, supported by baseline collaboration proof across Teams and SharePoint.

- **Documentation:** [Modern Workplace](02-modern-workplace.md)
- **Evidence:** [Modern Workplace Evidence Hub](../../screenshots/release1/modern-workplace/README.md)

### 3. Endpoint Management

Demonstrates endpoint onboarding and lifecycle handling across multiple ownership and platform scenarios. The goal is to prove a realistic, supportable endpoint estate rather than claiming every possible client-management capability.

- **Documentation:** [Endpoint Overview](03-endpoint-overview.md) | [Endpoint Enrollment](04-endpoint-enrollment.md)
- **Evidence:** [Endpoint Management Hub](../../screenshots/release1/endpoint-management/README.md) | [Intune Hub](../../screenshots/release1/endpoint-management/intune/README.md)

### 4. Endpoint Compliance and Security

Shows how endpoint trust is enforced through compliance policy, security baselines, Defender AV, ASR, BitLocker controls, Windows Update for Business, and device-state visibility. It keeps careful scope boundaries around areas that are configured but not fully validated at a broader enterprise depth.

- **Documentation:** [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md)
- **Evidence:** [Intune Evidence Hub](../../screenshots/release1/endpoint-management/intune/README.md)

### 5. Recovery and Operational Resilience

Treats non-happy-path recovery as first-class evidence of operational realism. Includes BitLocker recovery, stale device cleanup, re-enrollment, and restored compliance.

- **Documentation:** [Recovery Scenarios](06-recovery-scenarios.md)
- **Evidence:** [Intune Evidence Hub](../../screenshots/release1/endpoint-management/intune/README.md)

### 6. Information Protection

Introduces a practical Purview baseline focused on visible and validated controls rather than inflated governance claims. Sensitivity labels, DLP, and retention are positioned as implemented controls with clear boundaries around advanced future work.

- **Documentation:** [Purview](07-purview.md)
- **Evidence:** [Information Protection Evidence Hub](../../screenshots/release1/information-protection/README.md)

### 7. Monitoring and Operations

Demonstrates visibility across sign-in activity, audit events, device state, and control review, proving the platform is operationally credible and supportable.

- **Documentation:** [Monitoring](08-monitoring.md)
- **Evidence:** [Monitoring and Operations Evidence Hub](../../screenshots/release1/monitoring-and-operations/README.md)

---

## Suggested Reading Order

For the most efficient path through Release 1, use this reading order:

1. [Release 1 Summary](00-summary.md)
2. [Hybrid Identity](01-hybrid-identity.md)
3. [Modern Workplace](02-modern-workplace.md)
4. [Endpoint Enrollment](04-endpoint-enrollment.md)
5. [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md)
6. [Recovery Scenarios](06-recovery-scenarios.md)
7. [Purview](07-purview.md)
8. [Monitoring](08-monitoring.md)

For a fuller view of implementation completeness and future scope:

- [Build Checklist](11-build-checklist.md)
- [Extensions and Future Enhancements](12-extensions-and-future-enhancements.md)

---

## Flagship Evidence

| Strongest Proof | Where to See It |
| :--- | :--- |
| Exchange hybrid pilot validation and post-migration mailbox access | `screenshots/release1/modern-workplace/exchange-hybrid/` |
| Corporate Windows endpoint enrolled and shown as compliant in Intune | `screenshots/release1/endpoint-management/intune/intune-windows-corp/` |
| DLP policy-tip triggering in Microsoft Word against test financial data | `screenshots/release1/information-protection/purview/purview-dlp/` |
| BitLocker recovery-key retrieval and restored compliant state after recovery workflow | `screenshots/release1/endpoint-management/intune/intune-bitlocker-recovery-scenario/` |
| Entra sign-in and audit visibility tied to access and device controls | `screenshots/release1/monitoring-and-operations/monitoring/` |

For a guided proof path, start with:

- [Release 1 Evidence Dashboard](../../screenshots/release1/README.md)

---

## Scope Transparency

Release 1 is intentionally strong on implemented hybrid Microsoft delivery, but it does not claim full maturity in every adjacent area. Examples of deferred or carefully scoped areas include:

- Android BYOD / MAM validation
- Windows Autopilot / ESP optimization
- advanced Purview capabilities such as document fingerprinting or broader automation
- full enterprise PKI / AD CS deployment
- broader Azure platform security engineering reserved for Release 2
- secure workload modernization capabilities reserved for Release 3

This boundary is intentional. Release 1 should be read as an **implemented and evidenced foundation**, not as an attempt to claim all future platform capabilities at once.

---

## Supporting Documents

- [Release 1 Summary](00-summary.md)
- [Compliance Mapping](09-compliance-mapping.md)
- [Lessons Learned](10-lessons-learned.md)
- [Build Checklist](11-build-checklist.md)
- [Extensions and Future Enhancements](12-extensions-and-future-enhancements.md)

For cross-release context, refer back to:

- [Platform Overview](../foundation/01-platform-overview.md)
- [Target-State Architecture](../foundation/03-target-state-architecture.md)
- [Roadmap](../foundation/04-roadmap.md)
- [Skills and Evidence Index](../foundation/05-skills-and-evidence-index.md)
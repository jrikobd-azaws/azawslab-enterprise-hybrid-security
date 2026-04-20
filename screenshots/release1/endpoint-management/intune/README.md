# Intune Evidence Hub

## Purpose

This page is the guided evidence index for the Intune portion of the implemented platform.

It exists to make the Intune screenshot archive easier to review by grouping evidence into the main operational areas:
- Windows corporate onboarding
- Windows BYOD onboarding
- iPhone BYOD onboarding
- Ubuntu Linux visibility
- compliance policy
- security baseline and protection controls
- Windows Update for Business
- BitLocker recovery and lifecycle correction

This page should be read as an evidence hub, not as a narrative implementation document.

---

## What This Evidence Set Proves

The Intune evidence demonstrates that the platform did more than enroll devices. It shows that the managed estate included:

- ownership-aware onboarding for corporate and personal Windows devices
- mobile onboarding through Company Portal
- Linux visibility in the endpoint estate
- compliance-state evaluation
- baseline hardening and protection-policy coverage
- update governance
- BitLocker recovery-key support
- restored compliant state after disruption and re-enrollment

This makes Intune one of the strongest evidence areas in the repository.

---

## How to Use This Hub

Use this page in one of three ways:

- **Start with flagship proof** if you want the shortest route to the most important screenshots
- **Browse by scenario** if you want to inspect one device or control path at a time
- **Follow the related docs** if you want the implementation story behind the evidence

This hub is designed to reduce click fatigue while preserving access to the deeper raw screenshot folders.

---

## Start Here: Flagship Proof

| Proof Area | What it demonstrates | Best evidence |
| :--- | :--- | :--- |
| **Corporate Windows compliant state** | Managed Windows endpoint enrolled and shown as compliant | [Corporate Windows compliant in Intune](intune-windows-corp/08-intune-windows-device-compliant.png) |
| **Corporate vs BYOD distinction** | Ownership-aware device handling in one managed estate | [Corporate and BYOD visibility](intune-windows-byod/05-intune-windows-devices-corp-and-byod.png) |
| **Compliance enforcement** | Device trust is evaluated, not assumed | [Compliance policy non-compliant result](intune-compliance-policy/04-compliance-policy-results-overview-noncompliant.png) |
| **Security baseline** | Managed hardening through policy assignment | [Security baseline assigned groups](intune-security-baseline/01-security-baseline-assigned-groups.png) |
| **WUfB assignment** | Update governance is part of the endpoint control model | [WUfB pilot assignment](intune-windows-update/02-wufb-updatering-pilot-assignment.png) |
| **BitLocker recovery support** | Recovery-key visibility tied to the managed cloud record | [BitLocker recovery key in cloud record](intune-bitlocker-recovery-scenario/02-win11-corp01-entra-bitlocker-recovery-key.png) |
| **Recovered compliant state** | Managed trust restored after rebuild and re-enrollment | [Compliance restored after re-enrollment](intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png) |

---

## Evidence by Scenario

### 1. Windows Corporate

This area contains the strongest end-to-end managed Windows evidence.

It supports:
- corporate enrollment
- compliant-state visibility
- stronger policy expectation
- recovery-readiness linkage

Start here:
- [Windows Corporate Folder](intune-windows-corp/)

Best evidence:
- [Corporate Windows compliant in Intune](intune-windows-corp/08-intune-windows-device-compliant.png)

Related docs:
- [Endpoint Overview](../../../docs/release1/03-endpoint-overview.md)
- [Endpoint Enrollment](../../../docs/release1/04-endpoint-enrollment.md)
- [Endpoint Compliance and Security](../../../docs/release1/05-endpoint-compliance-and-security.md)

---

### 2. Windows BYOD

This area shows that personal Windows onboarding was treated differently from corporate ownership.

It supports:
- ownership distinction
- personal-device representation in the managed estate
- broader endpoint realism beyond corporate-only management

Start here:
- [Windows BYOD Folder](intune-windows-byod/)

Best evidence:
- [Corporate and BYOD visibility](intune-windows-byod/05-intune-windows-devices-corp-and-byod.png)

Related docs:
- [Endpoint Overview](../../../docs/release1/03-endpoint-overview.md)
- [Endpoint Enrollment](../../../docs/release1/04-endpoint-enrollment.md)

---

### 3. iPhone BYOD

This area shows that mobile onboarding was included through Company Portal-based enrollment.

It supports:
- mobile identity-linked access
- BYOD onboarding beyond Windows
- broader endpoint-estate realism

Start here:
- [iPhone BYOD Folder](intune-ios/iphone13-byod-enrollment/)

Best evidence:
- [iPhone BYOD enrollment complete](intune-ios/iphone13-byod-enrollment/14-company-portal-enrollment-complete.png)

Related docs:
- [Endpoint Enrollment](../../../docs/release1/04-endpoint-enrollment.md)

---

### 4. Ubuntu Linux

This area shows that the endpoint estate was not treated as Windows-only.

It supports:
- platform diversity
- Linux visibility in the managed story
- broader endpoint maturity beyond default Microsoft desktop paths

Start here:
- [Ubuntu Linux Folder](intune-linux/)

Best evidence:
- [Ubuntu Linux device visible in Intune](intune-linux/08-intune-linux-device-visible.png)

Related docs:
- [Endpoint Overview](../../../docs/release1/03-endpoint-overview.md)
- [Endpoint Enrollment](../../../docs/release1/04-endpoint-enrollment.md)

---

### 5. Compliance Policy

This area contains the clearest proof that device trust was evaluated.

It supports:
- non-compliant state visibility
- compliant-state logic
- device trust as an assessed condition

Start here:
- [Compliance Policy Folder](intune-compliance-policy/)

Best evidence:
- [Compliance policy non-compliant result](intune-compliance-policy/04-compliance-policy-results-overview-noncompliant.png)

Related docs:
- [Endpoint Compliance and Security](../../../docs/release1/05-endpoint-compliance-and-security.md)

---

### 6. Security Baseline and Protection Controls

This area supports the hardening story through:
- security baseline assignment
- Defender Antivirus baseline coverage
- Attack Surface Reduction policy coverage

Start here:
- [Security Baseline Folder](intune-security-baseline/)
- [ASR Policy Folder](intune-security-baseline/asr-policy/)

Best evidence:
- [Security baseline assigned groups](intune-security-baseline/01-security-baseline-assigned-groups.png)

Related docs:
- [Endpoint Compliance and Security](../../../docs/release1/05-endpoint-compliance-and-security.md)

---

### 7. Windows Update for Business

This area shows that update governance was included in the endpoint control model.

It supports:
- policy-driven update handling
- managed lifecycle thinking
- endpoint trust as an ongoing state rather than a one-time setup

Start here:
- [Windows Update Folder](intune-windows-update/)

Best evidence:
- [WUfB pilot assignment](intune-windows-update/02-wufb-updatering-pilot-assignment.png)

Related docs:
- [Endpoint Compliance and Security](../../../docs/release1/05-endpoint-compliance-and-security.md)

---

### 8. BitLocker Recovery and Lifecycle Correction

This is one of the strongest evidence areas in the whole repository.

It supports:
- trust-break handling
- recovery-key visibility
- rebuild and re-enrollment
- stale-record cleanup
- restored compliant state

Start here:
- [BitLocker Recovery Scenario Folder](intune-bitlocker-recovery-scenario/)

Best evidence:
- [BitLocker recovery prompt](intune-bitlocker-recovery-scenario/01-win11-corp01-bitlocker-recovery-prompt.png)
- [Recovery key visible in cloud record](intune-bitlocker-recovery-scenario/02-win11-corp01-entra-bitlocker-recovery-key.png)
- [Duplicate corporate records visible](intune-bitlocker-recovery-scenario/05-intune-windows-devices-duplicate-corp-records.png)
- [Compliance restored after re-enrollment](intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png)

Related docs:
- [Recovery Scenarios](../../../docs/release1/06-recovery-scenarios.md)
- [Endpoint Compliance and Security](../../../docs/release1/05-endpoint-compliance-and-security.md)

---

## Recommended Review Path

If you want the shortest high-value path through the Intune evidence, use this order:

1. [Corporate Windows compliant in Intune](intune-windows-corp/08-intune-windows-device-compliant.png)
2. [Corporate and BYOD visibility](intune-windows-byod/05-intune-windows-devices-corp-and-byod.png)
3. [Compliance policy non-compliant result](intune-compliance-policy/04-compliance-policy-results-overview-noncompliant.png)
4. [Security baseline assigned groups](intune-security-baseline/01-security-baseline-assigned-groups.png)
5. [WUfB pilot assignment](intune-windows-update/02-wufb-updatering-pilot-assignment.png)
6. [Recovery key visible in cloud record](intune-bitlocker-recovery-scenario/02-win11-corp01-entra-bitlocker-recovery-key.png)
7. [Compliance restored after re-enrollment](intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png)

This sequence gives the fastest view of:
- onboarding
- ownership distinction
- compliance
- hardening
- update governance
- recovery realism

---

## Relationship to the Documentation

Use the documentation when you want:
- rationale
- architecture
- scope boundaries
- business value
- implementation story

Use this evidence hub when you want:
- visible policy state
- managed-device proof
- onboarding outcomes
- recovery proof
- fast verification of endpoint claims

Best related reading path:
- [Release 1 README](../../../docs/release1/README.md)
- [Endpoint Overview](../../../docs/release1/03-endpoint-overview.md)
- [Endpoint Enrollment](../../../docs/release1/04-endpoint-enrollment.md)
- [Endpoint Compliance and Security](../../../docs/release1/05-endpoint-compliance-and-security.md)
- [Recovery Scenarios](../../../docs/release1/06-recovery-scenarios.md)

---

## Scope Boundaries

This evidence set is strong, but it should be read carefully.

It does **not** imply that every adjacent endpoint capability is already complete.

Examples of deferred or partial areas include:
- Android BYOD / MAM
- Windows Autopilot / ESP optimization
- deeper Defender product-stack claims beyond baseline control coverage
- stronger LAPS operational validation beyond cautious policy discussion

Those boundaries are documented in:
- [Build Checklist](../../../docs/release1/11-build-checklist.md)
- [Extensions and Future Enhancements](../../../docs/release1/12-extensions-and-future-enhancements.md)

---

## Related Pages

- [Endpoint Management Evidence Hub](../README.md)
- [Release 1 Evidence Dashboard](../../README.md)
- [Skills and Evidence Index](../../../docs/foundation/05-skills-and-evidence-index.md)
- [Root README](../../../README.md)



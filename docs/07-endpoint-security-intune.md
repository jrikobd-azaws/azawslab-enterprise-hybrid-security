# Endpoint Security and Intune

**Navigation:** [README](../README.md) | [Release 1 Build Checklist](16-release1-build-checklist.md) | [Release 1 Final Summary](17-release1-final-summary.md)

**Related endpoint docs:** [Endpoint Platforms and Enrollment](08-endpoint-platforms-and-enrollment.md) | [Endpoint Compliance and Security Baseline](09-endpoint-compliance-and-security-baseline.md) | [Advanced Recovery Scenarios](14-advanced-recovery-scenarios.md)

---

## Purpose

This document is the **overview and navigation page** for the Release 1 endpoint workstream in the `azawslab Enterprise Hybrid Security Platform`.

Release 1 endpoint work is no longer limited to simple device enrollment. It now demonstrates a broader lifecycle across:

- device onboarding
- platform-specific management paths
- compliance evaluation
- security baseline application
- identity protection dependency
- operational recovery lessons

This page provides the high-level endpoint story and links to the detailed supporting documents.

---

## What This Endpoint Workstream Demonstrates

Release 1 endpoint implementation now demonstrates:

- Microsoft Intune tenant baseline activation
- Windows 11 corporate-managed enrollment
- Windows 11 personal / BYOD enrollment
- Ubuntu Linux visibility through Intune plus baseline automation through Ansible
- iPhone BYOD enrollment through Company Portal
- Windows compliance policy evaluation
- Windows security baseline assignment
- BitLocker recovery-key escrow and recovery validation
- Conditional Access dependency on compliant-device state
- operational lessons from rebuild, re-enrollment, and stale-record cleanup

This gives the project a more realistic enterprise endpoint story than a single-device or Windows-only lab.

---

## Release 1 Endpoint Scope

The Release 1 endpoint scope includes four platform / scenario paths:

### Windows corporate-managed
- `WIN11-CORP01`
- enrolled as a corporate-owned device
- managed by Intune
- used for compliance, security baseline, BitLocker, and recovery scenario testing

### Windows personal / BYOD
- `WIN11-BYOD01`
- enrolled as a personal device
- managed by Intune
- used to validate ownership distinction and pilot compliance behavior

### Ubuntu Linux
- Ubuntu endpoint visible through Intune / Entra
- Linux management visibility validated
- baseline automation extended through Ansible

### iPhone BYOD
- Apple MDM Push Certificate prerequisite completed
- iPhone enrolled through Intune Company Portal
- visible in Intune and Entra
- compliant state validated

---

## Endpoint Lifecycle Narrative

Release 1 should be understood as an **endpoint lifecycle story**, not just a list of controls.

### 1. Devices were enrolled
The project validated multiple enrollment paths:
- Windows corporate
- Windows BYOD
- Ubuntu Linux
- iPhone BYOD

### 2. Devices became visible and manageable
The devices were brought into:
- Microsoft Intune
- Microsoft Entra ID

This established management visibility, ownership context, and pilot device inventory.

### 3. Devices were assessed for compliance
Windows pilot devices were evaluated against a defined compliance policy baseline, and device state was used as part of the security-control story.

### 4. Security baseline controls were applied
The Windows security baseline was assigned to pilot device groups, adding a first hardening layer beyond enrollment alone.

### 5. Identity protection controls began to matter
MFA, SSPR, and Conditional Access became relevant because endpoint state was now part of the access-control model, especially for compliant-device logic in Microsoft 365 pilot scope.

### 6. Recovery and lifecycle management were tested
The BitLocker / rebuild / stale-record scenario proved that endpoint operations include:
- recovery-key escrow
- re-enrollment
- duplicate-object cleanup
- local admin recovery design considerations such as Windows LAPS

This is what makes the endpoint story much more mature than simple enrollment screenshots.

---

## Current Endpoint Position in Release 1

The endpoint workstream is now beyond basic setup.

### Implemented and validated
- Intune tenant baseline
- EMS E5 trial path for management capability
- Windows 11 corporate device onboarding
- Windows 11 BYOD device onboarding
- Linux Intune visibility
- Ansible baseline automation for Linux
- iPhone BYOD enrollment
- Windows compliance policy
- Windows security baseline
- BitLocker recovery-key escrow and recovery scenario
- MFA / SSPR / Conditional Access pilot dependency on identity and endpoint state

### Still maturing
- Windows LAPS password retrieval and recovery validation
- configuration profiles
- update rings
- Defender hardening
- deeper monitoring and alerting
- broader negative-path Conditional Access testing

---

## Document Map for This Workstream

Use the following pages to navigate the endpoint implementation:

### [08-endpoint-platforms-and-enrollment.md](08-endpoint-platforms-and-enrollment.md)
Detailed enrollment and management stories for:
- Windows corporate
- Windows BYOD
- Linux Intune
- iPhone BYOD

### [09-endpoint-compliance-and-security-baseline.md](09-endpoint-compliance-and-security-baseline.md)
Detailed control implementation for:
- compliance policy
- security baseline
- BitLocker
- Windows LAPS direction

### [14-advanced-recovery-scenarios.md](14-advanced-recovery-scenarios.md)
Detailed operational recovery scenarios for:
- BitLocker recovery
- rebuild / re-enrollment
- stale device cleanup
- recovery and governance lessons

---

## Evidence Areas

The endpoint workstream is supported by evidence under the screenshot tree, including:

- Windows corporate and BYOD enrollment evidence
- Linux Intune evidence
- Ansible evidence
- iPhone BYOD / Apple MDM evidence
- Windows compliance policy evidence
- Windows security baseline evidence
- BitLocker recovery scenario evidence
- identity protection evidence related to MFA, SSPR, Conditional Access, and LAPS

The detailed docs should reference only the most important screenshots, while the screenshot folders remain the full evidence archive.

---

## Diagram Placement Recommendation

This overview page is a good place for the **endpoint architecture / management model** diagram.

Recommended diagram for this page:
- `diagrams/01-release1-end-state-architecture.png` for high-level context
- or
- `diagrams/02-identity-messaging-endpoint-control-flow.png` if you want a more technical flow emphasis

Best practice:
- embed only one diagram here
- keep deeper recovery visuals in `14-advanced-recovery-scenarios.md`

---

## Suggested Embedded Screenshot Strategy

Do not embed too many screenshots on this overview page.

Best maximum:
- one screenshot showing the mixed device inventory in Intune
- optionally one screenshot showing Windows corp vs BYOD distinction

Detailed screenshots should stay in:
- `08`
- `09`
- `14`

This keeps the overview readable.

---

## Why This Matters Professionally

This endpoint workstream shows practical experience across:

- endpoint onboarding
- mixed ownership models
- mixed platform coverage
- compliance and security baseline enforcement
- identity protection dependencies
- operational recovery and lifecycle cleanup

That is a much stronger enterprise signal than simply showing that Intune was turned on.

---

## Summary

Release 1 endpoint work now demonstrates a realistic pilot endpoint program across Windows, Linux, and iPhone scenarios.

The key value is not only that devices were enrolled, but that the project now shows:

- enrollment
- management visibility
- compliance logic
- security baseline assignment
- access-control dependency
- recovery and lifecycle lessons

This page should remain the **overview / navigation hub** for the endpoint workstream, while the detailed implementation lives in:

- `08-endpoint-platforms-and-enrollment.md`
- `09-endpoint-compliance-and-security-baseline.md`
- `14-advanced-recovery-scenarios.md`
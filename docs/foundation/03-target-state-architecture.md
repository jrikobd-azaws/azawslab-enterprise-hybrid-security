# Target-State Architecture

## Purpose

This page describes the intended end state of the platform after Release 1 is fully implemented and evidenced. It explains how the hybrid Microsoft foundation, including advanced validation capabilities, addresses the constraints of the current-state architecture and establishes a credible, supportable enterprise platform.

The target state is not a theoretical wish list. It is the architecture that has been **implemented, validated, and documented** in the repository, with clear boundaries between baseline capability and later-added advanced validation.

---

## What This Page Proves

This page shows that the target state of Release 1:

- delivers a functioning hybrid identity and Microsoft 365 service baseline
- enforces endpoint trust through compliance, security baselines, and recovery workflows
- includes information-protection controls with user-visible outcomes
- provides operational visibility and supportability through monitoring and Graph-powered tooling
- incorporates advanced validation for modern provisioning, identity lifecycle automation, email security, and document fingerprinting

---

## Why This Matters

The target state demonstrates that the platform is not just a collection of configured services. It is an integrated, operationally realistic environment that:

- reduces risk through device trust and access controls
- improves supportability through documented recovery and automation
- provides a foundation for later Azure governance and workload modernisation
- aligns with current job-market expectations for Modern Workplace, Intune, Entra ID, and Graph API skills

---

## Target Architecture Overview

The target state builds on the current-state architecture by adding layers of hybrid integration, endpoint management, information protection, and operational visibility.

### 1. Hybrid Identity Layer

**Target outcome:**  
A controlled hybrid identity path between on-premises Active Directory and Microsoft Entra ID, with pilot-first synchronisation, Conditional Access, MFA, SSPR, and **identity lifecycle automation via Graph PowerShell**.

**Key components:**
- Entra Connect Sync with OU filtering and PHS
- Conditional Access policies, including MFA and compliant-device requirements
- MFA and SSPR configured for pilot users
- Graph PowerShell scripts for user disable, session revoke, enable, and mover scenario (department change -> dynamic group membership -> Slack gallery app access)

### 2. Modern Workplace and Collaboration Layer

**Target outcome:**  
Validated Microsoft 365 services including Exchange hybrid, Teams, SharePoint, and **email security controls** such as anti-phishing, Safe Links, and Safe Attachments.

**Key components:**
- Exchange hybrid readiness and pilot mailbox migration
- Teams and SharePoint baseline validation
- Defender for Office 365 policy configuration and pilot-scope assignment

### 3. Endpoint Management and Security Layer

**Target outcome:**  
A device estate that is enrolled, compliant, hardened, and recoverable, supporting both traditional manual enrollment and **modern cloud-led provisioning through Windows Autopilot + ESP**.

**Key components:**
- Intune enrollment for Windows corporate, Windows BYOD, iPhone BYOD, and Ubuntu Linux
- Compliance policies, security baselines, Defender Antivirus, ASR, and BitLocker escrow
- Windows Update for Business
- **Windows Autopilot + ESP** with zero-touch provisioning and custom branding
- **Windows LAPS** retrieval through Entra / Intune and post-Autopilot remediation
- **Win32 application deployment** through packaging, assignment, and install-status validation
- **Graph-assisted operational tooling** for device-state queries and rename actions

### 4. Information Protection Layer

**Target outcome:**  
User-visible classification and protection controls, including **document fingerprinting** for structured confidential documents.

**Key components:**
- Purview sensitivity labels such as Confidential, Internal, and Public
- DLP policy with user-facing policy tips
- retention baseline
- **document fingerprinting** through a custom SIT from a synthetic HR form, DLP linkage, and OneDrive policy-tip validation

### 5. Monitoring and Operational Visibility Layer

**Target outcome:**  
Visibility into access, device state, and administrative activity, plus **Graph / PowerShell scripts** for helpdesk and L3 support scenarios.

**Key components:**
- Entra sign-in logs and audit logs
- Intune device compliance and control-status views
- example alerts for configuration drift
- **Graph / PowerShell scripts** for user state, managed device state, and device rename with dry-run and apply paths

### 6. Recovery and Lifecycle Layer

**Target outcome:**  
Proven ability to recover from trust disruption, BitLocker events, stale device records, and post-provisioning gaps.

**Key components:**
- BitLocker recovery-key retrieval
- device rebuild, re-enrollment, and stale-record cleanup
- restored compliant state after recovery
- LAPS remediation after Autopilot through a device-targeted script path

---

## How the Target State Addresses Current-State Constraints

| Current-State Constraint | Target-State Solution |
|--------------------------|------------------------|
| Identity trust was on-premises only | Entra Connect Sync with controlled pilot scope |
| No cloud-managed device compliance | Intune compliance policies and Conditional Access integration |
| Endpoint hardening was inconsistent | Windows security baseline, Defender Antivirus, ASR, BitLocker |
| No modern provisioning | Windows Autopilot + ESP added as advanced validation |
| Local admin password management was manual | Windows LAPS with retrieval and post-Autopilot remediation |
| Information protection was not demonstrated | Purview labels, DLP, retention, and document fingerprinting |
| Limited operational visibility | Sign-in logs, audit logs, device dashboards, and Graph PowerShell scripts |
| No documented recovery path | BitLocker recovery, rebuild, stale cleanup, and restored compliance |

---

## Scope Boundaries of the Target State

The target state is **implemented and evidenced** but does **not** claim:

- enterprise-scale device or user populations beyond pilot scope
- full Defender for Endpoint product depth beyond baseline AV and ASR
- Android BYOD / MAM, which remains deferred
- full enterprise PKI / AD CS, since Let’s Encrypt was used for hybrid validation
- Azure governance, Sentinel, or workload hosting, which belong to Releases 2 and 3

These boundaries are intentional and are tracked in the [Build Checklist](../release1/11-build-checklist.md) and [Extensions and Future Enhancements](../release1/12-extensions-and-future-enhancements.md).

---

## Relationship to Other Foundation Docs

Read this page together with:

- [Business Scenario](00-business-scenario.md)
- [Platform Overview](01-platform-overview.md)
- [Current-State Architecture](02-current-state-architecture.md)
- [Roadmap](04-roadmap.md)
- [Skills and Evidence Index](05-skills-and-evidence-index.md)

For implementation details and evidence, proceed to the [Release 1 README](../release1/README.md).

---

## Related Diagrams

- [Release 1 End-State Architecture](../../diagrams/01-release1-end-state-architecture.png)
- [Identity, Messaging, and Endpoint Control Flow](../../diagrams/02-identity-messaging-endpoint-control-flow.png)
- [Release 1 Implementation Flow and Proof Map](../../diagrams/05-release1-implementation-flow-and-proof-map.png)

---

## Summary

The target state of Release 1 is a **complete, evidenced hybrid Microsoft platform** that includes:

- hybrid identity with Graph PowerShell lifecycle automation
- Microsoft 365 baseline and email security
- modern endpoint provisioning and management through Autopilot, Intune, and LAPS
- information protection through labels, DLP, retention, and document fingerprinting
- operational monitoring and Graph-powered support tooling
- documented recovery and remediation workflows

This target state has been implemented, validated, and is ready for review. Later releases extend it into Azure governance and secure workload hosting.
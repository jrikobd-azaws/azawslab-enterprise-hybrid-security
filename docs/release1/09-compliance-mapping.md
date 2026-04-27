# Compliance Mapping

## Purpose

This page maps the implemented controls in Release 1 to practical security and governance concepts.

It is not presented as a formal audit, certification, or standards-compliance claim. Its purpose is to show how the documented implementation aligns with recognizable control areas across identity, endpoint security, information protection, monitoring, and recovery.

---

## What Is Proven Here

The control mapping demonstrates that Release 1 covers meaningful baseline controls across:

- identity and access protection
- trusted-device evaluation
- endpoint hardening and recovery
- information protection
- operational visibility and traceability
- scoped governance thinking rather than isolated technical tasks

In addition, **advanced validation added after baseline** extends coverage into Autopilot-based provisioning, LAPS retrieval, identity lifecycle automation, email security, document fingerprinting, and Graph-powered operational support.

---

## Why It Matters

Technical configuration becomes more credible when it can be connected to control intent.

This mapping matters because it shows that the platform was built with recognizable security and governance outcomes in mind, including:
- controlling who can access services
- evaluating whether a device should be trusted
- protecting data in user workflows
- maintaining visibility of administrative and endpoint activity
- restoring healthy state after disruption
- automating identity lifecycle responses

That makes Release 1 more than a collection of product screenshots. It becomes an evidence-backed control baseline.

---

## Mapping Approach

The control model in Release 1 should be read as a **practical baseline mapping** rather than a formal standards assessment.

The intention is to show how implemented capabilities align with common themes found across frameworks such as:
- **CIS Controls**
- **NIST Cybersecurity Framework / control families**
- **Microsoft Zero Trust design principles**
- basic governance expectations relevant to Microsoft 365 and endpoint administration

This page deliberately avoids claiming:
- formal certification
- complete framework coverage
- independent control validation
- enterprise-wide policy maturity beyond the demonstrated scope

---

## Control Coverage at a Glance

| Control Area | Implemented Capability | Primary Evidence |
| :--- | :--- | :--- |
| **Identity and Access Control** | Entra Connect Sync, MFA, Conditional Access, SSPR baseline | Hybrid identity and monitoring evidence |
| **Device Trust and Compliance** | Intune compliance policy, compliant/non-compliant state visibility | Endpoint compliance evidence |
| **Endpoint Hardening** | Security baseline, Defender Antivirus baseline, ASR coverage | Security baseline evidence |
| **Encryption and Recovery** | BitLocker-related controls, key visibility, recovery workflow | Recovery scenario evidence |
| **Update Governance** | Windows Update for Business pilot policy | WUfB assignment evidence |
| **Information Protection** | Purview labels, DLP, retention baseline | Purview evidence |
| **Monitoring and Traceability** | Sign-in logs, audit logs, device visibility, alert views | Monitoring evidence |
| **Lifecycle Recovery** | Rebuild, re-enrollment, stale-record cleanup, restored compliance | Recovery scenario evidence |
| **Modern Provisioning (Advanced)** | Windows Autopilot + ESP | Autopilot evidence in `screenshots/release1/endpoint-management/intune/intune-autopilot-esp/` |
| **Local Admin Password Retrieval (Advanced)** | LAPS password retrieval from Entra / Intune | LAPS retrieval evidence in `screenshots/release1/identity-and-access/identity-protection/laps/` |
| **Post-Provisioning Remediation (Advanced)** | LAPS remediation after Autopilot | LAPS remediation evidence in `screenshots/release1/endpoint-management/intune/intune-autopilot-laps/` |
| **Email Security (Advanced)** | Anti-phishing, Safe Links, Safe Attachments policies | Email security evidence in `screenshots/release1/modern-workplace/email-security/` |
| **Identity Lifecycle Automation (Advanced)** | Disable, revoke-session, enable; mover scenario (department change -> dynamic group -> app access) | Lifecycle evidence in `screenshots/release1/identity-and-access/identity-operations/lifecycle/` |
| **Graph API Operational Support (Advanced)** | User/device state queries, device rename via PowerShell | Graph PowerShell evidence in `screenshots/release1/identity-and-access/identity-operations/graph-powershell/` |
| **Document Fingerprinting (Advanced)** | Custom SIT from HR form, DLP linkage, policy tip | Fingerprint evidence in `screenshots/release1/information-protection/purview/purview-fingerprint/` |
| **Application Deployment (Advanced)** | Win32 app packaging, assignment, install status | App deployment evidence in `screenshots/release1/endpoint-management/intune/intune-app-deployment/` |

---

## Practical Mapping by Domain

### 1. Identity and Access Protection

The identity layer maps most directly to access-control and authentication governance.

Implemented controls in this area include:
- Active Directory to Microsoft Entra ID synchronization
- scoped pilot synchronization
- Conditional Access baseline
- MFA
- SSPR
- sign-in visibility tied to access outcomes

**Advanced validation additions:**
- identity lifecycle controls (disable, revoke session, enable) via Graph PowerShell
- mover scenario (department-driven dynamic group membership -> Slack access)

**Control intent**

This supports the idea that:
- access is based on managed identity rather than ad hoc account use
- authentication is strengthened beyond password-only reliance
- access outcomes can be reviewed and interpreted operationally
- lifecycle changes can be automated and traced

**Framework-style interpretation**

This aligns broadly with:
- identity and authentication control concepts
- least-trust / Zero Trust access thinking
- access monitoring and authentication review expectations
- identity governance and lifecycle management

Primary references:
- [Hybrid Identity](01-hybrid-identity.md)
- [Monitoring](08-monitoring.md)

---

### 2. Trusted Device and Compliance Evaluation

The endpoint layer maps directly to the idea that access should not depend only on user identity, but also on device state.

Implemented controls in this area include:
- device enrollment into Intune
- compliance policy evaluation
- visible compliant and non-compliant state
- ownership-aware handling of corporate and BYOD devices

**Advanced validation additions:**
- Windows Autopilot + ESP for modern provisioning and device readiness
- Graph-assisted device-state queries and rename workflows for operational support

**Control intent**

This supports:
- device trust evaluation
- policy-based access confidence
- operational visibility of managed endpoint state
- repeatable zero-touch provisioning

**Framework-style interpretation**

This aligns broadly with:
- endpoint security baseline thinking
- device-management and asset-control concepts
- conditional access and trusted-device posture
- secure configuration management for new devices

Primary references:
- [Endpoint Overview](03-endpoint-overview.md)
- [Endpoint Enrollment](04-endpoint-enrollment.md)
- [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md)

---

### 3. Endpoint Hardening and Protection

Hardening controls map to the broader goal of reducing attack surface and enforcing a more secure baseline across managed endpoints.

Implemented controls in this area include:
- security baseline assignment
- Defender Antivirus baseline coverage
- Attack Surface Reduction (ASR) policy coverage
- Windows Update for Business policy
- policy visibility in Intune

**Advanced validation additions:**
- Windows LAPS retrieval for password recoverability
- LAPS remediation after Autopilot for post-provisioning correction

**Control intent**

This supports:
- hardening beyond default device state
- managed protection posture
- lifecycle security rather than one-time enrollment
- recoverability of local administrator access

**Framework-style interpretation**

This aligns broadly with:
- secure configuration management
- vulnerability and update governance
- endpoint protection and attack-surface reduction concepts
- privileged access recovery

Primary references:
- [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md)

---

### 4. Encryption, Recoverability, and Lifecycle Correction

Protection controls are only credible if the platform can also recover from disruption.

Implemented controls in this area include:
- BitLocker-related policy handling
- recovery-key visibility
- rebuild and re-enrollment workflow
- duplicate / stale record cleanup
- restored compliant state after remediation

**Control intent**

This supports:
- recoverable endpoint protection
- continuity of managed-device trust
- lifecycle hygiene after disruption

**Framework-style interpretation**

This aligns broadly with:
- data-at-rest protection
- recovery readiness
- operational resilience and managed asset lifecycle correction

Primary references:
- [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md)
- [Recovery Scenarios](06-recovery-scenarios.md)

---

### 5. Information Protection

The Purview baseline maps to data classification and user-visible protection controls.

Implemented controls in this area include:
- sensitivity labels
- DLP policy-tip behavior
- retention baseline

**Advanced validation additions:**
- document fingerprinting through a custom SIT from an HR form, DLP linkage, and policy-tip validation

**Control intent**

This supports:
- classification of sensitive content
- user-visible intervention before inappropriate data handling
- governance baseline beyond endpoint-only controls
- recognition of structured confidential document types

**Framework-style interpretation**

This aligns broadly with:
- data protection
- information classification
- governance and retention control concepts
- advanced data loss prevention through document fingerprinting

Primary references:
- [Purview](07-purview.md)

---

### 6. Monitoring, Traceability, and Operational Review

Monitoring controls map to the broader need for visibility, traceability, and supportability.

Implemented controls in this area include:
- sign-in log review
- audit-log visibility
- device-state visibility
- example alert visibility
- operational interpretation of platform state

**Advanced validation additions:**
- Graph / PowerShell user and device state queries
- managed device rename via Graph API + PowerShell

**Control intent**

This supports:
- administrative traceability
- reviewable access outcomes
- support investigation
- platform-state awareness
- programmatic visibility rather than portal-only dependency

**Framework-style interpretation**

This aligns broadly with:
- logging and monitoring
- administrative auditability
- operational review and ongoing control visibility
- automation-assisted support and incident response

Primary references:
- [Monitoring](08-monitoring.md)

---

## Control-to-Evidence Map

| Control Theme | Example Capability | Main Document | Evidence Hub |
| :--- | :--- | :--- | :--- |
| **Authentication Hardening** | MFA, Conditional Access visibility | [Hybrid Identity](01-hybrid-identity.md) | [Identity and Access Evidence Hub](../../screenshots/release1/identity-and-access/README.md) |
| **Trusted Device Evaluation** | Compliance policy, compliant / non-compliant state | [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md) | [Intune Evidence Hub](../../screenshots/release1/endpoint-management/intune/README.md) |
| **Endpoint Hardening** | Security baseline, Defender AV, ASR | [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md) | [Intune Evidence Hub](../../screenshots/release1/endpoint-management/intune/README.md) |
| **Modern Provisioning** | Autopilot + ESP | [Endpoint Enrollment](04-endpoint-enrollment.md) | [Intune Evidence Hub](../../screenshots/release1/endpoint-management/intune/README.md) |
| **Local Admin Recovery** | LAPS retrieval (Entra / Intune) | [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md) | [Identity and Access Evidence Hub](../../screenshots/release1/identity-and-access/README.md) |
| **Recovery Readiness** | BitLocker recovery, rebuild, stale cleanup | [Recovery Scenarios](06-recovery-scenarios.md) | [Intune Evidence Hub](../../screenshots/release1/endpoint-management/intune/README.md) |
| **Data Protection** | Labels, DLP, retention baseline | [Purview](07-purview.md) | [Information Protection Evidence Hub](../../screenshots/release1/information-protection/README.md) |
| **Document Fingerprinting** | Custom SIT from HR form, DLP linkage | [Purview](07-purview.md) | [Information Protection Evidence Hub](../../screenshots/release1/information-protection/README.md) |
| **Identity Lifecycle** | Disable, revoke, enable; mover scenario | [Hybrid Identity](01-hybrid-identity.md) | [Identity and Access Evidence Hub](../../screenshots/release1/identity-and-access/README.md) |
| **Email Security** | Anti-phishing, Safe Links, Safe Attachments | [Modern Workplace](02-modern-workplace.md) | [Modern Workplace Evidence Hub](../../screenshots/release1/modern-workplace/README.md) |
| **Graph API Automation** | User/device state queries, device rename | [Monitoring](08-monitoring.md) | [Identity and Access Evidence Hub](../../screenshots/release1/identity-and-access/README.md) |
| **Application Deployment** | Win32 app packaging, assignment, install | [Endpoint Overview](03-endpoint-overview.md) | [Intune Evidence Hub](../../screenshots/release1/endpoint-management/intune/README.md) |
| **Operational Visibility** | Sign-ins, audit logs, device alerts | [Monitoring](08-monitoring.md) | [Monitoring and Operations Evidence Hub](../../screenshots/release1/monitoring-and-operations/README.md) |

---

## Scope Boundaries

This mapping should be read carefully.

It does **not** claim:
- formal compliance with CIS, NIST, ISO 27001, GDPR, or any other framework
- complete enterprise control coverage
- independent audit evidence
- mature governance operating model across all Microsoft 365 and Azure domains

**Advanced validation additions** are mapped here, but they remain **later additions** to the baseline. They are not claimed as part of the original first-pass build.

Instead, this page shows that the implemented work can be reasonably interpreted as aligning with recognizable control themes, and that the platform has been extended with modern, role-relevant capabilities.

That distinction matters because the repository is intended to be:
- honest about scope
- evidence-backed
- technically credible
- useful for reviewers who want to understand control intent without inflated compliance claims

---

## Operational Insight

The strongest value of this page is not that it names frameworks. The stronger value is that it shows the implementation was guided by control thinking.

That means Release 1 can be read as:
- an identity-and-device trust baseline
- an endpoint hardening and recovery baseline
- a practical information-protection baseline
- a supportable monitoring baseline
- an identity lifecycle baseline supported by Graph API and PowerShell automation

This makes the work easier to understand for both technical reviewers and hiring managers.

---

## Related Documents

- [Release 1 Summary](00-summary.md)
- [Hybrid Identity](01-hybrid-identity.md)
- [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md)
- [Recovery Scenarios](06-recovery-scenarios.md)
- [Purview](07-purview.md)
- [Monitoring](08-monitoring.md)
- [Build Checklist](11-build-checklist.md)

For cross-release context:
- [Platform Overview](../foundation/01-platform-overview.md)
- [Roadmap](../foundation/04-roadmap.md)
- [Skills and Evidence Index](../foundation/05-skills-and-evidence-index.md)

---

## Related Evidence

- [Release 1 Evidence Dashboard](../../screenshots/release1/README.md)
- [Identity and Access Evidence Hub](../../screenshots/release1/identity-and-access/README.md)
- [Intune Evidence Hub](../../screenshots/release1/endpoint-management/intune/README.md)
- [Information Protection Evidence Hub](../../screenshots/release1/information-protection/README.md)
- [Monitoring and Operations Evidence Hub](../../screenshots/release1/monitoring-and-operations/README.md)
# Release 1 Evidence Dashboard

## Purpose

This page is the guided evidence index for the implemented Release 1 phase of the platform.

It is designed for **recruiters, hiring managers, and technical reviewers** who want to see proof of implementation before diving into the narrative documentation.

The evidence is organised into the same major domains as the documentation:
- platform foundation
- identity and access
- modern workplace
- endpoint management
- monitoring and operations
- information protection

This page should be read as an **evidence dashboard**, not as a narrative summary. It highlights the strongest proof while keeping the wider raw evidence archive available underneath the domain folders.

---

## What This Evidence Archive Proves

The Release 1 evidence set demonstrates that the platform was not only designed and documented, but also **validated** through visible administrative state, user‑facing outcomes, and realistic recovery scenarios.

The strongest proof areas (including both baseline and advanced validation) include:

- hybrid identity synchronisation and Graph‑powered lifecycle automation
- Exchange hybrid pilot migration and post‑migration mailbox access
- Windows Autopilot + ESP (zero‑touch, cloud‑led provisioning)
- endpoint onboarding across corporate, BYOD, Linux, and iPhone
- endpoint compliance, security baselines, and Windows LAPS retrieval & remediation
- Win32 application packaging, deployment, and install status
- BitLocker recovery, stale‑record cleanup, and restored compliance
- Purview labels, DLP user‑facing policy tips, and document fingerprinting
- email security (anti‑phishing, Safe Links, Safe Attachments)
- Graph API + PowerShell operational tooling (user state, device rename)
- monitoring across sign‑ins, audit logs, device state, and alert visibility

These proofs directly align with market demands for Intune, Entra ID, Graph API, PowerShell, and Modern Workplace roles.

---

## How to Use This Dashboard

Use this page in one of three ways:

- **Start with flagship proof** – the shortest route to the strongest screenshots
- **Browse by domain** – evidence grouped by technical area
- **Follow related docs links** – narrative explanation behind a screenshot set

This page is designed to reduce click fatigue. It highlights where to start, while keeping the wider raw evidence archive available underneath the domain folders.

---

## Start Here: Flagship Proof

| Proof Area | What it demonstrates | Best evidence |
| :--- | :--- | :--- |
| **Exchange hybrid validation** | Pilot migration readiness and post‑migration mailbox access | [Pilot mailbox validation](modern-workplace/exchange-hybrid/10-outlook-both-pilots-validated.png) |
| **Corporate Windows compliant state** | Managed Windows endpoint enrolled and shown as compliant in Intune | [Corporate Windows compliant in Intune](endpoint-management/intune/intune-windows-corp/08-intune-windows-device-compliant.png) |
| **Windows Autopilot + ESP** | Zero‑touch provisioning with custom branding and ESP device preparation stage | [ESP device preparation stage](endpoint-management/intune/intune-autopilot-esp/11-esp-device-preparation-stage-working.png) |
| **LAPS retrieval after Autopilot remediation** | Local admin password recovery from Entra admin centre after post‑provisioning fix | [LAPS password retrieval after remediation](endpoint-management/intune/intune-autopilot-laps/07-laps-password-retrieval-success-after-remediation-desktop-cdniaqb.png) |
| **Graph API mover scenario** | Department change → dynamic group membership → Slack gallery app access | [Slack available in My Apps after department change](identity-and-access/identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png) |
| **DLP policy‑tip in Word** | User‑facing information protection behaviour against test financial data | [DLP policy‑tip triggered in Word](information-protection/purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png) |
| **Document fingerprinting DLP policy‑tip** | Recognition of a structured HR form via custom fingerprint SIT | [OneDrive policy‑tip for fingerprint match](information-protection/purview/purview-fingerprint/07-onedrive-policy-tip-validation-document-fingerprint-pilot-win01.png) |
| **BitLocker recovery‑key visibility** | Recovery support tied to the managed cloud record | [BitLocker recovery key in cloud record](endpoint-management/intune/intune-bitlocker-recovery-scenario/02-win11-corp01-entra-bitlocker-recovery-key.png) |
| **Restored compliance after recovery** | Managed state recovered after rebuild and re‑enrolment | [Compliance restored after re‑enrolment](endpoint-management/intune/intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png) |
| **Conditional Access result visibility** | Access‑control outcome visible in sign‑in logs | [Conditional Access result in sign‑in logs](monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png) |
| **Graph PowerShell rename device** | Script‑based device rename with dry‑run safety | [Rename device apply success](identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png) |

---

## Evidence by Domain

### 1. Platform Foundation

This area supports the infrastructure and delivery foundation behind the implemented environment, including virtualisation and supporting setup context.

**Start here:**
- [Platform Foundation Evidence Hub](platform-foundation/README.md)

**Related docs:**
- [Platform Overview](../../docs/foundation/01-platform-overview.md)
- [Target‑State Architecture](../../docs/foundation/03-target-state-architecture.md)

---

### 2. Identity and Access

This area contains proof for:
- Entra Connect Sync – scoped pilot synchronisation
- identity visibility
- Conditional Access‑linked sign‑in review
- supporting identity‑protection evidence
- **Microsoft Graph API + PowerShell** lifecycle automation (disable, revoke session, enable, mover scenario)

**Start here:**
- [Identity and Access Evidence Hub](identity-and-access/README.md)

**Best evidence:**
- [Entra Connect filtering users and devices](identity-and-access/entra-sync/11-entra-connect-filtering-users-devices.png)
- [Pilot users synced to Microsoft 365](identity-and-access/entra-sync/15-m365-active-users-pilot-synced.png)
- [Conditional Access result in sign‑in logs](monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)
- [Graph admin consent for user enable/disable](identity-and-access/identity-operations/graph-powershell/03-graph-admin-consent-enable-disable-user-accounts.png)
- [Slack available in My Apps after department move](identity-and-access/identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png)

**Related docs:**
- [Hybrid Identity](../../docs/release1/01-hybrid-identity.md)
- [Monitoring](../../docs/release1/08-monitoring.md)

---

### 3. Modern Workplace

This area contains proof for:
- Exchange hybrid readiness
- pilot mailbox validation
- Teams baseline activity
- SharePoint access and usability
- **email security** (anti‑phishing, Safe Links, Safe Attachments policies)

**Start here:**
- [Modern Workplace Evidence Hub](modern-workplace/README.md)

**Best evidence:**
- [Exchange migration readiness check](modern-workplace/exchange-hybrid/06-test-migration-server-availability-success.png)
- [Pilot mailbox validation after migration](modern-workplace/exchange-hybrid/10-outlook-both-pilots-validated.png)
- [SharePoint file open validation](modern-workplace/sharepoint-baseline/06-sharepoint-file-open-validation.png)
- [Anti‑phishing policy review](modern-workplace/email-security/04-email-security-anti-phishing-policy-review-protections-r1-belfast.png)

**Related docs:**
- [Modern Workplace](../../docs/release1/02-modern-workplace.md)

---

### 4. Endpoint Management

This area contains proof for:
- Windows corporate onboarding
- Windows BYOD onboarding
- iPhone BYOD onboarding
- Ubuntu Linux visibility
- compliance, hardening, update, and recovery flows
- **Windows Autopilot + ESP** (zero‑touch, custom branding)
- **Windows LAPS retrieval and post‑Autopilot remediation**
- **Win32 application deployment** (packaging, creation, assignment, install status)

**Start here:**
- [Endpoint Management Evidence Hub](endpoint-management/README.md)
- [Intune Evidence Hub](endpoint-management/intune/README.md)

**Best evidence:**
- [Corporate Windows compliant in Intune](endpoint-management/intune/intune-windows-corp/08-intune-windows-device-compliant.png)
- [Corporate and BYOD Windows visibility](endpoint-management/intune/intune-windows-byod/05-intune-windows-devices-corp-and-byod.png)
- [iPhone BYOD enrolment complete](endpoint-management/intune/intune-ios/iphone13-byod-enrollment/14-company-portal-enrollment-complete.png)
- [ESP device preparation stage](endpoint-management/intune/intune-autopilot-esp/11-esp-device-preparation-stage-working.png)
- [Autopilot device imported with profile assigned](endpoint-management/intune/intune-autopilot-esp/07-autopilot-device-imported-profile-assigned-belfast-pilot.png)
- [LAPS password retrieval after remediation](endpoint-management/intune/intune-autopilot-laps/07-laps-password-retrieval-success-after-remediation-desktop-cdniaqb.png)
- [Win32 app overview installed summary](endpoint-management/intune/intune-app-deployment/05-win32-app-overview-installed-summary-two-devices-notepadplusplus.png)
- [Compliance policy non‑compliant result](endpoint-management/intune/intune-compliance-policy/04-compliance-policy-results-overview-noncompliant.png)
- [Compliance restored after recovery](endpoint-management/intune/intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png)

**Related docs:**
- [Endpoint Overview](../../docs/release1/03-endpoint-overview.md)
- [Endpoint Enrolment](../../docs/release1/04-endpoint-enrolment.md)
- [Endpoint Compliance and Security](../../docs/release1/05-endpoint-compliance-and-security.md)
- [Recovery Scenarios](../../docs/release1/06-recovery-scenarios.md)

---

### 5. Monitoring and Operations

This area contains proof for:
- sign‑in review
- audit visibility
- device‑state visibility
- administrative alerting
- support‑oriented operational review
- **Graph API + PowerShell operational tooling** (user state, device state, device rename)

**Start here:**
- [Monitoring and Operations Evidence Hub](monitoring-and-operations/README.md)

**Best evidence:**
- [Conditional Access result in sign‑in logs](monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)
- [Entra audit log overview](monitoring-and-operations/monitoring/audit-logs/01-entra-audit-log-overview.png)
- [Intune device compliance status](monitoring-and-operations/monitoring/device-visibility/03-intune-device-compliance-status.png)
- [Intune dashboard device configuration alert](monitoring-and-operations/monitoring/example-alert/02-intune-dashboard-device-configuration-alert.png)
- [Connect‑MgGraph success](identity-and-access/identity-operations/graph-powershell/06-connect-mggraph-success-admin-mw01.png)
- [Rename device apply success](identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png)

**Related docs:**
- [Monitoring](../../docs/release1/08-monitoring.md)

---

### 6. Information Protection

This area contains proof for:
- sensitivity labels
- DLP user‑facing behaviour
- retention baseline evidence
- **document fingerprinting** (custom SIT from synthetic HR form, DLP linkage, policy‑tip validation)

**Start here:**
- [Information Protection Evidence Hub](information-protection/README.md)

**Best evidence:**
- [Purview sensitivity labels overview](information-protection/purview/purview-sensitivity-labels/01-purview-sensitivity-labels-overview.png)
- [Confidential label applied in Word](information-protection/purview/purview-sensitivity-labels/04-word-confidential-label-applied-to-hr-identity-test-form.png)
- [DLP policy‑tip triggered in Word](information-protection/purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png)
- [Fingerprint SIT review](information-protection/purview/purview-fingerprint/03-fingerprint-sit-review-r1-document-fingerprint-hr-form-belfast.png)
- [OneDrive policy‑tip for fingerprint match](information-protection/purview/purview-fingerprint/07-onedrive-policy-tip-validation-document-fingerprint-pilot-win01.png)

**Related docs:**
- [Purview](../../docs/release1/07-purview.md)

---

## Recommended Evidence Reading Order

If you want the shortest high‑value evidence path that covers both core and advanced validation, use this order:

1. [Exchange hybrid pilot validation](modern-workplace/exchange-hybrid/10-outlook-both-pilots-validated.png)
2. [Corporate Windows compliant state](endpoint-management/intune/intune-windows-corp/08-intune-windows-device-compliant.png)
3. [Windows Autopilot ESP device preparation stage](endpoint-management/intune/intune-autopilot-esp/11-esp-device-preparation-stage-working.png)
4. [LAPS password retrieval after remediation](endpoint-management/intune/intune-autopilot-laps/07-laps-password-retrieval-success-after-remediation-desktop-cdniaqb.png)
5. [Graph API mover scenario – Slack available](identity-and-access/identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png)
6. [DLP policy‑tip in Word](information-protection/purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png)
7. [Document fingerprinting DLP policy‑tip](information-protection/purview/purview-fingerprint/07-onedrive-policy-tip-validation-document-fingerprint-pilot-win01.png)
8. [BitLocker recovery‑key visibility](endpoint-management/intune/intune-bitlocker-recovery-scenario/02-win11-corp01-entra-bitlocker-recovery-key.png)
9. [Restored compliant state after recovery](endpoint-management/intune/intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png)
10. [Conditional Access result in sign‑in logs](monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)
11. [Graph PowerShell rename device success](identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png)

This sequence gives the fastest overview of:
- service validation
- endpoint trust and modern provisioning
- local admin password recovery
- identity automation and attribute‑driven access
- information protection (both standard DLP and document fingerprinting)
- recovery realism
- operational visibility
- Graph API + PowerShell support tooling

---

## Relationship to the Documentation

The evidence archive supports, but does not replace, the written documentation.

Use the **documentation** when you want:
- architecture
- implementation rationale
- scope boundaries
- business value
- lessons learned

Use the **screenshot archive** when you want:
- proof of configuration state
- visible validation outcomes
- user‑facing control behaviour
- recovery workflow evidence

**Best reading path:**
- [Release 1 README](../../docs/release1/README.md)
- [Release 1 Summary](../../docs/release1/00-summary.md)
- then the domain docs and domain evidence hubs

---

## Scope Boundaries

The screenshot archive should be read carefully. It shows strong evidence for the implemented phase, but it does **not** imply that every adjacent capability is already complete.

Examples of intentionally deferred or partial areas include:
- Android BYOD / MAM
- full enterprise PKI / AD CS (Let’s Encrypt / `win‑acme` was used for hybrid validation)
- full Microsoft Defender for Endpoint stack (EDR, advanced hunting)
- broader Azure platform security and SIEM work (Release 2)
- workload modernisation capabilities (containerisation, WAF, observability – Release 3)

> **Note:** Capabilities that were previously described as future, such as Windows Autopilot/ESP, stronger LAPS validation, document fingerprinting, email security, Graph lifecycle automation, and Graph‑assisted operational tooling, are now **fully implemented and evidenced** as advanced validation within Release 1. They are no longer deferred.

These items belong in:
- [Build Checklist](../../docs/release1/11-build-checklist.md)
- [Extensions and Future Enhancements](../../docs/release1/12-extensions-and-future-enhancements.md)
- [Roadmap](../../docs/foundation/04-roadmap.md)

---

## Related Pages

- [Release 1 README](../../docs/release1/README.md)
- [Release 1 Summary](../../docs/release1/00-summary.md)
- [Skills and Evidence Index](../../docs/foundation/05-skills-and-evidence-index.md)
- [Root README](../../README.md)
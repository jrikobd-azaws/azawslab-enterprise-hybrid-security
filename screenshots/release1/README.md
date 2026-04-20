# Release 1 Evidence Dashboard

## Purpose

This page is the guided evidence index for the implemented phase of the platform.

It exists to make the screenshot archive easier to navigate by grouping evidence into the same major domains used throughout the documentation:
- platform foundation
- identity and access
- modern workplace
- endpoint management
- monitoring and operations
- information protection

This page should be read as an evidence dashboard, not as a narrative summary.

---

## What This Evidence Archive Proves

The Release 1 evidence set demonstrates that the platform was not only designed and documented, but also validated through visible administrative state, user-facing outcomes, and recovery scenarios.

The strongest proof areas include:
- hybrid identity synchronization and access visibility
- Exchange hybrid pilot validation
- endpoint onboarding across multiple ownership and platform types
- endpoint compliance and security controls
- BitLocker recovery and restored compliant state
- Purview labels and DLP policy-tip behavior
- monitoring across sign-ins, audit logs, device state, and alert visibility

---

## How to Use This Dashboard

Use this page in one of three ways:

- **Start with flagship proof** if you want the shortest route to the strongest screenshots
- **Browse by domain** if you want evidence grouped by technical area
- **Follow the related docs links** if you want the narrative explanation behind a screenshot set

This page is designed to reduce click fatigue. It highlights where to start, while keeping the wider raw evidence archive available underneath the domain folders.

---

## Start Here: Flagship Proof

| Proof Area | What it demonstrates | Best evidence |
| :--- | :--- | :--- |
| **Exchange hybrid validation** | Pilot migration readiness and post-migration mailbox access | `modern-workplace/exchange-hybrid/10-outlook-both-pilots-validated.png` |
| **Corporate Windows compliant state** | Managed Windows endpoint enrolled and shown as compliant in Intune | `endpoint-management/intune/intune-windows-corp/08-intune-windows-device-compliant.png` |
| **DLP policy-tip in Word** | User-facing information protection behavior against test financial data | `information-protection/purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png` |
| **BitLocker recovery-key visibility** | Recovery support tied to the managed cloud record | `endpoint-management/intune/intune-bitlocker-recovery-scenario/02-win11-corp01-entra-bitlocker-recovery-key.png` |
| **Restored compliance after recovery** | Managed state recovered after rebuild and re-enrollment | `endpoint-management/intune/intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png` |
| **Conditional Access result visibility** | Access-control outcome visible in sign-in logs | `monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png` |

---

## Evidence by Domain

### 1. Platform Foundation

This area supports the infrastructure and delivery foundation behind the implemented environment, including virtualization and supporting setup context.

Start here:
- [Platform Foundation Evidence Hub](platform-foundation/README.md)

Related docs:
- [Platform Overview](../../docs/foundation/01-platform-overview.md)
- [Target-State Architecture](../../docs/foundation/03-target-state-architecture.md)

---

### 2. Identity and Access

This area contains proof for:
- Entra Connect Sync
- scoped pilot synchronization
- identity visibility
- Conditional Access-linked sign-in review
- supporting identity-protection evidence

Start here:
- [Identity and Access Evidence Hub](identity-and-access/README.md)

Best evidence:
- `identity-and-access/entra-sync/11-entra-connect-filtering-users-devices.png`
- `identity-and-access/entra-sync/15-m365-active-users-pilot-synced.png`
- `monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png`

Related docs:
- [Hybrid Identity](../../docs/release1/01-hybrid-identity.md)
- [Monitoring](../../docs/release1/08-monitoring.md)

---

### 3. Modern Workplace

This area contains proof for:
- Exchange hybrid readiness
- pilot mailbox validation
- Teams baseline activity
- SharePoint access and usability

Start here:
- [Modern Workplace Evidence Hub](modern-workplace/README.md)

Best evidence:
- `modern-workplace/exchange-hybrid/06-test-migration-server-availability-success.png`
- `modern-workplace/exchange-hybrid/10-outlook-both-pilots-validated.png`
- `modern-workplace/sharepoint-baseline/06-sharepoint-file-open-validation.png`

Related docs:
- [Modern Workplace](../../docs/release1/02-modern-workplace.md)

---

### 4. Endpoint Management

This area contains proof for:
- Windows corporate onboarding
- Windows BYOD onboarding
- iPhone BYOD onboarding
- Ubuntu Linux visibility
- compliance, hardening, update, and recovery flows

Start here:
- [Endpoint Management Evidence Hub](endpoint-management/README.md)
- [Intune Evidence Hub](endpoint-management/intune/README.md)

Best evidence:
- `endpoint-management/intune/intune-windows-corp/08-intune-windows-device-compliant.png`
- `endpoint-management/intune/intune-windows-byod/05-intune-windows-devices-corp-and-byod.png`
- `endpoint-management/intune/intune-ios/iphone13-byod-enrollment/14-company-portal-enrollment-complete.png`
- `endpoint-management/intune/intune-compliance-policy/04-compliance-policy-results-overview-noncompliant.png`
- `endpoint-management/intune/intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png`

Related docs:
- [Endpoint Overview](../../docs/release1/03-endpoint-overview.md)
- [Endpoint Enrollment](../../docs/release1/04-endpoint-enrollment.md)
- [Endpoint Compliance and Security](../../docs/release1/05-endpoint-compliance-and-security.md)
- [Recovery Scenarios](../../docs/release1/06-recovery-scenarios.md)

---

### 5. Monitoring and Operations

This area contains proof for:
- sign-in review
- audit visibility
- device-state visibility
- administrative alerting
- support-oriented operational review

Start here:
- [Monitoring and Operations Evidence Hub](monitoring-and-operations/README.md)

Best evidence:
- `monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png`
- `monitoring-and-operations/monitoring/audit-logs/01-entra-audit-log-overview.png`
- `monitoring-and-operations/monitoring/device-visibility/03-intune-device-compliance-status.png`
- `monitoring-and-operations/monitoring/example-alert/02-intune-dashboard-device-configuration-alert.png`

Related docs:
- [Monitoring](../../docs/release1/08-monitoring.md)

---

### 6. Information Protection

This area contains proof for:
- sensitivity labels
- DLP user-facing behavior
- retention baseline evidence

Start here:
- [Information Protection Evidence Hub](information-protection/README.md)

Best evidence:
- `information-protection/purview/purview-sensitivity-labels/01-purview-sensitivity-labels-overview.png`
- `information-protection/purview/purview-sensitivity-labels/04-word-confidential-label-applied-to-hr-identity-test-form.png`
- `information-protection/purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png`

Related docs:
- [Purview](../../docs/release1/07-purview.md)

---

## Recommended Evidence Reading Order

If you want the shortest high-value evidence path, use this order:

1. Exchange hybrid pilot validation
2. Corporate Windows compliant state
3. DLP policy-tip in Word
4. BitLocker recovery-key visibility
5. Restored compliant state after recovery
6. Conditional Access result in sign-in logs

This sequence gives the fastest overview of:
- service validation
- endpoint trust
- information protection
- recovery realism
- operational visibility

---

## Relationship to the Documentation

The evidence archive supports, but does not replace, the written documentation.

Use the documentation when you want:
- architecture
- implementation rationale
- scope boundaries
- business value
- lessons learned

Use the screenshot archive when you want:
- proof of configuration state
- visible validation outcomes
- user-facing control behavior
- recovery workflow evidence

Best reading path:
- [Release 1 README](../../docs/release1/README.md)
- [Release 1 Summary](../../docs/release1/00-summary.md)
- then the domain docs and domain evidence hubs

---

## Scope Boundaries

The screenshot archive should be read carefully.

It shows strong evidence for the implemented phase, but it does **not** imply that every adjacent capability is already complete.

Examples of intentionally deferred or partial areas include:
- Android BYOD / MAM
- Windows Autopilot / ESP optimization
- full enterprise PKI / AD CS
- advanced Purview automation
- broader Azure platform security and SIEM work
- later workload modernization capability

Those items belong in:
- [Build Checklist](../../docs/release1/11-build-checklist.md)
- [Extensions and Future Enhancements](../../docs/release1/12-extensions-and-future-enhancements.md)
- [Roadmap](../../docs/foundation/04-roadmap.md)

---

## Related Pages

- [Release 1 README](../../docs/release1/README.md)
- [Release 1 Summary](../../docs/release1/00-summary.md)
- [Skills and Evidence Index](../../docs/foundation/05-skills-and-evidence-index.md)
- [Root README](../../README.md)
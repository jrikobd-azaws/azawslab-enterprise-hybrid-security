# Release 1 Build Checklist

**Related navigation:** [README](../../README.md) | [Release 1 Summary](00-summary.md) | [Roadmap](../overview/04-roadmap.md)  
**Related docs:** [Hybrid Identity](01-hybrid-identity.md) | [Microsoft 365 Modern Workplace](02-modern-workplace.md) | [Endpoint Overview](03-endpoint-overview.md) | [Security and Compliance Mapping](09-compliance-mapping.md) | [Lessons Learned](10-lessons-learned.md)

## Purpose

This checklist is the authoritative implementation ledger for Release 1 of the `azawslab Enterprise Hybrid Security Platform`.

It records what was completed, what was partially validated, and what was intentionally deferred. It should be read as the status source for Release 1 implementation, not as the main summary or workstream narrative.

## Release 1 Scope Summary

Release 1 includes:

- Hyper-V-based on-premises platform foundation
- hybrid identity with Active Directory, Microsoft Entra ID, and Entra Connect Sync
- Microsoft 365 onboarding and Exchange hybrid pilot migration
- Teams and SharePoint collaboration baseline
- endpoint enrollment across Windows corporate, Windows BYOD, Ubuntu Linux, and iPhone BYOD
- endpoint compliance, hardening, update governance, and BitLocker
- Purview sensitivity labels, DLP, and retention baseline
- monitoring visibility across sign-in, audit, endpoint, and alert-signal review
- recovery-aware endpoint operations through BitLocker recovery, re-enrollment, and stale-record cleanup

## Status Key

- **Completed** = built, validated, and documented with supporting evidence
- **Partial** = implemented or evidenced in part, but not yet broad or deep enough to claim full maturity
- **Deferred** = intentionally left for a later release or not yet evidenced strongly enough to claim

---

## 1. Platform Foundation

- **Completed** Hyper-V host platform established
- **Completed** Internal virtual switch design implemented
- **Completed** Host NAT configured for lab connectivity
- **Completed** Differencing-disk reuse strategy applied
- **Completed** Multi-VM lab orchestration used for Release 1 platform services
- **Completed** Core server roles built for domain, sync, and Exchange hybrid work

## 2. Hybrid Identity

- **Completed** Active Directory remained the authoritative source for pilot synced identities
- **Completed** Microsoft Entra Connect Sync configured for controlled pilot scope
- **Completed** Selected users and devices synchronized into Microsoft 365
- **Completed** Namespace separation maintained between `azawslab.co.uk` and `corp.azawslab.co.uk`
- **Completed** Hybrid identity design validated as a prerequisite for Microsoft 365 and Exchange hybrid work
- **Partial** Certificate and namespace readiness demonstrated for hybrid validation, but not presented as full PKI program maturity

## 3. Microsoft 365 and Exchange Hybrid

- **Completed** Microsoft 365 tenant onboarded for Release 1 pilot use
- **Completed** Root and pilot namespace decisions applied without disrupting the Zoho-associated root namespace
- **Completed** Pilot user licensing and Microsoft 365 access validated
- **Completed** Exchange hybrid configuration path established
- **Completed** HCW migration-path issue recovery completed
- **Completed** Migration-endpoint validation succeeded
- **Completed** Pilot mailboxes migrated successfully to Exchange Online
- **Completed** Outlook on the web validation completed for migrated users

## 4. Teams and SharePoint Baseline

- **Completed** Teams web access validated for pilot users
- **Completed** Team and channel interaction validated
- **Completed** Direct chat and collaboration baseline validated
- **Completed** SharePoint site access validated
- **Completed** Document-library access validated
- **Completed** File upload and file-open validation completed

## 5. Endpoint Enrollment and Platform Coverage

- **Completed** Windows corporate enrollment validated
- **Completed** Windows BYOD enrollment validated
- **Completed** Ubuntu Linux visibility validated
- **Completed** Ubuntu Linux baseline automation executed through Ansible
- **Completed** Apple MDM prerequisite completed for iPhone management
- **Completed** iPhone BYOD enrollment completed through Intune Company Portal
- **Partial** Linux management demonstrated as visibility plus baseline automation, not as Windows-equivalent control depth

## 6. Endpoint Compliance and Hardening

- **Completed** Windows compliance-policy baseline created and assigned
- **Completed** Compliance-state progression observed from earlier noncompliant state to later healthy state
- **Completed** Windows security baseline assigned to pilot groups
- **Completed** Windows Update for Business pilot assignment completed
- **Completed** Attack Surface Reduction policy evidence captured
- **Completed** BitLocker encryption and key escrow demonstrated
- **Completed** Compliant-device logic incorporated into access-control behavior
- **Partial** Windows LAPS direction established, but retrieval and recovery maturity not fully evidenced

## 7. Monitoring and Visibility

- **Completed** Microsoft Entra sign-in visibility reviewed
- **Completed** Conditional Access result visibility reviewed
- **Completed** Microsoft Entra audit-log baseline reviewed
- **Completed** Intune device-state and compliance visibility reviewed
- **Completed** Example alert-signal or monitoring-surface evidence captured
- **Partial** Monitoring demonstrated as a baseline visibility model, not as full SIEM/SOC maturity

## 8. Information Protection and Purview

- **Completed** Sensitivity-label baseline created
- **Completed** Labels published to pilot scope
- **Completed** User-visible label application validated in Microsoft Word
- **Completed** DLP pilot policy created and reviewed
- **Completed** DLP policy-tip behavior validated in Word
- **Completed** Retention-policy baseline made visible in Purview administration
- **Partial** Purview demonstrated as a baseline information-protection implementation, not as a full enterprise governance program

## 9. Recovery and Operational Resilience

- **Completed** BitLocker recovery scenario documented and validated
- **Completed** Recovery key retrieved successfully from Microsoft Entra ID
- **Completed** Device trust disruption observed after hardware-context change
- **Completed** Re-enrollment path completed after unhealthy trust state
- **Completed** Duplicate or stale device records identified after re-enrollment
- **Completed** Stale record cleanup performed
- **Completed** Healthy compliant state restored after recovery workflow

---

## Intentionally Deferred or Not Fully Evidenced

The following areas are intentionally deferred or not yet evidenced strongly enough to claim full Release 1 maturity:

- **Deferred** Android BYOD / MAM validation
- **Partial** Windows LAPS password retrieval and recovery operations
- **Partial** Advanced monitoring and incident-response maturity
- **Partial** Advanced Purview capabilities such as document fingerprinting and large-scale auto-labeling
- **Deferred** Azure governance, Defender for Cloud, Sentinel, and other Release 2 platform-security work
- **Deferred** Secure workload modernization and resilience work planned for Release 3

## Release 1 Completion Position

Release 1 should be treated as **implemented and evidenced** for its intended baseline scope.

That means Release 1 now credibly demonstrates:

- hybrid identity and Microsoft 365 onboarding
- Exchange hybrid pilot migration
- cross-platform endpoint enrollment
- endpoint compliance and hardening
- Purview baseline information protection
- monitoring visibility
- recovery-aware endpoint operations

It should **not** be presented as a finished enterprise program in every adjacent domain. The strongest and most credible description is:

**an evidenced Release 1 baseline across hybrid identity, collaboration, endpoint management, information protection, monitoring, and operational recovery**

## Related Docs

- [Release 1 Summary](00-summary.md)
- [Hybrid Identity](01-hybrid-identity.md)
- [Microsoft 365 Modern Workplace](02-modern-workplace.md)
- [Endpoint Overview](03-endpoint-overview.md)
- [Endpoint Enrollment and Platform Coverage](04-endpoint-enrollment.md)
- [Endpoint Compliance and Security Baseline](05-endpoint-compliance.md)
- [Advanced Recovery Scenarios](06-recovery-scenarios.md)
- [Information Protection and Purview](07-purview.md)
- [Monitoring and Alerting](08-monitoring.md)
- [Security and Compliance Mapping](09-compliance-mapping.md)
- [Lessons Learned](10-lessons-learned.md)
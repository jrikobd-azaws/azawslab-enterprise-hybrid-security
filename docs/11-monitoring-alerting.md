# Monitoring and Alerting

## Purpose

This document records the monitoring, logging, and alerting baseline for Release 1 of the `azawslab Enterprise Hybrid Security Platform`.

The objective of this phase is to demonstrate that Release 1 controls are not only configured, but also observable through practical monitoring evidence across identity, Microsoft 365, endpoint, and access-control layers.

This document is intended to show operational visibility, staged validation, and realistic pilot-scope monitoring rather than full enterprise SOC maturity.

---

## Release 1 Scope for This Document

This document covers:

- Microsoft Entra sign-in visibility
- Microsoft 365 and pilot access validation
- Conditional Access rollout monitoring
- pilot identity-access control review
- endpoint and compliance-related visibility where available
- example alerting baseline direction
- relationship between monitoring evidence and Release 1 control validation

It does not claim that Microsoft Sentinel, advanced SIEM engineering, or full production alert engineering is complete in Release 1 unless separately documented.

---

## Monitoring Design Principles

Release 1 monitoring follows these principles:

- monitoring should validate implemented controls, not exist as a disconnected add-on
- pilot-scope monitoring is acceptable where tenant-wide rollout is not yet complete
- staged policy rollout should be observable before and after enforcement
- evidence should show both configuration and operational validation
- monitoring documentation should stay aligned to actual implemented state

This approach supports a practical enterprise-style build narrative without overstating maturity.

---

## Current Monitoring Position in Release 1

By this point in Release 1, the environment already demonstrates:

- on-premises AD and DNS validation
- Entra Connect synchronization visibility
- Microsoft 365 pilot identity access
- Exchange hybrid readiness and pilot migration evidence
- Teams / SharePoint / endpoint baseline progression
- pilot MFA, SSPR, and Conditional Access rollout

The monitoring baseline therefore moves beyond simple setup validation and into access-control observation.

---

## Identity Access Monitoring and Conditional Access Validation

Release 1 monitoring was extended to include identity-access control visibility for the pilot MFA, SSPR, and Conditional Access rollout.

The goal of this phase was not only to create Conditional Access policies, but also to validate their behavior through Microsoft Entra monitoring views and pilot sign-in testing.

### Monitoring Scope

The monitoring scope for this phase included:

- Microsoft Entra sign-in activity
- Conditional Access evaluation results
- staged policy rollout behavior
- pilot-user access outcomes
- compliant-device access behavior where applicable

This aligned monitoring with the actual identity-control rollout rather than treating access policy as a separate configuration-only activity.

### Rollout and Validation Sequence

The Conditional Access rollout followed a staged model:

1. Security Defaults disabled
2. pilot scope groups created
3. Conditional Access policies deployed in **Report-only**
4. policy impact reviewed through sign-in behavior and Conditional Access evaluation
5. policies later switched to **On**
6. live sign-in and access behavior validated again after enforcement

This staged approach reduced lockout risk and provided a more realistic enterprise-style implementation path.

### Pilot Scope Used for Monitoring

Included pilot scope:

- `SG-Pilot-MFA-SSPR-CA`

Excluded emergency admin scope:

- `SG-CA-Exclude-BreakGlass`

This allowed monitoring and validation to focus on pilot users while preserving a controlled exclusion path for portal administration.

### Conditional Access Policies Observed

The following pilot policies formed the identity-access monitoring scope:

#### CA01 — Require MFA for Microsoft Admin Portals

- target: Microsoft Admin Portals
- grant control: Require multifactor authentication

#### CA02 — Require MFA for All Cloud Apps

- target: All cloud apps
- grant control: Require multifactor authentication

#### CA03 — Require Compliant Device for Microsoft 365 Apps

- target: Office 365
- grant controls:
  - Require multifactor authentication
  - Require device to be marked as compliant

### Monitoring Sources Used

The primary visibility sources for this phase were:

- Microsoft Entra sign-in logs
- Conditional Access results shown in sign-in activity
- pilot user sign-in behavior during report-only testing
- pilot user sign-in behavior after policy enforcement

Where available, these views were used to confirm whether policies were:

- targeted correctly
- evaluated correctly
- prompting MFA as intended
- enforcing compliant-device logic as intended

### What Was Validated

This phase validated that:

- pilot Conditional Access scoping worked as expected
- break-glass exclusion remained outside pilot enforcement
- report-only mode could be used to review likely policy impact
- MFA enforcement behavior was visible through sign-in testing
- compliant-device access logic could be tied to the endpoint compliance baseline

### Documentation Note

Some screenshots were captured while policies were still in **Report-only** mode because that was the main design-review and validation phase.

Final enforcement was applied later and validated through live sign-in and access behavior rather than exhaustive recapture of every final policy page.

This should be interpreted as staged rollout evidence, not as an incomplete implementation.

### Release 1 Value

This monitoring phase now demonstrates:

- identity-access controls were monitored, not just configured
- Conditional Access was introduced through staged rollout
- report-only review was used before enforcement
- pilot access outcomes were checked after enforcement
- access policy behavior was linked to both identity and device state

---

## Microsoft Entra Sign-In Visibility

Microsoft Entra sign-in visibility forms the core cloud monitoring baseline for Release 1.

This area supports validation of:

- synchronized user sign-in activity
- cloud access after licensing and migration
- Conditional Access targeting and results
- pilot-user authentication behavior

### Practical Use in Release 1

In Release 1, sign-in visibility is used to help confirm:

- pilot users can access Microsoft 365 successfully
- sign-in prompts align to expected MFA behavior
- Conditional Access policies are being applied to the intended user scope
- excluded emergency admin path remains outside pilot CA enforcement

This makes sign-in visibility a key validation tool for the Zero Trust access layer.

---

## Microsoft 365 and Workload Visibility

Release 1 also includes monitoring-relevant validation across Microsoft 365 workloads.

Examples include:

- pilot mailbox access after Exchange Online migration
- Teams and SharePoint pilot baseline access checks
- pilot access validation through Microsoft 365 web experiences
- cloud app access behavior under Conditional Access

This workload visibility is still baseline-level, but it supports the claim that Release 1 monitoring is tied to actual services in use.

---

## Endpoint and Compliance Visibility

Where available, Release 1 monitoring also considers the relationship between endpoint state and cloud access outcomes.

This is especially relevant to:

- Intune compliance state
- compliant-device access logic
- policy behavior for managed vs non-managed or less-trusted access paths

### Practical Release 1 Interpretation

Release 1 does not yet claim a full mature device-monitoring program.

However, it does demonstrate that:

- endpoint compliance can influence access policy
- compliant-device state is not only configured but used as a control condition
- pilot policy enforcement can be observed through access outcomes

This is sufficient for a strong Release 1 baseline.

---

## Example Alerting Baseline

Release 1 alerting is intentionally lightweight and practical.

The objective is to demonstrate alert-aware operational thinking rather than a full production alert catalog.

Examples of alerting directions relevant to Release 1 include:

- suspicious or unexpected sign-in behavior
- Conditional Access failures or unusual pilot access outcomes
- noncompliant-device access attempts to protected resources
- audit events related to identity or configuration changes

Where not yet fully implemented, these should be treated as the next extension of the monitoring baseline rather than claimed as complete.

---

## Relationship to Zero Trust

Monitoring in Release 1 is directly tied to Zero Trust control validation.

This is demonstrated by the fact that monitoring was used to support:

- staged Conditional Access rollout
- MFA enforcement review
- compliant-device logic validation
- sign-in behavior review before and after enforcement

This reinforces the project rule that security, compliance, and monitoring are embedded across phases rather than added later as separate activities.

---

## Evidence to Capture

The following evidence should be retained in the repository screenshot/evidence structure where available:

- Microsoft Entra sign-in logs for pilot users
- Conditional Access result views for report-only evaluation
- Conditional Access result views after policy enforcement
- pilot sign-in evidence showing MFA challenge or CA outcome
- compliant-device access behavior evidence where available
- screenshots showing policy impact review during pilot rollout

---

## Current Status

Monitoring and alerting are implemented at baseline pilot scope.

Completed or materially evidenced areas include:

- identity-access monitoring tied to Conditional Access rollout
- pilot sign-in visibility
- staged report-only review approach
- live access validation after policy enforcement
- monitoring linkage between identity and device state

Areas still to extend later in Release 1 include:

- broader alert examples
- deeper audit-log evidence
- expanded device visibility
- fuller evidence organization in the repository

---

## Remaining Actions

The remaining correct actions for this area are:

1. organize final screenshots and evidence under consistent monitoring paths
2. extend sign-in and Conditional Access evidence where useful
3. add at least one cleaner alerting example if practical
4. keep monitoring documentation aligned to final Release 1 implemented controls

---

## Related Documents

- `docs/05-hybrid-identity.md`
- `docs/06-m365-modern-workplace.md`
- `docs/07-endpoint-security-intune.md`
- `docs/10-security-compliance-mapping.md`
- `docs/13-release1-build-checklist.md`

---

## Summary

Release 1 monitoring now goes beyond basic setup checks.

The environment demonstrates:

- Microsoft Entra sign-in visibility
- staged Conditional Access rollout monitoring
- report-only review before enforcement
- pilot access validation after enforcement
- linkage between identity controls, endpoint compliance, and monitored access outcomes

The most important operational lesson from this phase is that modern identity and access controls should be monitored during rollout, not only after final enforcement.
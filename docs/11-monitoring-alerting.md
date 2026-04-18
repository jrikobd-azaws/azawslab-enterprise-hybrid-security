# Monitoring and Alerting

**Navigation:** [README](../README.md) | [Release 1 Build Checklist](16-release1-build-checklist.md) | [Release 1 Final Summary](17-release1-final-summary.md)

**Related docs:** [Hybrid Identity](05-hybrid-identity.md) | [Modern Workplace](06-m365-modern-workplace.md) | [Endpoint Security and Intune Overview](07-endpoint-security-intune.md) | [Security and Compliance Mapping](12-security-compliance-mapping.md)

---

## Purpose

This document records the **monitoring and alerting baseline position** for Release 1 of the `azawslab Enterprise Hybrid Security Platform`.

The purpose of this workstream is to show how Release 1 begins to address operational visibility across:

- identity
- Microsoft 365 administration
- endpoint state
- control validation
- security and compliance evidence

This document is intentionally conservative.

Release 1 currently demonstrates a **monitoring baseline and visibility direction**, not a fully mature monitoring stack.

---

## Scope of This Document

This document covers:

- what monitoring and visibility currently exist in Release 1
- what has already been validated through portal evidence
- where monitoring intersects with identity, endpoint, and protection controls
- what remains to be implemented for stronger Release 1 operational maturity

This document does **not** yet claim completion of:

- full Entra sign-in monitoring workflow
- formal audit-log review process
- alert rule engineering
- incident-response runbooks
- Sentinel integration
- advanced Defender alerting
- full operational dashboards

Those are later maturity steps.

---

## Why Monitoring Matters in Release 1

A hybrid Microsoft platform is not complete if it only proves:

- services were configured
- devices were enrolled
- controls were assigned

It also needs to show that the environment can be:

- observed
- validated
- reviewed
- improved over time

Monitoring matters because it connects implementation to operational confidence.

For Release 1, the monitoring story is currently about **baseline visibility**, **evidence-backed validation**, and **clear next-step planning**.

---

## Current Monitoring Position in Release 1

Release 1 monitoring is best described as:

### Visibility baseline established
The project already shows visibility into key control areas, especially:

- device presence in Intune
- device presence in Microsoft Entra ID
- endpoint compliance and state views
- Microsoft 365 and Entra administrative evidence
- pilot identity and cloud-service visibility

### Formal monitoring program not yet complete
Release 1 does **not** yet claim a mature monitoring stack with:

- defined alert rules
- operational triage workflow
- incident playbooks
- log review process
- centralized security analytics

That distinction should remain explicit.

---

## Monitoring Baseline Already Demonstrated

Although this workstream is not yet mature, several forms of visibility have already been demonstrated across Release 1.

### 1. Identity and directory visibility

The project already includes evidence for:

- synchronized users visible in Microsoft Entra ID
- pilot users visible in Microsoft 365 admin views
- Microsoft 365 sign-in and access validation at pilot level

This gives a baseline identity-observability story even before deeper log monitoring is built.

### 2. Endpoint visibility

The strongest current monitoring baseline in Release 1 is endpoint visibility.

Evidence already exists for:

- Windows corporate device visibility
- Windows BYOD device visibility
- Ubuntu Linux device visibility
- iPhone BYOD device visibility
- ownership distinction in Intune
- compliant / noncompliant state progression during policy testing
- stale / duplicate device-object visibility during rebuild and recovery events

This is meaningful because it proves the environment can already answer basic operational questions such as:

- what devices exist
- what state they are in
- which user they are associated with
- whether the control state looks healthy

### 3. Protection-control visibility

The project also demonstrates visibility into control outcomes through:

- compliance policy results
- Windows security baseline assignment state
- BitLocker recovery-key escrow availability
- DLP policy-tip behavior in Office workflow
- sensitivity label publication and user-side label application

This means Release 1 already has some **control outcome observability**, even if it does not yet have a mature alerting framework.

---

## Monitoring as Validation, Not Just Logging

A useful way to describe Release 1 monitoring is:

### The project already monitors through validation checkpoints

Examples include:

- Entra Connect results visible in cloud admin views
- migrated mailboxes visible and usable in Exchange Online / OWA
- Teams and SharePoint pilot-user actions visibly succeeding
- Intune device state visible after enrollment
- compliance state visible after policy application
- Purview label and DLP behavior visible during user workflow
- stale device records visible during recovery cleanup

This is not the same as a SOC-grade monitoring platform, but it is still a real operational visibility layer.

---

## Entra and Microsoft 365 Monitoring Direction

The most natural monitoring expansion path in this project is through Entra and Microsoft 365 administrative visibility.

### Release 1 currently supports
- identity state visibility
- tenant administration visibility
- pilot user validation
- policy assignment visibility

### Release 1 still needs
- formal sign-in log review coverage
- formal audit-log review coverage
- documented examples of how suspicious or failed activity would be reviewed
- alert examples tied to identity and access events

That is why this doc should present Entra and Microsoft 365 monitoring as a **partially established baseline with clear next steps**.

---

## Endpoint Monitoring Direction

Endpoint monitoring is one of the strongest current operational layers in the repo.

### What is already visible
- managed-device inventory
- ownership state
- platform type
- compliance state progression
- stale / duplicate object behavior in recovery scenario
- security baseline assignment visibility
- LAPS policy assignment visibility at pilot level

### Why this matters
This already supports an operational story around:

- device inventory accuracy
- device-state review
- control verification
- lifecycle management

That is stronger than simply saying “Intune is enabled.”

---

## Alerting Position in Release 1

Alerting should be described honestly.

### What Release 1 does not yet prove
The project does not yet prove a mature alerting implementation such as:

- defined alert rules
- notification routing
- alert severity model
- triage workflow
- incident ownership
- documented alert-response runbooks

### What Release 1 does prove
Release 1 proves that the environment now contains enough management visibility that alerting can be introduced as the next logical maturity layer.

This is an important distinction:
- visibility exists
- structured alerting is still to be built

---

## Monitoring Relationship to Other Workstreams

Monitoring in this project should be understood as a **cross-cutting layer**.

### Hybrid identity
Monitoring should eventually help validate:
- sync health
- sign-in anomalies
- role and access events

### Modern workplace
Monitoring should eventually help validate:
- mailbox and collaboration service issues
- admin activity
- configuration drift

### Endpoint
Monitoring already supports:
- device inventory review
- compliance-state observation
- recovery and stale-object identification

### Information protection
Monitoring should eventually help validate:
- label usage
- DLP detections
- policy-trigger review

This makes monitoring one of the most important future maturity multipliers in the platform.

---

## Release 1 Monitoring Maturity Model

The cleanest way to describe current maturity is:

### Current baseline
- administrative visibility exists
- control outcome evidence exists
- device-state visibility exists
- pilot validation evidence exists

### Near-term next maturity
- Entra sign-in log review
- audit-log baseline
- example alert configuration
- monitoring documentation linked to real evidence

### Later maturity
- stronger identity alerting
- endpoint and security alerting
- Defender integration
- Sentinel / centralized security monitoring in later releases

---

## What Should Be Added Later in Release 1

The next monitoring priorities should be:

### Identity monitoring
- Entra sign-in logs
- risky or failed sign-in review examples
- Conditional Access result visibility where relevant

### Administrative auditing
- audit-log baseline
- evidence of admin/configuration event review

### Endpoint monitoring
- clearer compliance review workflows
- configuration drift or policy-state observation
- LAPS operational-state observation after validation matures

### Protection monitoring
- DLP event review
- label usage awareness
- correlation between user activity and protection controls where useful

---

## Evidence Areas

The current monitoring baseline draws indirectly from several evidence areas across the repo, especially:

- `screenshots/release1/release1-entra/`
- `screenshots/release1/release1-entra-sync/`
- `screenshots/release1/release1-m365/`
- `screenshots/release1/release1-intune/`
- `screenshots/release1/release1-identity-protection/`
- `screenshots/release1/release1-purview/`

These areas provide the current visibility story even before a dedicated monitoring/alerting evidence set is fully built.

---

## Diagram Placement Recommendation

This document does not need a standalone large diagram immediately.

Best later options:
- use the main Release 1 architecture diagram in README and high-level overview docs
- use one or two selected screenshots here later to show actual monitoring visibility
- optionally add a small “visibility and alerting direction” flow diagram later if needed

For now, content clarity is more important than a new diagram.

---

## Suggested Embedded Screenshot Strategy

This file should stay light.

Recommended maximum for a later final pass:
- one Entra or Microsoft 365 visibility screenshot
- one Intune device-state / compliance screenshot
- one Purview policy or policy-tip screenshot if you want to show monitoring as cross-cutting validation

That is enough to support the story without pretending a full monitoring stack exists.

---

## Why This Matters Professionally

This document is important because it shows architectural honesty.

It does not pretend that Release 1 has a complete SOC or fully engineered alerting platform. Instead, it shows:

- where operational visibility already exists
- where the current baseline is strong
- what still needs to be built
- how monitoring connects to identity, endpoint, and content protection

That is a more credible and professional presentation than overstating monitoring maturity.

---

## Summary

Release 1 currently demonstrates a **monitoring baseline**, not a mature alerting program.

What already exists is:

- identity and admin visibility
- endpoint inventory and compliance visibility
- control outcome observability across endpoint and Purview workflows
- recovery visibility through stale-object and rebuild scenarios

What still needs to be built is:

- formal sign-in log review
- audit-log baseline
- example alert configuration
- stronger operational documentation
- later integration with broader security-monitoring tooling

This should be presented as a realistic next-maturity layer in the Release 1 story.
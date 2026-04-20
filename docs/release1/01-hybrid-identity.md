# Hybrid Identity

## Purpose

This page explains how Release 1 introduced hybrid identity between on-premises Active Directory and Microsoft Entra ID using a controlled pilot model rather than broad synchronization from day one.

It covers the identity foundation, synchronization approach, access-control baseline, and the role hybrid identity played in enabling later Microsoft 365 validation.

---

## What This Page Proves

This page proves that Release 1 established a functioning hybrid identity foundation with:

- Active Directory as the authoritative on-premises identity source
- Microsoft Entra ID integration through Entra Connect Sync
- controlled pilot synchronization using filtering and scoped inclusion
- Password Hash Synchronization (PHS) for cloud authentication readiness
- supporting identity controls around Conditional Access, MFA, and SSPR
- identity readiness that enabled Exchange hybrid, endpoint management, and Microsoft 365 service validation

---

## Why It Matters

Without hybrid identity, the rest of Release 1 would be disconnected cloud services.

This work enabled:
- reduced gap between on-premises Active Directory and Microsoft 365 access
- safe pilot-first rollout without bulk synchronization
- practical baseline for Conditional Access, MFA, and supportability
- downstream validation of Exchange hybrid, Intune, and Microsoft 365 services

---

## Implementation Story

The starting point for Release 1 was a traditional on-premises Active Directory environment that needed to connect cleanly to Microsoft 365 without turning hybrid identity into an uncontrolled bulk synchronization exercise.

The chosen approach was to:
- retain Active Directory as the source of identity authority
- introduce Microsoft Entra ID as the cloud identity and access layer
- use Entra Connect Sync with controlled filtering and pilot scope
- validate cloud user visibility, authentication readiness, and synchronization behavior before treating hybrid identity as stable

This made hybrid identity a deliberate engineering foundation rather than a one-step migration shortcut.

---

## Identity Design Approach

### Active Directory as the Source of Authority

On-premises Active Directory remained the authoritative source for pilot user and device identity during Release 1.

This mattered because Release 1 was not intended to simulate a cloud-only environment. The goal was to demonstrate a realistic hybrid estate where:
- identities originate on-premises
- synchronization is deliberate
- cloud services inherit from a managed source rather than ad hoc account creation

### Microsoft Entra ID as the Cloud Identity Layer

Microsoft Entra ID provided:
- synchronized cloud identity presence
- Conditional Access capability
- authentication and user-state visibility
- the access layer required by Microsoft 365 and Intune

### Entra Connect Sync with Pilot Filtering

Synchronization was intentionally scoped. Rather than synchronizing the whole directory immediately, Release 1 used filtering and pilot inclusion logic so that:
- only intended users and objects entered the cloud estate
- testing stayed controlled
- errors or design mistakes would not affect the full identity population

This pilot-first design is one of the clearest maturity signals in the release.

### Password Hash Synchronization (PHS)

PHS was used to support the cloud authentication path in a way that was practical for the Release 1 pilot model. This provided:
- a manageable hybrid authentication baseline
- lower implementation complexity than a more advanced federation approach
- enough realism to validate Microsoft 365 user access and service readiness

---

## Identity Protection and Access Baseline

Release 1 also established the identity-control baseline needed to make hybrid identity meaningful rather than merely connected. This included:

- **Conditional Access** as the policy layer connecting identity to device and access conditions
- **MFA** as part of the authentication-hardening story
- **SSPR** as part of the user support and identity self-service posture
- **LAPS policy configuration** as a related endpoint/identity protection control, while keeping retrieval and recovery scope carefully bounded

In the Release 1 pilot model, Conditional Access linked cloud identity with endpoint trust and authentication hardening. A compliant-device and MFA requirement is a good representation of the intended control posture behind the sign-in evidence shown later in this page.

These controls matter because hybrid identity without access policy is only partial progress. Release 1 aimed to connect identity synchronization with real access governance.

---

## Flagship Evidence

### 1. Entra Connect Filtering and Synchronization Scope

![Entra Connect filtering users and devices](../../screenshots/release1/identity-and-access/entra-sync/11-entra-connect-filtering-users-devices.png)

*Entra Connect Sync configuration showing pilot filtering decisions, demonstrating that hybrid identity was introduced in a controlled manner rather than by synchronizing the full environment immediately.*

### 2. Pilot Users Visible in Microsoft 365

![Pilot users visible in Microsoft 365](../../screenshots/release1/identity-and-access/entra-sync/15-m365-active-users-pilot-synced.png)

*Pilot users visible in Microsoft 365 after synchronization, confirming that the scoped hybrid identity path was functioning and that the cloud-side user estate was ready for downstream service validation.*

### 3. Conditional Access Result Visibility

![Conditional Access result](../../screenshots/release1/monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)

*Sign-in result showing Conditional Access visibility, linking the synchronized identity layer to access-control review and operational monitoring.*

---

## What Was Validated

The Release 1 hybrid identity work validated that:
- pilot user identities could be synchronized cleanly into Microsoft Entra ID
- filtered synchronization helped control blast radius and maintain release discipline
- cloud identity visibility supported Microsoft 365 service testing
- access-control signals were visible through monitoring and sign-in review
- hybrid identity was stable enough to support Exchange hybrid pilot validation and endpoint onboarding flows

---

## Operational Insight

The most important design decision was to use controlled synchronization and pilot filtering first. That reduced avoidable identity sprawl, made troubleshooting easier, and reinforced the release's pilot-first discipline.

---

## Scope Boundaries

Release 1 hybrid identity should be read as an **implemented and evidenced pilot foundation**, not as a claim to every enterprise identity feature.

The following boundaries are important:
- Release 1 does **not** claim a full identity lifecycle automation programme
- Release 1 does **not** claim broad federation or advanced identity architecture beyond the implemented pilot model
- Conditional Access, MFA, SSPR, and related controls are part of the baseline, but not every possible enterprise access-policy scenario is represented
- LAPS should be discussed carefully as configured policy scope, not as a fully evidenced password retrieval or recovery workflow unless specifically proven elsewhere
- PKI and certificate trust were strategically relevant to hybrid service readiness, but Release 1 did **not** deploy a full internal AD CS / enterprise PKI platform

---

## Related Documents

- [Release 1 Summary](00-summary.md)
- [Modern Workplace](02-modern-workplace.md)
- [Monitoring](08-monitoring.md)
- [Build Checklist](11-build-checklist.md)
- [Extensions and Future Enhancements](12-extensions-and-future-enhancements.md)

For cross-release context:
- [Platform Overview](../foundation/01-platform-overview.md)
- [Target-State Architecture](../foundation/03-target-state-architecture.md)
- [Roadmap](../foundation/04-roadmap.md)
- [Skills and Evidence Index](../foundation/05-skills-and-evidence-index.md)

---

## Related Evidence

- [Identity and Access Evidence Hub](../../screenshots/release1/identity-and-access/README.md)
- [Release 1 Evidence Dashboard](../../screenshots/release1/README.md)


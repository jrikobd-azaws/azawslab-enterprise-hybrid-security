# Identity and Access Evidence Hub

**Revised: April 2026**

## Purpose

This page is the guided evidence index for the identity and access portion of the implemented platform. It exists to make the screenshot archive easier to review by grouping evidence into the main control areas:

- **Entra Connect Sync** - pilot synchronization scope
- **Identity Protection Context** - Conditional Access, MFA, SSPR
- **Conditional Access & Sign-In Visibility**
- **Graph PowerShell Lifecycle Automation** - leaver and mover scenarios (advanced validation)

This page should be read as an evidence hub, not as a narrative implementation document.

## What This Evidence Set Proves

The identity and access evidence demonstrates that the platform established a practical hybrid identity foundation with a controlled pilot model, moving beyond simple synchronization to include advanced, automated lifecycle management. It shows:

- Active Directory to Microsoft Entra ID synchronization in a controlled pilot model
- Entra Connect Sync filtering rather than uncontrolled full-directory sync
- Conditional Access-related sign-in visibility
- **Graph PowerShell lifecycle automation** (leaver and mover scenarios)

## How to Use This Hub

Use this page in one of three ways:
- **Start with flagship proof** for the strongest screenshots (including new advanced validation)
- **Browse by control area** for evidence grouped by sync, visibility, and automation
- **Follow the related docs** for implementation narrative

## Start Here: Flagship Proof

This table has been updated to include key evidence from your advanced Graph PowerShell work.

| Proof Area | What it demonstrates | Best evidence |
| :--- | :--- | :--- |
| **Entra Connect filtering** | Hybrid identity introduced through scoped pilot sync | [Entra Connect filtering users and devices](entra-sync/11-entra-connect-filtering-users-devices.png) |
| **Pilot users visible** | Sync success, cloud identity ready for service validation | [Pilot users synced to Microsoft 365](entra-sync/15-m365-active-users-pilot-synced.png) |
| **Conditional Access result visibility** | Access-control outcomes visible in sign-in monitoring | [Conditional Access result in sign-in logs](../monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png) |
| **Graph PowerShell: leaver scenario** | Disable user account via Graph API and PowerShell | [User access disable apply result](identity-operations/lifecycle/02-user-access-disable-apply-pilot-win02.png) |
| **Graph PowerShell: mover scenario** | Department change triggers dynamic group membership and Slack app access | [Slack available in My Apps after department move](identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png) |

## Evidence by Control Area

### 1. Entra Connect Sync
Contains proof of controlled, pilot-first hybrid identity introduction.

**Start here:**
- [Entra Sync Folder](entra-sync/)

**Best evidence:**
- [Entra Connect filtering users and devices](entra-sync/11-entra-connect-filtering-users-devices.png)
- [Pilot users synced to Microsoft 365](entra-sync/15-m365-active-users-pilot-synced.png)

**Related docs:**
- [Hybrid Identity Implementation](../../../docs/release1/01-hybrid-identity.md)

### 2. Identity Protection Context
Supporting identity-protection evidence for access posture and admin controls.

**Best evidence:**
- [Conditional Access policy requiring MFA and compliant device](identity-protection/conditional-access/08-ca03-grant-require-mfa-and-compliant-device.png)
- [MFA authentication method policy](identity-protection/mfa/01-mfa-authenticator-method-policy-targeted-to-sg-pilot-mfa-sspr-ca.png)

**Related docs:**
- [Hybrid Identity - Identity Protection](../../../docs/release1/01-hybrid-identity.md)

### 3. Conditional Access and Sign-In Visibility
Demonstrates visible, auditable access outcomes for support investigation and monitoring.

**Best evidence:**
- [Conditional Access result in sign-in logs](../monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)

**Related docs:**
- [Monitoring - Sign-In Review](../../../docs/release1/08-monitoring.md)

### 4. Graph PowerShell Lifecycle Automation (Advanced Validation)
Shows operator-led identity automation for leaver and mover scenarios, with dry-run safety.

**Best evidence:**
- [User access disable apply result](identity-operations/lifecycle/02-user-access-disable-apply-pilot-win02.png) (Leaver)
- [Slack available in My Apps after department move](identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png) (Mover)

**Related docs:**
- [Hybrid Identity - Lifecycle Automation](../../../docs/release1/01-hybrid-identity.md)
- [Identity Lifecycle Scripts](../../../scripts/release1/identity/graph-lifecycle/)

## Recommended Review Path

For the fastest high-value evidence path covering both core sync and advanced automation:

1.  [Entra Connect filtering users and devices](entra-sync/11-entra-connect-filtering-users-devices.png)
2.  [Pilot users synced to Microsoft 365](entra-sync/15-m365-active-users-pilot-synced.png)
3.  [Conditional Access result in sign-in logs](../monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)
4.  [User access disable apply result](identity-operations/lifecycle/02-user-access-disable-apply-pilot-win02.png)
5.  [Slack available in My Apps after department move](identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png)

This sequence gives the fastest view of:
- controlled synchronization
- cloud identity readiness
- access-control outcome visibility
- **automated identity lifecycle management for both leaver and responder scenarios**

## Relationship to the Documentation

Use the **documentation** when you want:
- hybrid identity rationale
- synchronization design choices
- scope boundaries
- business value
- relationship to Exchange hybrid and endpoint trust

Use this **evidence hub** when you want:
- direct proof of sync filtering
- direct proof of synchronized pilot-user visibility
- direct proof of access-result monitoring
- **direct proof of Graph PowerShell lifecycle automation**

**Best related reading path:** [Hybrid Identity - Lifecycle Automation](../../../docs/release1/01-hybrid-identity.md)

## Scope Boundaries

This evidence set is strong, but it should be read carefully. It does not imply that every adjacent identity capability is already complete. Examples of intentionally limited or carefully scoped areas include:

- broader federation architecture beyond implemented pilot model
- integration with an external HRIS source of truth
- full enterprise PKI / AD CS deployment

The following are now fully implemented as advanced validation and are no longer "deferred":
- full identity lifecycle automation (disable, session revoke, enable)
- mover scenario (department change → dynamic group → Slack access)
- stronger operational validation of Windows LAPS retrieval workflows

These boundaries are documented in: [Build Checklist - Identity](../../../docs/release1/11-build-checklist.md), [Extensions and Future Enhancements](../../../docs/release1/12-extensions-and-future-enhancements.md), [Skills and Evidence Index](../../../docs/foundation/05-skills-and-evidence-index.md)

## Related Pages

- [Release 1 Evidence Dashboard](../README.md)
- [Skills and Evidence Index](../../../docs/foundation/05-skills-and-evidence-index.md)
- [Root README](../../../README.md)
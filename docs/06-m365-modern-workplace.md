# Microsoft 365 Modern Workplace

## Purpose

This document records the Microsoft 365 tenant setup, namespace onboarding, pilot licensing state, Exchange Online readiness position, and current Release 1 hybrid messaging status for the `azawslab Enterprise Hybrid Security Platform`.

The purpose of this phase is to establish a realistic Microsoft 365 foundation that supports hybrid identity, staged Exchange migration, and later modern workplace controls across Exchange Online, Teams, SharePoint, Intune, and security services.

---

## Release 1 Scope for This Document

This document covers:

- Microsoft 365 tenant onboarding
- domain and namespace onboarding
- pilot licensing state
- initial cloud sign-in validation
- Exchange Online readiness position
- hybrid messaging status and current blocker
- later Release 1 workplace phases that remain pending

It does not claim that Teams, SharePoint, Intune, Purview, or Conditional Access are fully implemented unless separately documented.

---

## Tenant Overview

The Microsoft 365 tenant exists and is active.

### Tenant Name

`AZAWSLABUK.onmicrosoft.com`

### Primary Cloud Administration Context

Administrative work has been performed using:

`Hashib@AZAWSLABUK.onmicrosoft.com`

This account is used for tenant onboarding, validation, and hybrid-related administration where required.

---

## Domain and Namespace Onboarding

The following domains have been added to the tenant:

- `azawslab.co.uk`
- `corp.azawslab.co.uk`

### Important Namespace Separation

This environment uses deliberate namespace separation during Release 1.

#### Root Business Namespace

`azawslab.co.uk`

- remains associated with Zoho
- continues to represent the root business namespace
- is not being repointed during the pilot hybrid phase

#### Hybrid Pilot Namespace

`corp.azawslab.co.uk`

- is the dedicated hybrid pilot namespace
- is used for pilot synchronized users
- is the namespace used for Exchange hybrid readiness and migration validation

### Why This Matters

This design allows hybrid and migration work to proceed safely without disrupting the root business mail namespace.

It also means users in the pilot namespace must not be confused with Zoho mailbox users.

For example:

- `u.hr01@corp.azawslab.co.uk`
- `u.finance01@corp.azawslab.co.uk`

are hybrid pilot users, not Zoho mailbox users.

---

## Microsoft 365 Identity and Access State

Microsoft 365 tenant access is already functional for pilot scope through the hybrid identity configuration documented in `docs/05-hybrid-identity.md`.

### Current Confirmed State

- pilot synchronized users are present in the tenant
- pilot licenses have been assigned successfully
- at least one pilot user has successfully signed in to Microsoft 365
- web application access has been validated

### Initial App Access Validation

Validation has already been performed using Microsoft 365 web apps such as:

- Designer
- Excel for the web

This confirms that:

- the tenant is operational
- pilot identity synchronization is working
- license assignment is functional
- basic cloud application access is available

---

## Exchange Online Readiness Position

The tenant is prepared as part of the staged Exchange hybrid migration path, but Exchange Online mailbox migration has not yet been completed.

### Current Exchange Online State

At the time of initial validation:

- pilot users did not yet have Exchange Online mailboxes
- Outlook on the web returned mailbox-not-found for pilot users

This was treated as an expected pre-migration state.

It was not interpreted as:

- a tenant access failure
- a sign-in problem
- a licensing failure

### Practical Interpretation

This is normal for the current design because the project intentionally follows a staged migration path:

1. keep mailboxes on-premises first
2. validate hybrid identity and cloud access
3. configure Exchange hybrid path
4. create migration readiness
5. perform pilot mailbox moves

This is the correct enterprise-style sequence for the project.

---

## Exchange Hybrid Position in Microsoft 365 Context

Release 1 includes a realistic Exchange hybrid migration path rather than a shortcut cloud-only mailbox build.

### On-Premises Messaging Source

The source platform is:

- **Exchange Server Subscription Edition (Exchange SE)**

Hosted on:

- `EXCH1`

### Hybrid Design Decisions Already Locked

The following decisions are already made and should remain stable unless a technical blocker forces change:

- selected hybrid path: **Modern Hybrid**
- selected HCW mode: **Minimal**
- HCW execution host: `EXCH1`
- root namespace `azawslab.co.uk` remains on Zoho
- hybrid pilot namespace is `corp.azawslab.co.uk`
- selected pilot mailbox move candidates:
  - `u.finance01`
  - `u.hr01`
- validation/admin account:
  - `u.hashibur`

---

## Hybrid Configuration Wizard Status

Hybrid Configuration Wizard has already been launched from `EXCH1` and progressed through the expected hybrid setup stages.

### HCW Progress Already Completed

The wizard progressed through:

- Exchange detection
- credential screens
- hybrid feature selection
- Minimal Hybrid selection
- Modern Hybrid / Hybrid Agent path
- Hybrid Agent installation and registration
- Hybrid Agent validation
- hybrid configuration phase

### Current HCW Result

HCW finished in a partial-success state.

Confirmed result:

- hybrid services were configured between Exchange Online and on-premises Exchange
- migration endpoint creation did not complete successfully

### Current Technical Blocker

The current blocker is:

`HCW8078 - Migration Endpoint could not be created`

This is the current implementation point for Release 1.

---

## Troubleshooting Already Completed

The following hybrid troubleshooting work has already been completed and should not be repeated as if it were still pending:

- EWS external URL set to:
  - `https://mail.corp.azawslab.co.uk/EWS/Exchange.asmx`
- MRS Proxy enabled on:
  - `EWS (Default Web Site)`
- Extended Protection checks and adjustments completed:
  - `Default Web Site > EWS = Off`
  - `Exchange Back End > EWS = Required`
- `iisreset` completed after changes
- Hybrid Agent validation succeeded

These steps form part of the documented troubleshooting history and should be reflected in lessons learned and evidence capture.

---

## Current Release 1 Position

The Microsoft 365 portion of Release 1 is beyond tenant setup and early identity validation.

### Completed in This Area

- tenant creation
- domain onboarding
- pilot licensing
- pilot Microsoft 365 sign-in validation
- basic web app access validation
- initial Modern Hybrid configuration through HCW

### In Progress

- hybrid validation
- migration endpoint creation
- remote-move readiness

### Not Yet Complete

- pilot mailbox migration
- broader Exchange Online coexistence validation
- Teams baseline
- SharePoint baseline
- Intune / endpoint administration baseline
- advanced Zero Trust controls
- Purview / information protection controls
- monitoring and alerting baseline

---

## Remaining Actions

The correct continuation point for Microsoft 365 modern workplace work is now:

1. complete migration endpoint validation
2. confirm remote-move readiness
3. perform pilot mailbox migration for:
   - `u.finance01`
   - `u.hr01`
4. validate Exchange Online mailbox access post-migration
5. continue broader Release 1 Microsoft 365 baseline work:
   - Teams baseline
   - SharePoint baseline
   - admin setup documentation
   - later security/compliance integrations

This sequence keeps the project aligned to the actual build state.

---

## Evidence to Capture

The following evidence should be retained in the repository:

- tenant overview
- verified domains list
- domain ownership / onboarding evidence
- pilot user license assignment
- successful pilot sign-in evidence
- Microsoft 365 web app access evidence
- Outlook on the web pre-migration mailbox-not-found evidence
- HCW progress screens
- HCW partial-success screen showing HCW8078
- migration endpoint validation evidence after remediation

---

## Related Documents

- `docs/03-current-state-architecture.md`
- `docs/05-hybrid-identity.md`
- `docs/12-lessons-learned.md`
- `docs/13-release1-build-checklist.md`

---

## Summary

Release 1 Microsoft 365 work has successfully moved beyond tenant creation into pilot-ready hybrid identity and messaging preparation.

The environment now has:

- an active Microsoft 365 tenant
- verified domain onboarding
- deliberate namespace separation
- licensed pilot users
- successful cloud sign-in validation
- initial Modern Hybrid configuration substantially completed

The current technical gap is migration endpoint creation and remote-move readiness, which must be completed before pilot mailbox migration can begin.
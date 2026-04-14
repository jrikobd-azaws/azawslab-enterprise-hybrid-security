# Hybrid Identity

## Purpose

This document records the hybrid identity design, implementation state, namespace decisions, pilot synchronization scope, and current migration-readiness position for Release 1 of the `azawslab Enterprise Hybrid Security Platform`.

The objective of this phase is to establish a working hybrid identity foundation between on-premises Active Directory and Microsoft Entra ID, while preparing a realistic Exchange hybrid migration path for pilot users.

---

## Release 1 Scope for This Document

This document covers:

- on-premises Active Directory identity source
- Entra Connect Sync on MEM1
- pilot synchronization scope
- namespace design decisions
- pilot licensing and sign-in validation
- readiness for Exchange hybrid mailbox migration

It does not claim completion of broader Zero Trust, Intune, or Purview controls unless separately documented in those relevant files.

---

## On-Premises Identity Foundation

The on-premises Active Directory domain for the lab is:

`corp.azawslab.co.uk`

### Domain Controller State

- `DC1` deployed as primary domain controller and DNS server
- `DC2` deployed as additional domain controller and DNS server
- DNS functionality validated
- AD replication validated

### Organizational Design

A tiered OU structure is in place.

Standard pilot users are located under:

`Tier-2 > User Accounts > Standard Users`

This structure supports cleaner administration, pilot scoping, and later governance/control mapping.

---

## Hybrid Identity Design

### Synchronization Host

Microsoft Entra Connect Sync is installed on:

`MEM1`

### Selected Sign-In Method

The selected sign-in method is:

- **Password Hash Synchronization (PHS)**

This was chosen to keep Release 1 practical, support pilot cloud access quickly, and avoid unnecessary authentication complexity during initial hybrid identity rollout.

### Synchronization Scope Controls

The synchronization design uses multiple scope controls:

- OU filtering configured
- group-based filtering configured
- pilot synchronization group:
  - `SG-Pilot-Hybrid-Sync`

This allows the environment to remain controlled and supports pilot-first validation without synchronizing unnecessary identities.

---

## Pilot Identity Scope

The current pilot synchronized users are:

- `u.hashibur`
- `u.finance01`
- `u.hr01`

These users appear in:

- Microsoft 365 admin center
- Microsoft Entra admin center

This confirms that Entra Connect Sync is operational at pilot scope.

---

## Licensing and Sign-In Validation

### Pilot Licensing State

Pilot users have been licensed successfully.

### Sign-In Validation State

At least one pilot user successfully signed in to Microsoft 365.

Access was validated using Microsoft 365 web applications such as:

- Designer
- Excel for the web

This confirms that:

- synchronized identities are present in the tenant
- pilot licensing is functional
- basic cloud access is working

### Outlook on the Web Clarification

Outlook on the web initially returned a mailbox-not-found result for pilot users.

This was treated as an expected pre-migration state because the users did not yet have Exchange Online mailboxes. This was not interpreted as a sign-in failure.

---

## Namespace and Identity Design Decisions

The project uses deliberate namespace separation during the pilot phase.

### Root Business Namespace

`azawslab.co.uk`

- remains associated with Zoho
- continues to represent the root business namespace
- is not being repointed during initial hybrid pilot work

### Hybrid Pilot Namespace

`corp.azawslab.co.uk`

- is the dedicated hybrid pilot namespace
- is used for pilot synchronized users
- is the namespace used for Exchange hybrid and migration-readiness work

### Important Clarification

Users such as:

- `u.hr01@corp.azawslab.co.uk`
- `u.finance01@corp.azawslab.co.uk`

are not Zoho mailbox users.

This separation is intentional and avoids disrupting root business mail flow while hybrid work is validated.

---

## Hybrid Messaging Relationship to Identity

Hybrid identity in this phase supports a staged real-world migration approach:

- mailboxes remain on-premises first
- identity and licensing are validated in Microsoft 365
- Exchange hybrid and migration path are built next
- pilot mailbox moves are performed only after migration readiness is confirmed

This avoids creating shortcut cloud mailboxes that would break the intended migration narrative and technical sequence.

---

## Exchange Hybrid Dependency Notes

Hybrid identity work in this phase is tightly linked to the Exchange hybrid build.

### Exchange Source Platform

The on-premises messaging source platform is:

- **Exchange Server Subscription Edition (Exchange SE)**

Hosted on:

- `EXCH1`

### Hybrid Design Decisions Already Locked

The following design choices are already made and should not be revisited unless a technical blocker forces change:

- selected hybrid path: **Modern Hybrid**
- selected HCW mode: **Minimal**
- planned HCW execution host: `EXCH1`
- pilot mailbox move candidates:
  - `u.finance01`
  - `u.hr01`
- validation/admin account:
  - `u.hashibur`
- `azawslab.co.uk` remains on Zoho
- `corp.azawslab.co.uk` is the hybrid migration namespace

---

## Current Status

Hybrid identity is operational at pilot scope.

Completed state:

- on-premises AD identity source established
- Entra Connect Sync installed on MEM1
- Password Hash Synchronization configured
- OU filtering configured
- group-based filtering configured using `SG-Pilot-Hybrid-Sync`
- pilot identities synchronized successfully
- pilot licensing completed
- pilot Microsoft 365 sign-in validated

Current dependency state:

- Modern Hybrid configuration has been run through HCW
- hybrid services were configured
- migration endpoint creation did not complete successfully
- current blocker:
  - `HCW8078 - Migration Endpoint could not be created`

This means hybrid identity is working, but mailbox-move readiness is not yet fully complete.

---

## What Has Already Been Completed Around HCW

The following supporting work has already been performed during hybrid troubleshooting:

- EWS external URL set to:
  - `https://mail.corp.azawslab.co.uk/EWS/Exchange.asmx`
- MRS Proxy enabled on:
  - `EWS (Default Web Site)`
- Extended Protection adjusted for EWS as follows:
  - `Default Web Site > EWS = Off`
  - `Exchange Back End > EWS = Required`
- `iisreset` completed after changes
- Hybrid Agent validation succeeded

These actions should be treated as completed troubleshooting history, not future tasks.

---

## Remaining Actions

The remaining actions for this hybrid identity phase are now:

1. validate migration endpoint creation
2. confirm remote-move readiness
3. perform pilot mailbox migration for:
   - `u.finance01`
   - `u.hr01`
4. capture final evidence and update GitHub/tracker records

This is the correct continuation point for the project.

---

## Evidence to Capture

The following evidence should be retained in the repository screenshot/evidence set:

- Entra Connect Sync configuration summary on MEM1
- OU filtering configuration
- group-based filtering / `SG-Pilot-Hybrid-Sync`
- synced pilot users in Entra admin center
- synced pilot users in Microsoft 365 admin center
- pilot license assignment
- successful pilot sign-in evidence
- HCW completion state
- HCW8078 error evidence
- EWS / MRS Proxy / relevant Exchange validation evidence

---

## Related Documents

- `docs/03-current-state-architecture.md`
- `docs/06-m365-modern-workplace.md`
- `docs/12-lessons-learned.md`
- `docs/13-release1-build-checklist.md`

---

## Summary

Release 1 hybrid identity work is largely complete at pilot scope.

The environment now has:

- working on-premises AD
- pilot-scoped Entra synchronization
- licensed pilot users
- successful Microsoft 365 sign-in validation
- locked namespace separation for safe pilot work
- Modern Hybrid configuration substantially completed

The remaining technical gap is migration endpoint creation and remote-move readiness for pilot mailbox migration.
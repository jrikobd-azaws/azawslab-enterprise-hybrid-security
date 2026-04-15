# Microsoft 365 Modern Workplace

## Purpose

This document records the Microsoft 365 tenant setup, namespace onboarding, pilot licensing state, Exchange Online migration outcome, and current Release 1 Microsoft 365 position for the `azawslab Enterprise Hybrid Security Platform`.

The purpose of this phase is to establish a realistic Microsoft 365 foundation that supports hybrid identity, staged Exchange migration, and later modern workplace controls across Exchange Online, Teams, SharePoint, Intune, and security services.

---

## Release 1 Scope for This Document

This document covers:

- Microsoft 365 tenant onboarding
- domain and namespace onboarding
- pilot licensing state
- initial cloud sign-in validation
- Exchange Online migration readiness and recovery path
- pilot migration outcome
- real-world mail flow context relevant to the migrated pilot design
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

This account was used for tenant onboarding, validation, hybrid-related administration, migration endpoint work, and pilot migration management where required.

---

## Domain and Namespace Onboarding

The following domains were added to the tenant:

- `azawslab.co.uk`
- `corp.azawslab.co.uk`

### Important Namespace Separation

This environment uses deliberate namespace separation during Release 1.

#### Root Business Namespace

`azawslab.co.uk`

- remains associated with Zoho
- continues to represent the root business namespace
- was not repointed during the pilot hybrid phase

#### Hybrid Pilot Namespace

`corp.azawslab.co.uk`

- is the dedicated hybrid pilot namespace
- was used for pilot synchronized users
- was the namespace used for Exchange hybrid readiness and migration validation

### Why This Matters

This design allowed hybrid and migration work to proceed safely without disrupting the root business mail namespace.

It also meant users in the pilot namespace must not be confused with Zoho mailbox users.

For example:

- `u.hr01@corp.azawslab.co.uk`
- `u.finance01@corp.azawslab.co.uk`

were hybrid pilot users, not Zoho mailbox users.

---

## Microsoft 365 Identity and Access State

Microsoft 365 tenant access became functional for pilot scope through the hybrid identity configuration documented in `docs/05-hybrid-identity.md`.

### Current Confirmed State

- pilot synchronized users were present in the tenant
- pilot licenses were assigned successfully
- at least one pilot user successfully signed in to Microsoft 365
- web application access was validated

### Initial App Access Validation

Validation was performed using Microsoft 365 web apps such as:

- Designer
- Excel for the web

This confirmed that:

- the tenant was operational
- pilot identity synchronization was working
- license assignment was functional
- basic cloud application access was available

---

## Exchange Online Readiness and Migration Outcome

The tenant was prepared as part of a staged Exchange hybrid migration path rather than as a cloud-only mailbox deployment.

### Pre-Migration State

At the time of initial validation:

- pilot users did not yet have Exchange Online mailboxes
- Outlook on the web returned mailbox-not-found for pilot users

This was treated as an expected pre-migration state.

It was not interpreted as:

- a tenant access failure
- a sign-in problem
- a licensing failure

### Practical Interpretation

This was normal for the design because the project intentionally followed a staged migration path:

1. keep mailboxes on-premises first
2. validate hybrid identity and cloud access
3. configure Exchange hybrid path
4. validate migration readiness
5. perform pilot mailbox moves

This is the correct enterprise-style sequence for the project.

---

## Exchange Hybrid Position in Microsoft 365 Context

Release 1 included a realistic Exchange hybrid migration path rather than a shortcut cloud-only mailbox build.

### On-Premises Messaging Source

The source platform is:

- **Exchange Server Subscription Edition (Exchange SE)**

Hosted on:

- `EXCH1`

### Hybrid Design Decisions Already Locked

The following decisions were made and remained stable through migration completion:

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

Hybrid Configuration Wizard was launched from `EXCH1` and progressed through the expected hybrid setup stages.

### HCW Progress Completed

The wizard progressed through:

- Exchange detection
- credential screens
- hybrid feature selection
- Minimal Hybrid selection
- Modern Hybrid / Hybrid Agent path
- Hybrid Agent installation and registration
- Hybrid Agent validation
- hybrid configuration phase

### HCW Warning Outcome

HCW configured hybrid services between Exchange Online and on-premises Exchange, but completed with warning:

`HCW8078 - Migration Endpoint could not be created`

This became the key technical checkpoint in the project rather than the final outcome.

---

## Certificate and Migration Endpoint Recovery

### Root Cause Area

Manual testing showed that the remote move path could not establish SSL/TLS trust successfully using the initial certificate arrangement.

The working solution required correct certificate trust and name coverage for both:

- `mail.corp.azawslab.co.uk`
- `exch1.corp.azawslab.co.uk`

### Final Working Certificate State

The working Exchange-side configuration used a public-trust SAN certificate covering both required names.

An earlier certificate for `mail.corp.azawslab.co.uk` still existed, but it was not sufficient by itself for the final migration workflow.

In this lab, the final certificate was bound for IIS.

### Supporting Hybrid Troubleshooting Already Completed

The following work had already been completed during hybrid troubleshooting:

- EWS external URL set to:
  - `https://mail.corp.azawslab.co.uk/EWS/Exchange.asmx`
- MRS Proxy enabled on:
  - `EWS (Default Web Site)`
- Extended Protection checks and adjustments completed:
  - `Default Web Site > EWS = Off`
  - `Exchange Back End > EWS = Required`
- `iisreset` completed after changes
- Hybrid Agent validation succeeded

### Manual Recovery Path

Because HCW did not create the migration endpoint automatically, the endpoint was created later through PowerShell.

`Test-MigrationServerAvailability` then succeeded, confirming that the Exchange remote move path was valid.

This became the successful recovery path for the project.

---

## Pilot Migration Outcome

A pilot migration batch was created for:

- `u.finance01@corp.azawslab.co.uk`
- `u.hr01@corp.azawslab.co.uk`

Migration states progressed through synchronization and later completion.

Both pilot users completed migration successfully into Exchange Online mailboxes.

### Post-Migration Validation

Post-migration validation was performed using Outlook on the web.

This confirmed mailbox access for migrated pilot users after completion.

### What This Phase Proves

This phase now demonstrates:

- Microsoft 365 tenant onboarding
- pilot licensing and cloud access validation
- successful Modern Hybrid configuration
- recovery from HCW automatic endpoint-creation failure
- successful remote move validation
- successful pilot Exchange Online migration
- post-migration OWA validation for migrated users

---

## Real-World Mail Flow Context

The pilot users in this project were migrated as:

- `u.finance01@corp.azawslab.co.uk`
- `u.hr01@corp.azawslab.co.uk`

In the lab, the focus was on hybrid identity, migration endpoint readiness, remote move migration, and post-migration mailbox validation in Exchange Online.

However, in real enterprise implementations, mailbox location and public mail-routing path are not always the same thing. After migration, mail flow can follow different operational patterns depending on whether Microsoft 365 is the direct ingress point or whether a third-party secure email gateway remains in front.

These patterns are included as real-world delivery context relevant to the migration design; they were not all fully implemented in the lab.

### Option 1 — No third-party gateway

In a cloud-native design, mail flow is typically:

`Internet sender -> Exchange Online Protection / Microsoft 365 -> Exchange Online mailbox`

In this model:

- Microsoft 365 is the primary inbound mail platform
- Exchange Online Protection handles filtering and hygiene
- the migrated mailbox is delivered to directly in Exchange Online

### Option 2 — Mimecast or Proofpoint in front of Microsoft 365

In many real-world environments, a third-party secure email gateway remains the public MX target.

Mail flow is commonly:

`Internet sender -> Mimecast / Proofpoint -> Microsoft 365 / Exchange Online -> user mailbox`

In this model:

- Mimecast or Proofpoint remains the public MX endpoint
- spam, phishing, malware, attachment, impersonation, and URL filtering can occur there first
- cleaned mail is then relayed into Microsoft 365
- Exchange Online delivers to the migrated mailbox

The user still receives mail using the same SMTP identity, for example:

`user@corp.azawslab.co.uk`

but the mailbox itself now resides in Exchange Online.

### Option 3 — Hybrid coexistence during staged migration

During coexistence, some mailboxes may already be in Exchange Online while others still remain on-premises.

A common real-world routing pattern is:

`Internet sender -> Mimecast / Proofpoint -> Microsoft 365 / Exchange Online`

At that point, Microsoft 365 determines the mailbox location:

- if the recipient mailbox is in Exchange Online, mail is delivered there directly
- if the recipient mailbox is still on-premises, mail is routed back to on-premises Exchange through the hybrid connector path

This means coexistence routing can look like either:

`Internet -> Mimecast / Proofpoint -> Exchange Online mailbox`

or:

`Internet -> Mimecast / Proofpoint -> Exchange Online -> hybrid connector -> on-premises mailbox`

depending on where the mailbox is currently hosted.

### Why This Matters

This project validated pilot migration into Exchange Online, but the routing patterns above reflect the kinds of mail-flow decisions that exist in production environments.

This distinction matters because:

- mailbox migration does not always mean MX is moved immediately
- secure email gateways may remain in front of Microsoft 365
- hybrid routing must correctly support both cloud and on-premises recipients during coexistence
- namespace continuity can remain unchanged even while mailbox location changes

---

## Current Release 1 Position

The Microsoft 365 portion of Release 1 is now beyond tenant setup and early identity validation.

### Completed in This Area

- tenant creation
- domain onboarding
- pilot licensing
- pilot Microsoft 365 sign-in validation
- basic web app access validation
- initial Modern Hybrid configuration through HCW
- certificate trust and name coverage correction for Exchange migration
- manual migration endpoint creation
- successful `Test-MigrationServerAvailability`
- successful pilot mailbox migration
- post-migration Outlook on the web validation

### In Progress

- broader Microsoft 365 baseline beyond Exchange pilot migration
- documentation and evidence closeout

### Not Yet Complete

- Teams baseline
- SharePoint baseline
- Intune / endpoint administration baseline
- advanced Zero Trust controls
- Purview / information protection controls
- monitoring and alerting baseline

---

## Remaining Actions

The correct continuation point for Microsoft 365 modern workplace work is now:

1. document final migration evidence and scripts
2. continue broader Release 1 Microsoft 365 baseline work:
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
- HCW warning screen showing HCW8078
- migration endpoint creation evidence
- successful `Test-MigrationServerAvailability`
- pilot batch creation evidence
- migration user and batch completion evidence
- Outlook on the web validation for migrated pilot users

---

## Related Documents

- `docs/03-current-state-architecture.md`
- `docs/05-hybrid-identity.md`
- `docs/12-lessons-learned.md`
- `docs/13-release1-build-checklist.md`

---

## Summary

Release 1 Microsoft 365 work has moved beyond tenant creation into completed pilot-ready hybrid migration and Exchange Online mailbox validation.

The environment now has:

- an active Microsoft 365 tenant
- verified domain onboarding
- deliberate namespace separation
- licensed pilot users
- successful cloud sign-in validation
- Modern Hybrid configuration
- manual migration endpoint recovery after HCW warning
- successful pilot mailbox migration into Exchange Online
- post-migration Outlook on the web validation

The next major work is no longer migration unblock. It is the broader Release 1 Microsoft 365, endpoint, security, monitoring, and compliance baseline.
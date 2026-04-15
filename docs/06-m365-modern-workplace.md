# Microsoft 365 Modern Workplace

## Purpose

This document records the Microsoft 365 tenant setup, namespace onboarding, pilot licensing state, Exchange Online migration outcome, Teams baseline progress, SharePoint baseline progress, and current Release 1 Microsoft 365 position for the `azawslab Enterprise Hybrid Security Platform`.

The purpose of this phase is to establish a realistic Microsoft 365 foundation that supports hybrid identity, staged Exchange migration, collaboration services, and later modern workplace controls across Exchange Online, Teams, SharePoint, Intune, and security services.

---

## Release 1 Scope for This Document

This document covers:

- Microsoft 365 tenant onboarding
- domain and namespace onboarding
- pilot licensing state
- initial cloud sign-in validation
- Exchange Online migration readiness and recovery path
- pilot migration outcome
- Teams baseline validation
- SharePoint baseline validation
- real-world mail flow context relevant to the migrated pilot design
- later Release 1 workplace phases that remain pending

It does not claim that advanced Teams governance, advanced SharePoint governance, Intune policy depth, Purview, or Conditional Access are fully implemented unless separately documented.

---

## Tenant Overview

The Microsoft 365 tenant exists and is active.

### Tenant Name

`AZAWSLABUK.onmicrosoft.com`

### Primary Cloud Administration Context

Administrative work has been performed using:

`Hashib@AZAWSLABUK.onmicrosoft.com`

This account was used for tenant onboarding, validation, hybrid-related administration, migration endpoint work, pilot migration management, and Microsoft 365 service baseline administration where required.

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

### Migration Outcome

The Exchange hybrid path was recovered successfully after HCW warning `HCW8078`, the migration endpoint was created manually, `Test-MigrationServerAvailability` succeeded, and both pilot users completed migration successfully into Exchange Online mailboxes.

### Post-Migration Validation

Post-migration validation was performed using Outlook on the web for:

- `u.finance01@corp.azawslab.co.uk`
- `u.hr01@corp.azawslab.co.uk`

This confirmed mailbox access after migration.

---

## Teams Baseline

Teams baseline has now been validated at pilot scope.

### Admin-Side Validation

The Teams admin center showed the pilot users and service visibility required for Release 1 validation.

### User-Side Validation

Pilot users successfully accessed Teams on the web.

### Collaboration Validation

The following were validated:

- team visibility for `AZAWSLAB`
- `General` channel visibility
- channel post creation
- reply from a second pilot user
- direct chat between pilot users
- file collaboration in the channel
- meeting/calendar scheduling baseline

### What This Proves

This phase proves a practical Teams baseline for Release 1, including:

- user access
- chat
- team/channel collaboration
- file collaboration
- meeting scheduling

It does not yet claim deeper Teams governance such as advanced policy engineering, guest governance, external access design, or Teams Phone.

---

## SharePoint Baseline

SharePoint baseline has now been validated at pilot scope.

### Admin-Side Validation

The SharePoint admin center showed the `AZAWSLAB` site and membership details.

### User-Side Validation

Pilot-user browser access to the SharePoint site was validated successfully.

### Document Library Validation

The following were validated:

- access to the site and document library
- file presence in the library
- direct file upload into SharePoint
- file visibility after upload
- file open/read validation

### What This Proves

This phase proves a practical SharePoint baseline for Release 1, including:

- site existence
- site membership visibility
- document library access
- file upload
- file-open validation

It does not yet claim advanced SharePoint governance such as retention, lifecycle, external sharing policy engineering, or information protection integration.

---

## Relationship Between Teams and SharePoint in Release 1

The collaboration baseline in Release 1 now demonstrates the practical relationship between Microsoft Teams and SharePoint Online:

- Teams channel collaboration was validated in `AZAWSLAB`
- channel file sharing was validated in Teams
- SharePoint document library access and file validation were completed in the corresponding site

This is important because it shows awareness that Teams collaboration is closely tied to underlying SharePoint content storage and document access patterns.

---

## Real-World Mail Flow Context

The pilot users in this project were migrated as:

- `u.finance01@corp.azawslab.co.uk`
- `u.hr01@corp.azawslab.co.uk`

In the lab, the focus was on hybrid identity, migration endpoint readiness, remote move migration, and post-migration mailbox validation in Exchange Online.

However, in real enterprise implementations, mailbox location and public mail-routing path are not always the same thing.

### Option 1 — No third-party gateway

`Internet sender -> Exchange Online Protection / Microsoft 365 -> Exchange Online mailbox`

### Option 2 — Mimecast or Proofpoint in front of Microsoft 365

`Internet sender -> Mimecast / Proofpoint -> Microsoft 365 / Exchange Online -> user mailbox`

### Option 3 — Hybrid coexistence during staged migration

`Internet sender -> Mimecast / Proofpoint -> Microsoft 365 / Exchange Online`

Then Microsoft 365 determines mailbox location:

- if the mailbox is already in Exchange Online, deliver there directly
- if the mailbox is still on-premises, route back to on-premises through the hybrid connector path

These patterns are included as real-world delivery context relevant to the migration design; they were not all fully implemented in the lab.

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
- Teams baseline at pilot scope
- SharePoint baseline at pilot scope

### In Progress

- broader Microsoft 365 baseline beyond core Exchange/Teams/SharePoint validation
- documentation and evidence closeout

### Not Yet Complete

- advanced Teams governance
- advanced SharePoint governance
- broader admin policy depth
- Purview / information protection controls
- monitoring and alerting baseline

---

## Evidence to Capture

The following evidence should be retained in the repository:

- tenant overview
- verified domains list
- pilot user license assignment
- successful pilot sign-in evidence
- HCW warning screen showing HCW8078
- migration endpoint creation evidence
- successful `Test-MigrationServerAvailability`
- migration user and batch completion evidence
- Outlook on the web validation for migrated pilot users
- Teams admin/user/collaboration evidence
- SharePoint site/library/file validation evidence

---

## Related Documents

- `docs/05-hybrid-identity.md`
- `docs/07-endpoint-security-intune.md`
- `docs/12-lessons-learned.md`
- `docs/13-release1-build-checklist.md`

---

## Summary

Release 1 Microsoft 365 work has moved beyond tenant creation into completed pilot hybrid migration plus practical collaboration baseline validation.

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
- Teams baseline validated at pilot scope
- SharePoint baseline validated at pilot scope

The next major work is policy depth and the remaining Release 1 security, endpoint, monitoring, and governance layers.
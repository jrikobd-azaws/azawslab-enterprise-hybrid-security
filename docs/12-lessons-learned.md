# Lessons Learned

## Purpose

This document records technical decisions, implementation observations, troubleshooting notes, and practical lessons learned during the build of the `azawslab Enterprise Hybrid Security Platform`.

It is intended to show engineering thinking, not just final outcomes.

The project is being built as a phased, security-led, hybrid enterprise platform. This means decisions are made with realism, sequencing, operational safety, and evidence capture in mind.

---

## 1. Project Structure and Scope Lessons

### 1.1 One flagship phased platform is stronger than separate disconnected labs

A major early decision was to avoid building three unrelated large projects.

Instead, the platform was structured as one flagship enterprise hybrid security project with phased releases:

- Release 1 = hybrid identity, messaging, Microsoft 365, endpoint, security, and compliance foundation
- Release 2 = Azure platform, governance, delegated administration, and network/security expansion
- Release 3 = workload modernization, resilience, and observability

This creates a more realistic enterprise story and makes the GitHub repository easier to defend in interviews.

### 1.2 Security, compliance, and monitoring should not be treated as add-ons

Another early lesson was that security, governance, and monitoring must appear in every phase, rather than being attached later as separate topics.

This shaped the project structure, tracker design, documentation flow, and planned evidence capture.

---

## 2. Infrastructure Design Lessons

### 2.1 Hyper-V was the right practical lab choice

Hyper-V was selected as the primary platform for the lab because it fit the available hardware, Windows administration focus, and enterprise realism for the intended scope.

The internal switch design and host NAT approach allowed connectivity without overcomplicating the early network design.

### 2.2 Start with a stable on-premises identity core before layering cloud services

Building the domain, DNS, replication, OU structure, users, and baseline groups first provided a clean identity source for everything that followed.

This made later Entra Connect and Exchange work much easier to reason about.

### 2.3 Tiered OU design improved control and readability

Using a tiered OU structure made user placement, admin scoping, pilot grouping, and later policy mapping more structured.

Standard users were intentionally placed under:

`Tier-2 > User Accounts > Standard Users`

This improved clarity for both implementation and documentation.

---

## 3. Exchange and Hybrid Design Lessons

### 3.1 Exchange Server Subscription Edition should be described accurately everywhere

The project uses **Exchange Server Subscription Edition (Exchange SE)** as the on-premises messaging source platform.

A practical lesson was that all docs, trackers, and checklist items must use the correct product name consistently. Referring to Exchange 2019 after the platform decision creates confusion and weakens technical credibility.

### 3.2 A staged migration path is stronger than shortcut mailbox creation

The design intentionally kept mailboxes on-premises first, then built hybrid identity, then prepared hybrid messaging, and only after that moved toward pilot migration.

This was an important lesson in maintaining a realistic enterprise migration narrative.

Creating cloud mailboxes first would have been quicker, but it would have broken the hybrid migration story and reduced the credibility of the project.

### 3.3 Namespace separation reduced risk and protected realism

A key design decision was to separate:

- `azawslab.co.uk` as the root business namespace still associated with Zoho
- `corp.azawslab.co.uk` as the dedicated hybrid pilot namespace

This decision avoided unnecessary disruption of the root namespace while allowing hybrid pilot work to proceed safely.

This also created a useful lesson in documenting namespace intent clearly so that pilot users under `corp.azawslab.co.uk` are not confused with Zoho mailbox users.

### 3.4 Modern Hybrid was the correct path for this phase

The selected hybrid path was:

- **Modern Hybrid**
- **Minimal**
- HCW execution from `EXCH1`

This aligned well with the pilot-first project scope and kept the implementation practical.

The decision should not be revisited unless a genuine technical blocker makes it necessary.

---

## 4. Entra Connect and Identity Lessons

### 4.1 Password Hash Synchronization was the right choice for Release 1

Password Hash Synchronization provided the most practical balance between realism and simplicity for the pilot scope.

It supported fast cloud validation and avoided unnecessary complexity during the first hybrid phase.

### 4.2 Scoped synchronization is better than syncing everything

Using OU filtering plus group-based filtering with:

`SG-Pilot-Hybrid-Sync`

helped maintain control and made the pilot more defensible.

This also improved troubleshooting because the set of synchronized users remained small and intentional.

### 4.3 Cloud sign-in validation should be separated from mailbox validation

A useful lesson was that Microsoft 365 sign-in success and Exchange mailbox availability are not the same thing.

At least one pilot user successfully signed in to Microsoft 365 web apps, while Outlook on the web initially returned mailbox-not-found.

That was correctly interpreted as an expected pre-migration state rather than an authentication or licensing failure.

---

## 5. HCW and Hybrid Troubleshooting Lessons

### 5.1 HCW can partially succeed while still leaving migration blocked

One of the most important implementation lessons was that Hybrid Configuration Wizard can configure significant portions of the hybrid relationship and still end in a partial-success state.

In this project, HCW progressed through:

- Exchange detection
- credential prompts
- hybrid feature selection
- Minimal Hybrid selection
- Modern Hybrid / Hybrid Agent path
- Hybrid Agent installation and registration
- hybrid configuration

but initially ended with:

`HCW8078 - Migration Endpoint could not be created`

This meant hybrid progress had to be reported precisely, not simplistically as either “failed” or “complete.”

### 5.2 Hybrid Agent validation and migration endpoint creation are related but not identical

During troubleshooting, Hybrid Agent validation first failed with a timeout and later succeeded after the relevant checks and corrections.

That was useful because it proved the environment had moved past one layer of connectivity and configuration validation.

However, the migration endpoint still was not created automatically by HCW, showing that hybrid validation and migration readiness are related but not identical.

### 5.3 Certificate trust and name coverage were the decisive migration blocker

The most important technical blocker in the project turned out to be certificate trust and name coverage on the Exchange side.

An initial certificate arrangement centered only on `mail.corp.azawslab.co.uk` was not sufficient for the final hybrid and migration workflow.

The working configuration used a public-trust SAN certificate covering both:

- `mail.corp.azawslab.co.uk`
- `exch1.corp.azawslab.co.uk`

In this lab, the certificate was generated using `win-acme` and used as a practical implementation artifact rather than a long-term production certificate lifecycle model.

The certificate was bound for IIS.

### 5.4 EWS and MRS settings matter directly for migration readiness

The following actions were completed during troubleshooting and form part of the recorded build knowledge:

- EWS external URL set to:
  - `https://mail.corp.azawslab.co.uk/EWS/Exchange.asmx`
- MRS Proxy enabled on:
  - `EWS (Default Web Site)`
- Extended Protection adjusted as follows:
  - `Default Web Site > EWS = Off`
  - `Exchange Back End > EWS = Required`
- `iisreset` completed after changes

These changes were important in getting the hybrid path and migration path into a working state.

### 5.5 HCW does not always complete the whole operational path

Another key lesson was that HCW may complete enough hybrid configuration to make the environment operational, while still requiring manual follow-up steps.

In this project:

- HCW configured hybrid services
- HCW did not create the migration endpoint automatically
- manual Exchange Online PowerShell work was required
- `Test-MigrationServerAvailability` became the decisive validation point

This is a realistic engineering outcome and worth documenting as such.

### 5.6 Manual recovery can still produce a fully valid migration result

After certificate correction and manual migration endpoint creation, the remote move path validated successfully.

A pilot batch was then created and both pilot users completed migration successfully.

This demonstrated that a hybrid deployment can be recovered cleanly even when the wizard does not finish every operational step automatically.

---

## 6. Migration and Validation Lessons

### 6.1 Migration state progression matters

The migration states visible during testing moved through synchronization and later completion.

This mattered because it showed the project had moved beyond endpoint creation into actual mailbox move execution.

### 6.2 Validation should reflect what was actually tested

Post-migration validation in this phase was performed using Outlook on the web.

That should be documented exactly as validated evidence, rather than overstating testing that was not yet performed.

This project phase therefore proves:

- successful remote move migration
- successful mailbox access in Outlook on the web
- successful pilot mailbox completion state

It does not yet claim broader desktop Outlook validation or full production-scale coexistence testing.

### 6.3 Real-world mail flow understanding strengthens the project

A useful documentation improvement was to explain that migrated mailbox location and public SMTP ingress are not always the same thing.

Real-world delivery may involve:

- direct Microsoft 365 / Exchange Online Protection ingress
- Mimecast or Proofpoint in front of Microsoft 365
- hybrid coexistence routing back to on-premises for non-migrated users

This was not fully implemented in the lab, but documenting these patterns strengthens the realism of the migration narrative.

---

## 7. Documentation and Tracking Lessons

### 7.1 The tracker can fall behind the real build

A practical lesson from this phase is that implementation can move faster than documentation and tracker hygiene.

That happened here: the Excel tracker was no longer fully aligned with the real build state, while GitHub had some updates but was still incomplete in places.

This is normal, but it creates confusion unless one source is deliberately refreshed and made authoritative.

### 7.2 GitHub should reflect actual implementation state, not just original plan

Several docs initially still read as if licensing, pilot sign-in, or hybrid setup were future tasks, even after those steps had already been completed.

Later, the same issue appeared again around migration state, because the project had moved from “blocked at HCW8078” to “successful manual recovery and completed pilot migration.”

This demonstrated the need to update GitHub pages based on the real execution point, especially:

- `README.md`
- `docs/05-hybrid-identity.md`
- `docs/06-m365-modern-workplace.md`
- `docs/13-release1-build-checklist.md`

### 7.3 The build checklist should become the authoritative release state page

A dedicated checklist page is more useful than scattered progress notes.

It provides:
- completed work
- blocked items
- pending items
- correct next actions

This makes it the best page to keep synchronized with actual implementation.

---

## 8. Operational Lessons

### 8.1 Pilot-first execution reduces confusion and risk

Keeping the pilot scope limited to:

- `u.hashibur`
- `u.finance01`
- `u.hr01`

made identity validation, licensing, and hybrid testing much easier to understand and troubleshoot.

### 8.2 Evidence capture should happen alongside configuration, not afterward

A recurring lesson is that screenshots, PowerShell output, portal validation, HCW evidence, and migration evidence should be captured during implementation rather than reconstructed later.

This is especially important for:
- Entra Connect settings
- pilot licensing
- sign-in validation
- HCW progress
- HCW warning state
- migration endpoint recovery
- migration user completion state
- Outlook on the web post-migration validation

### 8.3 Realistic sequencing is part of the value of the project

The value of the project is not only in the final controls implemented, but also in the sequence used to get there.

A well-sequenced project is easier to explain in interviews because it mirrors how real hybrid platforms are built:

1. establish on-premises identity
2. prepare messaging source
3. onboard cloud tenant
4. validate sync and sign-in
5. configure hybrid path
6. validate migration readiness
7. migrate pilot users
8. extend into endpoint, security, and compliance controls

---

## 9. Current Open Lessons

The main lesson still in progress is no longer how to fix the migration endpoint.

That phase has now been completed.

The next lessons will come from the remaining Release 1 work:

- Teams and SharePoint baseline
- Intune and endpoint management
- MFA and Conditional Access
- Defender and endpoint hardening
- Purview / information protection
- monitoring and alerting
- control mapping refresh based on implemented evidence

---

## 10. Summary

The project has already produced several strong practical lessons:

- phased architecture is stronger than disconnected labs
- security and monitoring should be embedded from the start
- stable on-premises identity simplifies hybrid work
- Exchange product naming and platform decisions must stay consistent
- namespace separation can protect realism and reduce migration risk
- cloud sign-in validation is not the same as mailbox readiness
- HCW partial success must be documented precisely
- certificate trust and SAN coverage can be the decisive migration blocker
- manual Exchange Online PowerShell recovery can be a valid part of successful hybrid delivery
- trackers and GitHub must be refreshed against actual implementation state
- evidence capture should happen during the build, not after it

The next phase of learning will come from building the broader Release 1 modern workplace, endpoint, security, monitoring, and compliance controls on top of the now-working hybrid and pilot migration foundation.
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

At least one pilot user successfully signed in to Microsoft 365 web apps, while Outlook on the web returned mailbox-not-found.

That was correctly interpreted as an expected pre-migration state rather than an authentication or licensing failure.

---

## 5. HCW and Hybrid Troubleshooting Lessons

### 5.1 HCW can partially succeed while still leaving migration blocked

One of the most important implementation lessons was that Hybrid Configuration Wizard can configure significant portions of the hybrid relationship and still end in a partial-success state.

In this case, HCW progressed through:

- Exchange detection
- credentials
- hybrid selection
- Minimal mode
- Modern Hybrid / Hybrid Agent path
- Hybrid Agent installation and validation
- hybrid configuration

but ended with:

`HCW8078 - Migration Endpoint could not be created`

This means hybrid progress should be reported precisely, not simplistically as either “failed” or “complete.”

### 5.2 Hybrid Agent validation success does not automatically mean migration endpoint success

During troubleshooting, Hybrid Agent validation succeeded after the relevant checks and corrections.

That was useful because it proved the environment had moved past one layer of connectivity and configuration validation.

However, the migration endpoint still failed to be created, showing that hybrid validation and migration readiness are related but not identical.

### 5.3 EWS and MRS settings matter directly for migration readiness

The following actions were already completed during troubleshooting and form part of the recorded build knowledge:

- EWS external URL set to:
  - `https://mail.corp.azawslab.co.uk/EWS/Exchange.asmx`
- MRS Proxy enabled on:
  - `EWS (Default Web Site)`
- Extended Protection adjusted as follows:
  - `Default Web Site > EWS = Off`
  - `Exchange Back End > EWS = Required`
- `iisreset` completed after changes

These changes were important in getting Hybrid Agent validation to succeed.

### 5.4 Technical blockers should become documented implementation checkpoints

The current blocker:

`HCW8078 - Migration Endpoint could not be created`

should not be treated as a vague failure.

It should be recorded as a precise implementation checkpoint:

- hybrid services configured
- migration endpoint not yet created
- next work resumes at migration endpoint validation and remote-move readiness

This makes the repo, tracker, and handoff much more useful.

---

## 6. Documentation and Tracking Lessons

### 6.1 The tracker can fall behind the real build

A practical lesson from this phase is that implementation can move faster than documentation and tracker hygiene.

That happened here: the Excel tracker was no longer fully aligned with the real build state, while GitHub had some updates but was still incomplete in places.

This is normal, but it creates confusion unless one source is deliberately refreshed and made authoritative.

### 6.2 GitHub should reflect actual implementation state, not just original plan

Several docs initially still read as if licensing, pilot sign-in, or hybrid setup were future tasks, even after those steps had already been completed.

This demonstrated the need to update GitHub pages based on the real execution point, especially:

- `README.md`
- `docs/05-hybrid-identity.md`
- `docs/06-m365-modern-workplace.md`
- `docs/13-release1-build-checklist.md`

### 6.3 The build checklist should become the authoritative release state page

A dedicated checklist page is more useful than scattered progress notes.

It provides:
- completed work
- blocked items
- pending items
- correct next actions

This makes it the best page to keep synchronized with actual implementation.

---

## 7. Operational Lessons

### 7.1 Pilot-first execution reduces confusion and risk

Keeping the pilot scope limited to:

- `u.hashibur`
- `u.finance01`
- `u.hr01`

made identity validation, licensing, and hybrid testing much easier to understand and troubleshoot.

### 7.2 Evidence capture should happen alongside configuration, not afterward

A recurring lesson is that screenshots, PowerShell output, portal validation, and HCW evidence should be captured during implementation rather than reconstructed later.

This is especially important for:
- Entra Connect settings
- pilot licensing
- sign-in validation
- HCW progress
- HCW partial-success state
- migration endpoint troubleshooting

### 7.3 Realistic sequencing is part of the value of the project

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

## 8. Current Open Lesson

The main unresolved lesson from the current phase is still in progress:

How to move from HCW partial success to full migration endpoint readiness in a Modern Hybrid pilot while preserving the chosen namespace and migration design.

That is the next technical continuation point.

---

## 9. Summary

The project has already produced several strong practical lessons:

- phased architecture is stronger than disconnected labs
- security and monitoring should be embedded from the start
- stable on-premises identity simplifies hybrid work
- Exchange product naming and platform decisions must stay consistent
- namespace separation can protect realism and reduce migration risk
- cloud sign-in validation is not the same as mailbox readiness
- HCW partial success must be documented precisely
- trackers and GitHub must be refreshed against actual implementation state
- evidence capture should happen during the build, not after it

The next lesson will likely come from resolving migration endpoint creation and completing the first pilot mailbox moves.
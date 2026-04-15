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

### 1.3 A strong project needs both implementation breadth and believable sequencing

A useful lesson from Release 1 is that breadth alone is not enough. What makes the project credible is the order in which services were introduced:

1. build the core on-premises platform
2. establish hybrid identity
3. complete Exchange hybrid and pilot migration
4. validate collaboration services
5. extend into endpoint administration
6. begin mixed-platform endpoint coverage with Linux and Ansible

This sequence is easier to explain because it reflects how enterprise environments normally expand.

---

## 2. Infrastructure Design Lessons

### 2.1 Hyper-V was the right practical lab choice

Hyper-V was selected as the primary platform for the lab because it fit the available hardware, Windows administration focus, and enterprise realism for the intended scope.

The internal switch design and host NAT approach allowed connectivity without overcomplicating the early network design.

### 2.2 Start with a stable on-premises identity core before layering cloud services

Building the domain, DNS, replication, OU structure, users, and baseline groups first provided a clean identity source for everything that followed.

This made later Entra Connect, Exchange, Intune, and collaboration work much easier to reason about.

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

## 6. Microsoft 365 Collaboration Lessons

### 6.1 Teams baseline should be documented as practical validation, not full governance completion

A useful lesson from the collaboration phase is that there is a big difference between:

- proving Teams works
- and proving Teams is fully governed

The evidence captured in this project supports a strong **pilot collaboration baseline**, including:

- Teams admin-side user visibility
- browser access for pilot users
- direct chat
- channel posts and replies
- file sharing in a team/channel context
- meeting scheduling / calendar validation

That is enough to mark Teams baseline as implemented at pilot scope.

It is not yet enough to claim advanced governance such as:

- full external access design
- guest governance
- advanced meeting policy engineering
- Teams Phone / voice

### 6.2 SharePoint should be treated as both a standalone service and a collaboration dependency

A strong documentation improvement in Release 1 was to show that Teams file collaboration is closely connected to SharePoint Online.

The SharePoint evidence proved:

- site existence
- site membership visibility
- document library access
- file upload
- file-open validation

This helped strengthen the explanation of collaboration flow in the environment, rather than treating Teams and SharePoint as unrelated boxes.

### 6.3 Collaboration proof is stronger when it includes both admin-side and user-side validation

Another lesson is that admin-center screenshots alone are not enough.

The project is stronger because it includes:
- admin-center evidence
- pilot user browser evidence
- actual collaboration outcomes such as chat, reply, upload, and open validation

That makes the baseline much more defensible in interviews.

---

## 7. Endpoint and Intune Lessons

### 7.1 Intune baseline should be described separately from device-policy depth

A practical lesson from the endpoint phase is that tenant-side Intune activation is not the same thing as full endpoint policy maturity.

What has been implemented so far is a valid Intune baseline:

- MDM scope enabled
- EMS E5 licensing path activated
- Intune admin center validated
- devices enrolled and visible

That should be documented clearly without overstating configuration-profile or compliance-policy depth that does not yet exist.

### 7.2 Corporate and personal Windows scenarios add real value when both are shown side by side

The project became much stronger once it demonstrated both:

- a corporate-managed Windows 11 device
- a personal/BYOD Windows 11 device

This produced an important documentation lesson:

ownership matters.

Showing the difference between **Corporate** and **Personal** ownership inside Intune is more useful than showing only one enrolled Windows device.

It helps the project look more like a real workplace-management scenario rather than a single-device demo.

### 7.3 Endpoint evidence should include both tenant view and device-local confirmation

The strongest endpoint evidence came from combining:

- Intune admin-center screenshots
- Entra device visibility
- local operating system confirmation such as:
  - Access work or school
  - management server information
  - sync state

That combination is much stronger than relying on only one side.

### 7.4 Linux support should be documented carefully because the management experience differs from Windows

Another important lesson is that Linux management through Intune does not mirror Windows behavior exactly.

The Linux evidence in this project proved:

- Intune Agent presence
- enrollment path
- Linux endpoint visibility in Entra ID
- Linux endpoint visibility in Intune
- device-side compliant status view
- Intune Linux view with evaluation state that requires careful wording

This creates a documentation lesson:

**Linux should be described precisely, not lazily copied from Windows wording.**

The Linux scenario is valuable because it shows platform awareness, but it also requires more careful explanation around compliance interpretation and management depth.

### 7.5 Mixed-platform endpoint coverage makes the project more realistic

The project is stronger because Release 1 is no longer Windows-only.

The addition of:
- Windows corporate
- Windows BYOD
- Ubuntu Linux

makes the endpoint section more believable for enterprise work, because real organizations rarely manage a single endpoint type only.

---

## 8. Linux and Ansible Lessons

### 8.1 Linux visibility and Linux configuration should not be treated as the same thing

A useful lesson from the Ubuntu work is that:

- Intune gives management visibility and enrollment context
- Ansible gives practical baseline configuration control

These are complementary, not interchangeable.

That distinction is worth documenting because it reflects a more real-world mixed-tooling approach to Linux management.

### 8.2 Ansible adds operational depth beyond screenshot-only endpoint management

The project became more credible once the Linux side included Ansible rather than just enrollment screenshots.

The evidence now shows:
- Ansible version validation
- project structure creation
- inventory and playbook layout
- SSH connectivity
- `ansible ... -m ping` success
- syntax check success
- baseline playbook execution with changed tasks

That is much stronger than merely saying “Linux is in the environment.”

### 8.3 Simple Linux baseline tasks are still valuable when they are well-sequenced and evidenced

The Ansible role applied practical baseline tasks such as:

- apt cache update
- baseline package installation
- timezone configuration
- marker file creation
- operations directory creation
- MOTD banner creation

The lesson here is that baseline automation does not need to be huge to be useful.

A small, clean, repeatable baseline with evidence is better than a large but poorly explained playbook.

### 8.4 SSH and naming hygiene matter for Linux automation credibility

Another good lesson from the Ansible phase is that details matter:

- SSH connectivity must be shown working
- inventory targeting must be clear
- hostnames and target naming should be meaningful

The captured evidence showing SSH success and hostname changes improved the operational credibility of the Linux automation path.

### 8.5 Linux management claims should stay proportional to the evidence

The project can now credibly claim:
- Ubuntu endpoint presence
- Intune visibility
- Ansible baseline automation

It should not yet claim:
- full Linux compliance engineering
- enterprise Linux hardening maturity
- production-scale configuration management

Keeping claims proportional to evidence is one of the strongest trust-building lessons in the repo.

---

## 9. Documentation and Tracking Lessons

### 9.1 The tracker can fall behind the real build

A practical lesson from this phase is that implementation can move faster than documentation and tracker hygiene.

That happened here: the Excel tracker was no longer fully aligned with the real build state, while GitHub had some updates but was still incomplete in places.

This is normal, but it creates confusion unless one source is deliberately refreshed and made authoritative.

### 9.2 GitHub should reflect actual implementation state, not just original plan

Several docs initially still read as if licensing, pilot sign-in, or hybrid setup were future tasks, even after those steps had already been completed.

Later, the same issue appeared again around migration state, collaboration baseline, and endpoint status, because the project kept moving faster than the narrative pages.

This demonstrated the need to update GitHub pages based on the real execution point, especially:

- `README.md`
- `docs/06-m365-modern-workplace.md`
- `docs/07-endpoint-security-intune.md`
- `docs/13-release1-build-checklist.md`

### 9.3 The build checklist should become the authoritative release state page

A dedicated checklist page is more useful than scattered progress notes.

It provides:
- completed work
- blocked items
- pending items
- correct next actions

This makes it the best page to keep synchronized with actual implementation.

### 9.4 Screenshot naming and folder discipline matter more as scope expands

Once the project began to include Exchange, Teams, SharePoint, Intune, Linux, and Ansible, another lesson became obvious:

**evidence must be organized deliberately.**

Using well-named screenshot folders and predictable file names makes later documentation much easier and reduces the risk of mixing up proof between different workstreams.

---

## 10. Operational Lessons

### 10.1 Pilot-first execution reduces confusion and risk

Keeping the pilot scope limited to:

- `u.hashibur`
- `u.finance01`
- `u.hr01`

made identity validation, licensing, messaging, collaboration, and endpoint testing much easier to understand and troubleshoot.

### 10.2 Evidence capture should happen alongside configuration, not afterward

A recurring lesson is that screenshots, PowerShell output, portal validation, HCW evidence, migration evidence, endpoint evidence, and automation output should be captured during implementation rather than reconstructed later.

This is especially important for:
- Entra Connect settings
- pilot licensing
- sign-in validation
- HCW progress
- HCW warning state
- migration endpoint recovery
- migration user completion state
- Outlook on the web post-migration validation
- Teams / SharePoint collaboration proof
- Intune enrollment state
- Linux and Ansible automation output

### 10.3 Realistic sequencing is part of the value of the project

The value of the project is not only in the final controls implemented, but also in the sequence used to get there.

A well-sequenced project is easier to explain in interviews because it mirrors how real hybrid platforms are built:

1. establish on-premises identity
2. prepare messaging source
3. onboard cloud tenant
4. validate sync and sign-in
5. configure hybrid path
6. validate migration readiness
7. migrate pilot users
8. validate collaboration services
9. onboard endpoints
10. extend into Linux visibility and baseline automation
11. deepen security, monitoring, and compliance controls

---

## 11. Current Open Lessons

The main lesson still in progress is no longer how to fix the migration endpoint or how to prove basic Microsoft 365 readiness.

Those phases have now been completed.

The next lessons will come from the remaining Release 1 work:

- Windows configuration profile baseline
- compliance policy depth
- MFA and Conditional Access
- Defender and endpoint hardening
- Purview / information protection
- monitoring and alerting
- deeper Linux management / automation maturity
- control mapping refresh based on implemented evidence

---

## 12. Summary

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
- Teams and SharePoint baseline claims should stay proportional to the evidence
- Intune baseline should be separated from full endpoint-policy maturity
- mixed ownership Windows scenarios add real-world credibility
- Linux visibility and Linux automation are related but distinct
- Ansible makes the Linux management story much stronger
- trackers and GitHub must be refreshed against actual implementation state
- evidence capture should happen during the build, not after it

The next phase of learning will come from building deeper policy, security, monitoring, compliance, and Linux-management maturity on top of the now-working hybrid, collaboration, endpoint, and automation foundation.
# Information Protection and Purview

**Navigation:** [README](../README.md) | [Release 1 Build Checklist](16-release1-build-checklist.md) | [Release 1 Final Summary](17-release1-final-summary.md)

**Related docs:** [Modern Workplace](06-m365-modern-workplace.md) | [Endpoint Security and Intune Overview](07-endpoint-security-intune.md) | [Security and Compliance Mapping](12-security-compliance-mapping.md) | [Monitoring and Alerting](11-monitoring-alerting.md)

---

## Purpose

This document records the **information protection baseline** implemented in Release 1 for the `azawslab Enterprise Hybrid Security Platform`.

The purpose of this workstream is to show that Release 1 does not stop at identity, messaging, and endpoint control. It also begins to address:

- content classification
- sensitivity labeling
- publication of labels to pilot users
- data loss prevention (DLP)
- retention-policy baseline
- user-facing policy behavior in Microsoft 365 content workflows

This document should be read as the Release 1 **Purview baseline** page, not as a claim of full enterprise-wide information protection maturity.

---

## Scope of This Document

This document covers:

- sensitivity label structure created in Release 1
- label publication to pilot scope
- user validation of applied labels in Microsoft Word
- DLP pilot policy creation and validation
- retention-policy baseline creation and visibility
- the role of Purview in the wider Release 1 control story

This document does **not** yet claim completion of:

- document fingerprinting
- auto-labeling at scale
- advanced records management maturity
- full insider-risk program
- advanced eDiscovery
- large-scale retention governance design
- organization-wide Purview operating maturity

Those are later maturity items beyond the current Release 1 baseline.

---

## Why Purview Matters in Release 1

Release 1 already demonstrates:

- hybrid identity
- Exchange migration
- collaboration services
- endpoint management
- identity protection
- compliance and security baseline controls

Purview matters because it extends the project from **device and access control** into **content protection, data handling, and information lifecycle awareness**.

That makes the overall platform much stronger.

Without Purview, the project would mainly prove:

- who can sign in
- what device they are on
- what mailbox or workload they can access

With Purview included, the project begins to show:

- how content can be classified
- how sensitive data can be governed
- how policy can appear inside productivity workflows
- how baseline retention controls can begin to shape information lifecycle thinking

---

## Release 1 Purview Baseline

The Release 1 Purview baseline now includes three core layers:

### 1. Sensitivity labels
Used to classify information and apply visible labeling in documents.

### 2. Data Loss Prevention (DLP)
Used to detect sensitive financial content patterns and present user-facing policy behavior.

### 3. Retention baseline
Used to show initial information-lifecycle governance awareness through Purview policy configuration.

Together, these create the first information-protection layer in the platform.

---

## Sensitivity Label Structure

Release 1 implemented a simple but useful label structure.

### Labels created

The evidence shows a baseline label model including:

- Public
- Internal
- Confidential

This is an appropriate Release 1 starting point because it is:

- easy to understand
- easy to demonstrate
- realistic enough for a mid-sized enterprise pilot narrative
- strong enough to connect to later governance, DLP, and retention work

### Why this label model works

This label set provides a practical starting classification ladder:

- **Public** for information with minimal handling restrictions
- **Internal** for business-use content not intended for public distribution
- **Confidential** for higher-sensitivity internal material

This is not a highly granular enterprise taxonomy yet, but it is the right scale for a Release 1 pilot baseline.

---

## Label Publishing Policy

Creating labels is not enough on its own. They also need to be published to the right users.

### Publishing baseline

Release 1 included a label publishing policy targeted to pilot scope.

The evidence shows publication targeted to a pilot group associated with the current identity-protection / modern workplace pilot path.

This is important because it demonstrates that labels were not created only in an admin portal. They were actually made available to users.

### Why pilot publishing matters

This makes the information-protection story more credible because it proves:

- labels were configured
- labels were published
- users could see and apply them in real applications

That is a much stronger result than “label objects exist.”

---

## User Validation of Sensitivity Labels

Release 1 includes practical user-side validation of label application in Microsoft Word.

### What was validated

The evidence shows examples of:

- an **Internal** label applied to a document
- a **Confidential** label applied to a document

### Why this matters

This is one of the strongest aspects of the Purview baseline, because it connects admin configuration to user experience.

It proves that the label model was not just designed. It was actually visible and usable in a productivity application.

### Correct interpretation

The correct Release 1 claim is:

- the sensitivity-label baseline was created and published
- users were able to apply labels in supported Office applications
- pilot validation of visible classification behavior was completed

That is a strong baseline claim and does not overstate the maturity of the labeling program.

---

## Modern Label Scheme Direction

The evidence also shows the modern label-scheme / migration context in the Purview administration experience.

### Why this is useful

This matters because it shows awareness that Purview labeling is not just about creating a label and stopping there. It also sits within a broader Microsoft information-protection model that evolves over time.

For the purposes of Release 1, the main value is **platform awareness**, not a claim of full migration-program complexity.

---

## Data Loss Prevention (DLP) Pilot

Release 1 also includes a pilot DLP implementation.

### DLP policy theme

The evidence shows a DLP policy built around **U.K. Financial Data** detection.

This is a good Release 1 choice because it creates a realistic and defensible policy narrative for:

- financial data handling
- regulated information detection
- user-facing protection prompts

### Why DLP matters here

DLP adds a different kind of control from sensitivity labels.

#### Sensitivity labels
Primarily answer:
- how should this content be classified?

#### DLP
Primarily answers:
- does this content contain sensitive patterns that should trigger policy behavior?

Together, these layers make the Purview baseline more meaningful.

---

## DLP Policy Creation and Review

The evidence shows the DLP policy path from template selection to review/finalization.

### What this proves

This proves that the DLP work was not conceptual only.

It reached the level of:

- policy selection
- review
- creation
- visible presence in the DLP policy list

### Why this matters

This is important because a lot of lab projects stop at screenshots of a wizard. Your evidence is stronger because it also includes later validation behavior.

---

## DLP User-Facing Validation

One of the strongest parts of the Release 1 DLP evidence is the user-facing validation inside Microsoft Word.

### What was observed

The evidence shows:

- a DLP policy tip appearing in Word
- issue details related to financial-data detection
- policy-tip behavior tied to an external sharing / financial-data scenario

### Why this matters

This is high-value evidence because it proves:

- the policy exists
- the policy detects content
- the user sees the effect of that detection

That is exactly the sort of end-to-end validation that makes the Purview workstream credible.

### Correct Release 1 claim

The right way to describe this is:

- a U.K. Financial Data DLP pilot policy was created
- DLP policy-tip behavior was successfully validated in Microsoft 365 content workflow
- Release 1 now includes pilot evidence for content-aware protection, not only access-aware protection

---

## Retention Policy Baseline

Release 1 now also includes a **Purview retention-policy baseline**.

### Why retention matters

Retention adds another important dimension to the Purview story.

Where:

- sensitivity labels focus on classification
- DLP focuses on sensitive-data detection and policy-trigger behavior

retention focuses on:

- information lifecycle awareness
- policy-driven content handling over time
- the idea that governance is not only about access and sensitivity, but also about how long information should be preserved or governed

### What the Release 1 baseline proves

The retention-policy evidence should be described carefully.

The correct Release 1 claim is:

- a retention-policy baseline has been created and is visible in the Purview administration path
- the project now demonstrates awareness of information lifecycle governance, not only labels and DLP
- Release 1 includes retention as a baseline governance signal, not as a fully mature records-management program

### Why this strengthens the project

This makes the Purview workstream more credible because it shows that the project is beginning to cover three distinct information-protection dimensions:

- classification
- detection
- retention / lifecycle governance

That is much stronger than stopping at labels alone.

---

## Relationship Between Purview and the Wider Release 1 Design

Purview in Release 1 should not be treated as an isolated feature.

It fits into the broader security story like this:

### Identity protection
Controls who can authenticate and under what conditions.

### Endpoint management
Controls device state, compliance, and management visibility.

### Purview
Controls how content is classified, how sensitive information triggers policy behavior, and how lifecycle governance begins to be expressed through retention.

This is an important design point because it shows the project is moving toward **defense in depth** across:

- identity
- device
- content

That makes the overall project much more enterprise-relevant.

---

## What Release 1 Purview Does Not Yet Claim

To keep the project credible, this document should also be explicit about what has **not** yet been completed.

Release 1 does **not** yet claim:

- full enterprise label taxonomy maturity
- broad organization-wide label rollout
- auto-labeling at scale
- document fingerprinting
- advanced DLP exception models
- Insider Risk Management deployment
- advanced records management maturity
- large-scale retention governance operating model

This is intentional. Release 1 demonstrates the baseline, not the final enterprise operating model.

---

## Current Release 1 Position for Purview

### Completed

- baseline sensitivity labels created
- label publishing policy created
- labels validated in Office application workflow
- DLP pilot policy created
- DLP policy list presence confirmed
- DLP policy-tip behavior validated in Word
- retention-policy baseline created and visible in the Purview administration path

### In progress

- final documentation alignment
- integration of Purview into the overall Release 1 final-summary narrative
- mapping of Purview controls into the broader compliance/control framework

### Not yet complete

- document fingerprinting
- broader label taxonomy expansion
- advanced DLP governance
- larger-scale retention governance
- broader Purview operational maturity

---

## Evidence Areas

The strongest evidence for this document comes from:

- `screenshots/release1/release1-purview/purview-sensitivity-labels/`
- `screenshots/release1/release1-purview/purview-dlp/`

And now also from the retention-related Purview screenshots you added to the project.

These support:

- label overview
- publishing policy
- Word label application
- DLP policy creation
- DLP policy-list state
- DLP policy-tip validation
- retention-policy baseline visibility

---

## Diagram Placement Recommendation

This document does not need a dedicated large diagram immediately.

Best later options:

- keep the main architecture diagrams in README and overview docs
- use screenshots here for proof
- optionally add a small content-protection relationship diagram later if needed

For now, screenshots are more valuable than a new diagram on this page.

---

## Suggested Embedded Screenshot Strategy

This file should later embed only a few high-value screenshots.

Recommended maximum:

- one label overview screenshot
- one Word screenshot showing label application
- one publishing-policy screenshot
- one DLP policy-list screenshot
- one DLP policy-tip screenshot
- one retention-policy screenshot

That is enough to show:

- configuration
- publication
- user validation
- policy enforcement signal
- lifecycle-governance baseline

---

## Flagship Purview Evidence

### Sensitivity label baseline

![Purview sensitivity labels overview](../screenshots/release1/purview/purview-sensitivity-labels/01-purview-sensitivity-labels-overview.png)

*Figure: Purview sensitivity-label baseline showing the Release 1 classification model used to support pilot information protection.*

### User-side label application

![Confidential label applied in Word](../screenshots/release1/purview/purview-sensitivity-labels/04-word-confidential-label-applied-to-hr-identity-test-form.png)

*Figure: Confidential sensitivity label applied in Microsoft Word, proving that labels were not only configured in the admin portal but also visible and usable in the end-user workflow.*

### DLP policy-tip validation

![Purview DLP policy tip in Word](../screenshots/release1/purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png)

*Figure: DLP policy tip triggered in Microsoft Word for the U.K. Financial Data pilot policy, showing user-facing content-protection enforcement.*

### Retention-policy baseline

![Purview retention baseline](../screenshots/release1/purview/purview-retention/Screenshot%202026-04-18%20120911.png)

*Figure: Retention-policy baseline visible in Purview administration, showing that Release 1 includes lifecycle-governance awareness in addition to labels and DLP.*

---
## Why This Matters Professionally

This Purview workstream strengthens the portfolio because it shows that the project is not limited to identity, Exchange, and endpoint administration.

It now also demonstrates practical understanding of:

- classification
- label publishing
- content-aware protection
- user-facing data protection signals in Microsoft 365
- baseline retention and information lifecycle governance

That is a meaningful step toward a more complete Microsoft security and compliance platform story.

---

## Summary

Release 1 now includes a real Purview baseline through:

- sensitivity labels
- pilot label publishing
- user-side label application validation
- DLP pilot policy creation
- DLP policy-tip validation
- retention-policy baseline visibility

This should be presented as **baseline information protection capability**, not as full Purview maturity.

That is the right balance between strength and credibility for Release 1.

# Information Protection Evidence Hub

## Purpose

This page is the guided evidence index for the information-protection portion of the implemented platform. It exists to make the Purview screenshot archive easier to review by grouping evidence into the main protection areas:

- **sensitivity labels** – foundational classification
- **DLP** – user-facing policy enforcement
- **retention baseline** – governance context
- **document fingerprinting** – advanced detection for structured confidential forms (advanced validation)

This page should be read as an evidence hub, not as a narrative implementation document.

---

## What This Evidence Set Proves

The information-protection evidence demonstrates that the platform moved beyond infrastructure and endpoint controls into user-facing content protection. It shows:

- sensitivity labels configured and available for document classification
- visible label application in the user workflow
- DLP policy‑tip behavior triggered against realistic test content
- retention represented as part of the governance baseline
- a scoped and supportable Purview baseline rather than an inflated claim to full enterprise information-governance maturity

Additionally, advanced validation has extended the story to include:

- **document fingerprinting** – Purview can recognise a specific structured document type (a synthetic HR intake form) and use that classification in DLP logic

This is one of the strongest proof areas in the repository because it demonstrates protection at the point of user interaction.

---

## How to Use This Hub

Use this page in one of three ways:

- **Start with flagship proof** if you want the shortest route to the strongest screenshots
- **Browse by protection area** if you want evidence grouped by labels, DLP, retention, or fingerprinting
- **Follow the related docs** if you want the implementation story behind the evidence

This hub is designed to reduce click fatigue while still giving access to the wider screenshot archive underneath each protection folder.

---

## Start Here: Flagship Proof

| Proof Area | What it demonstrates | Best evidence |
| :--- | :--- | :--- |
| **Sensitivity labels overview** | Classification controls configured and available in Purview | [Purview sensitivity labels overview](purview/purview-sensitivity-labels/01-purview-sensitivity-labels-overview.png) |
| **Label application in Word** | Classification is visible in the user workflow | [Confidential label applied in Word](purview/purview-sensitivity-labels/04-word-confidential-label-applied-to-hr-identity-test-form.png) |
| **DLP policy‑tip behavior** | User-facing information-protection enforcement against test financial data | [DLP policy‑tip triggered in Word](purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png) |
| **Document fingerprinting SIT creation** | Custom SIT built from the fingerprint of a structured HR form | [Fingerprint SIT review](purview/purview-fingerprint/03-fingerprint-sit-review-r1-document-fingerprint-hr-form-belfast.png) |
| **Fingerprint match & DLP policy tip** | Policy tip triggered by detection of the HR form in OneDrive | [OneDrive policy-tip for fingerprint match](purview/purview-fingerprint/07-onedrive-policy-tip-validation-document-fingerprint-pilot-win01.png) |
| **Retention baseline** | Retention represented as part of the governance baseline | [Retention evidence folder](purview/purview-retention/) |

---

## Evidence by Protection Area

### 1. Sensitivity Labels

This area contains the clearest classification-control evidence in the protection set. It supports:
- labels configured in Purview
- visible classification controls
- user-facing label application inside Word
- practical proof that information protection begins at the content layer

**Start here:** [Sensitivity Labels Folder](purview/purview-sensitivity-labels/)

**Best evidence:**
- [Purview sensitivity labels overview](purview/purview-sensitivity-labels/01-purview-sensitivity-labels-overview.png)
- [Confidential label applied in Word](purview/purview-sensitivity-labels/04-word-confidential-label-applied-to-hr-identity-test-form.png)

**Related docs:** [Purview](../../../docs/release1/07-purview.md)

### 2. Data Loss Prevention (DLP)

This area contains the strongest user-facing protection proof in the whole Purview evidence set. It supports:
- DLP policy configured against relevant content patterns
- user-visible policy-tip behavior
- proof that the control was active at the point of interaction inside Word

**Start here:** [DLP Folder](purview/purview-dlp/)

**Best evidence:** [DLP policy‑tip triggered in Word](purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png)

**Related docs:** [Purview](../../../docs/release1/07-purview.md)

### 3. Document Fingerprinting (Advanced Validation)

This area demonstrates that Purview can move beyond generic pattern matching to recognise a specific, structured confidential document. It supports:
- creation of a synthetic HR intake form as the source template
- generation of a custom fingerprint‑based sensitive information type (SIT)
- testing the SIT against variants of the source document
- linkage of the fingerprint SIT to a DLP policy
- user‑visible policy tip validation in OneDrive

**Start here:** [Document Fingerprinting Folder](purview/purview-fingerprint/)

**Best evidence:**
- [Fingerprint SIT review](purview/purview-fingerprint/03-fingerprint-sit-review-r1-document-fingerprint-hr-form-belfast.png)
- [OneDrive policy-tip for fingerprint match](purview/purview-fingerprint/07-onedrive-policy-tip-validation-document-fingerprint-pilot-win01.png)

**Related docs:** [Purview (Document Fingerprinting section)](../../../docs/release1/07-purview.md)

### 4. Retention

This area shows that retention was represented as part of the governance baseline, even though the strongest visible proof in this phase remains labels and DLP. It supports:
- retention-related configuration
- broader governance context for the implemented Purview baseline

**Start here:** [Retention Folder](purview/purview-retention/)

**Best evidence:** [Retention evidence folder](purview/purview-retention/01-purview-retention-policy-review-and-finish-baseline-pilot.png)

**Related docs:** [Purview](../../../docs/release1/07-purview.md)

---

## Recommended Review Path

If you want the shortest high-value path through the information‑protection evidence (including advanced validation), use this order:

1. [Purview sensitivity labels overview](purview/purview-sensitivity-labels/01-purview-sensitivity-labels-overview.png)
2. [Confidential label applied in Word](purview/purview-sensitivity-labels/04-word-confidential-label-applied-to-hr-identity-test-form.png)
3. [DLP policy‑tip triggered in Word](purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png)
4. [Fingerprint SIT review](purview/purview-fingerprint/03-fingerprint-sit-review-r1-document-fingerprint-hr-form-belfast.png)
5. [OneDrive policy‑tip for fingerprint match](purview/purview-fingerprint/07-onedrive-policy-tip-validation-document-fingerprint-pilot-win01.png)
6. [Retention evidence folder](purview/purview-retention/)

This sequence gives the fastest view of:
- baseline classification
- user‑facing label use
- DLP enforcement
- document fingerprinting detection
- governance baseline coverage

---

## Relationship to the Documentation

Use the **documentation** when you want:
- scope boundaries
- protection rationale
- business value
- implementation story
- careful explanation of what is and is not claimed

Use this **evidence hub** when you want:
- visible label configuration
- label application inside the user workflow
- DLP proof at the point of interaction
- document fingerprinting SIT and DLP evidence
- quick verification of Purview baseline claims

**Best related reading path:**
- [Release 1 README](../../../docs/release1/README.md)
- [Release 1 Summary](../../../docs/release1/00-summary.md)
- [Purview (including Document Fingerprinting)](../../../docs/release1/07-purview.md)

---

## Scope Boundaries

This evidence set is strong, but it should be read carefully. It does **not** imply that every adjacent Purview capability is already complete.

Examples of intentionally limited or deferred areas include:
- large‑scale auto‑labeling for thousands of documents
- broader automation or advanced policy orchestration beyond the documented fingerprinting workflow
- full enterprise information‑governance maturity beyond the baseline demonstrated here

> **Note:** Document fingerprinting, which was previously described as a future enhancement, is now **fully implemented and evidenced** as advanced validation within Release 1. See the dedicated subsection above.

Those boundaries are documented in:
- [Build Checklist](../../../docs/release1/11-build-checklist.md)
- [Extensions and Future Enhancements](../../../docs/release1/12-extensions-and-future-enhancements.md)

---

## Related Pages

- [Release 1 Evidence Dashboard](../README.md)
- [Release 1 README](../../../docs/release1/README.md)
- [Purview](../../../docs/release1/07-purview.md)
- [Skills and Evidence Index](../../../docs/foundation/05-skills-and-evidence-index.md)
- [Root README](../../../README.md)
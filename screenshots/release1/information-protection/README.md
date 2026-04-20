# Information Protection Evidence Hub

## Purpose

This page is the guided evidence index for the information-protection portion of the implemented platform.

It exists to make the Purview screenshot archive easier to review by grouping evidence into the main protection areas:
- sensitivity labels
- DLP
- retention baseline

This page should be read as an evidence hub, not as a narrative implementation document.

---

## What This Evidence Set Proves

The information-protection evidence demonstrates that the platform moved beyond infrastructure and endpoint controls into user-facing content protection.

It shows:
- sensitivity labels configured and available for document classification
- visible label application in the user workflow
- DLP policy-tip behavior triggered against realistic test content
- retention represented as part of the governance baseline
- a scoped and supportable Purview baseline rather than an inflated claim to full enterprise information-governance maturity

This is one of the strongest proof areas in the repository because it demonstrates protection at the point of user interaction.

---

## How to Use This Hub

Use this page in one of three ways:

- **Start with flagship proof** if you want the shortest route to the strongest screenshots
- **Browse by protection area** if you want evidence grouped by labels, DLP, or retention
- **Follow the related docs** if you want the implementation story behind the evidence

This hub is designed to reduce click fatigue while still giving access to the wider screenshot archive underneath each protection folder.

---

## Start Here: Flagship Proof

| Proof Area | What it demonstrates | Best evidence |
| :--- | :--- | :--- |
| **Sensitivity labels overview** | Classification controls configured and available in Purview | [Purview sensitivity labels overview](purview/purview-sensitivity-labels/01-purview-sensitivity-labels-overview.png) |
| **Label application in Word** | Classification is visible in the user workflow | [Confidential label applied in Word](purview/purview-sensitivity-labels/04-word-confidential-label-applied-to-hr-identity-test-form.png) |
| **DLP policy-tip behavior** | User-facing information-protection enforcement against test financial data | [DLP policy-tip triggered in Word](purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png) |
| **Retention baseline** | Retention represented as part of the governance baseline | [Retention evidence folder](purview/purview-retention/) |

---

## Evidence by Protection Area

### 1. Sensitivity Labels

This area contains the clearest classification-control evidence in the protection set.

It supports:
- labels configured in Purview
- visible classification controls
- user-facing label application inside Word
- practical proof that information protection begins at the content layer

Start here:
- [Sensitivity Labels Folder](purview/purview-sensitivity-labels/)

Best evidence:
- [Purview sensitivity labels overview](purview/purview-sensitivity-labels/01-purview-sensitivity-labels-overview.png)
- [Confidential label applied in Word](purview/purview-sensitivity-labels/04-word-confidential-label-applied-to-hr-identity-test-form.png)

Related docs:
- [Purview](../../../docs/release1/07-purview.md)

---

### 2. Data Loss Prevention (DLP)

This area contains the strongest user-facing protection proof in the whole Purview evidence set.

It supports:
- DLP policy configured against relevant content patterns
- user-visible policy-tip behavior
- proof that the control was active at the point of interaction inside Word

Start here:
- [DLP Folder](purview/purview-dlp/)

Best evidence:
- [DLP policy-tip triggered in Word](purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png)

Related docs:
- [Purview](../../../docs/release1/07-purview.md)

---

### 3. Retention

This area shows that retention was represented as part of the governance baseline, even though the strongest visible proof in this phase remains labels and DLP.

It supports:
- retention-related configuration
- broader governance context for the implemented Purview baseline

Start here:
- [Retention Folder](purview/purview-retention/)

Best evidence:
- [Retention evidence folder](purview/purview-retention/01-purview-retention-policy-review-and-finish-baseline-pilot.png)

Related docs:
- [Purview](../../../docs/release1/07-purview.md)

---

## Recommended Review Path

If you want the shortest high-value path through the information-protection evidence, use this order:

1. [Purview sensitivity labels overview](purview/purview-sensitivity-labels/01-purview-sensitivity-labels-overview.png)
2. [Confidential label applied in Word](purview/purview-sensitivity-labels/04-word-confidential-label-applied-to-hr-identity-test-form.png)
3. [DLP policy-tip triggered in Word](purview/purview-dlp/03-purview-dlp-policy-tip-triggered-in-word-for-uk-financial-data-test-file.png)
4. [Retention evidence folder](purview/purview-retention/)

This sequence gives the fastest view of:
- classification
- user-facing label use
- DLP enforcement behavior
- governance baseline coverage

---

## Relationship to the Documentation

Use the documentation when you want:
- scope boundaries
- protection rationale
- business value
- implementation story
- careful explanation of what is and is not claimed

Use this evidence hub when you want:
- visible label configuration
- label application inside the user workflow
- DLP proof at the point of interaction
- quick verification of Purview baseline claims

Best related reading path:
- [Release 1 README](../../../docs/release1/README.md)
- [Release 1 Summary](../../../docs/release1/00-summary.md)
- [Purview](../../../docs/release1/07-purview.md)

---

## Scope Boundaries

This evidence set is strong, but it should be read carefully.

It does **not** imply that every adjacent Purview capability is already complete.

Examples of intentionally limited or deferred areas include:
- advanced document fingerprinting
- large-scale auto-labeling
- broader automation or advanced policy orchestration
- full enterprise information-governance maturity beyond the baseline demonstrated here

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
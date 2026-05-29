# Release 2 Historical Naming and Tagging Reference

This file is a cleaned historical reference for the original Release 2 naming and tagging conventions.

The current public reviewer path is maintained through the curated Release 2 reader layer, Terraform state map, evidence folders, and live MkDocs portfolio site. This file remains only to preserve historical context for how Release 2 resources were organized.

## Current reviewer path

| Purpose | Current source |
|---|---|
| Release 2 overview | [`docs/release2/README.md`](../README.md) |
| Terraform state and pipeline map | [`docs/release2/11-terraform-state-and-pipeline-map.md`](../11-terraform-state-and-pipeline-map.md) |
| Landing zone, IaC, and governance | [`docs/release2/01-landing-zone-iac-governance.md`](../01-landing-zone-iac-governance.md) |
| Evidence root | [`docs/release2/evidence/`](../evidence/) |
| Live portfolio site | [`www.azawslab.co.uk`](https://www.azawslab.co.uk/) |

## Historical naming intent

Release 2 used a consistent naming model to make cloud resources easier to identify, audit, and troubleshoot.

| Naming dimension | Historical intent |
|---|---|
| Environment | Distinguish development, shared platform, management, and workload scope. |
| Region | Make resource placement and data-sovereignty decisions visible. |
| Platform area | Separate governance, networking, management, AKS, AVD, shared services, and AWS branch resources. |
| Workload function | Make the purpose of each resource clear from its name. |
| Evidence phase | Keep validation artifacts aligned with the implementation phase or operational milestone. |

## Historical tagging intent

Tags were used to support governance, cost review, ownership, and portfolio evidence.

| Tag category | Purpose |
|---|---|
| Environment | Identify dev, shared, management, workload, or roadmap context. |
| Owner | Identify the platform or operational owner. |
| Cost center | Support cost visibility and FinOps review. |
| Workload | Group related resources by service or capability. |
| Evidence phase | Link deployed resources and validations back to implementation evidence. |
| Managed by | Identify Terraform, automation, or manually reviewed resources. |

## Current status

The detailed naming table has been superseded by the current Terraform roots, state map, and evidence folders. This file intentionally avoids stale generated text, encoding-damaged characters, and obsolete implementation notes.

## Evidence safety

Do not publish Terraform state, binary plan files, kubeconfigs, private keys, certificates, credentials, access tokens, unredacted tenant identifiers, or raw logs that expose sensitive infrastructure details.
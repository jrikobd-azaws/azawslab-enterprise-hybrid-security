# Release 2 Historical Phase Plan Reference

This file is a cleaned historical reference for the original Release 2 phase-planning material.

The public portfolio reading path is now maintained through the curated Release 2 reader layer and the live MkDocs showroom. This file is retained only to preserve traceability for how the Release 2 implementation was originally organized.

## Current reviewer path

Use these documents for public review:

| Purpose | Current source |
|---|---|
| Release 2 overview | [`docs/release2/README.md`](../README.md) |
| Release 2 executive summary | [`docs/release2/00-summary.md`](../00-summary.md) |
| Landing zone, IaC, and governance | [`docs/release2/01-landing-zone-iac-governance.md`](../01-landing-zone-iac-governance.md) |
| Hybrid and multi-cloud networking | [`docs/release2/02-hybrid-multicloud-network-security.md`](../02-hybrid-multicloud-network-security.md) |
| Automation, SecOps, and resilience | [`docs/release2/03-automation-secops-resilience.md`](../03-automation-secops-resilience.md) |
| Private platform and secure workspace | [`docs/release2/04-private-platform-secure-workspace.md`](../04-private-platform-secure-workspace.md) |
| AI operations enclave | [`docs/release2/05-ai-operations-enclave.md`](../05-ai-operations-enclave.md) |
| Skills and evidence index | [`docs/release2/06-skills-and-evidence-index.md`](../06-skills-and-evidence-index.md) |
| Terraform state and pipeline map | [`docs/release2/11-terraform-state-and-pipeline-map.md`](../11-terraform-state-and-pipeline-map.md) |
| Evidence root | [`docs/release2/evidence/`](../evidence/) |
| Live portfolio site | [`www.azawslab.co.uk`](https://www.azawslab.co.uk/) |

## Historical phase intent

The original planning material organized Release 2 around these implementation themes:

| Theme | Intent |
|---|---|
| Foundation and OIDC | Establish Azure subscription readiness, GitHub Actions federation, and Terraform remote-state discipline. |
| Terraform platform roots | Separate infrastructure ownership into root modules and state boundaries for governance, networking, management, workloads, AKS, AVD, shared platform services, and AWS branch context. |
| Governance and policy | Apply Azure Policy, RBAC, tagging, location controls, and evidence-driven validation. |
| Hybrid and multi-cloud networking | Build hub-spoke connectivity, firewall inspection context, VPN/IPSec routing, BGP validation, and AWS branch integration. |
| Automation and operations | Move from local automation toward controlled Ansible/AWX execution and operational validation. |
| Security monitoring and resilience | Capture Defender, Sentinel, Azure Monitor, backup, and operational readiness evidence. |
| Private platform delivery | Implement private AKS, secure administration paths, AVD/FSLogix, and supporting Kubernetes manifests. |
| O6 AI operations | Define a governed AI-assisted CloudOps model with human review, tool boundaries, evidence, and the companion `local-ai-lab-infra` implementation. |

## Evidence standard

All public evidence must remain redacted and safe for portfolio review. Do not publish:

- Terraform state files
- Terraform binary plan files
- Kubeconfigs
- Private keys or certificates
- Access tokens or credentials
- Unredacted tenant identifiers
- Raw logs that expose sensitive infrastructure details

## Status

The detailed implementation narrative has been superseded by the curated Release 2 reader layer and the live portfolio site. This file remains only as a high-level historical reference to avoid exposing stale planning artifacts, generated citation markers, or encoding-damaged text.
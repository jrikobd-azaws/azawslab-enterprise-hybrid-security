---
title: Technical Review Path
---

# Technical Review Path

This path is for engineers who want to inspect architecture, implementation boundaries, and evidence.

## 10-minute audit plan

| Step | What to inspect | Why it matters |
|---|---|---|
| 1 | [Architecture Overview](../architecture.md) | Understand the staged release model before inspecting files |
| 2 | [Proof Gallery](../proof-gallery.md) | Identify the strongest evidence paths first |
| 3 | [Terraform state boundaries](../engineering/terraform-state-boundaries.md) | Review ownership and blast-radius control |
| 4 | [GitHub Actions OIDC](../engineering/github-actions-oidc.md) | Validate the secretless delivery model |
| 5 | [Hybrid multi-cloud networking](../engineering/hybrid-multicloud-networking.md) | Inspect network path and route-control thinking |
| 6 | [Private AKS and AVD](../engineering/private-aks-avd.md) | Inspect private platform and admin workspace design |
| 7 | [AI Operations Enclave](../ai-operations/index.md) | Review O6 governance and companion implementation positioning |

## Implementation inspection matrix

| Area | High-maturity signal | Source reference |
|---|---|---|
| IaC | Multiple Terraform roots and state boundaries | [State and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md){ target="_blank" } |
| CI/CD | OIDC-based workflow-controlled delivery | [GitHub workflows](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/.github/workflows){ target="_blank" } |
| Networking | Hub-spoke, firewall, VPN/IPSec, BGP, AWS branch context | [Networking story](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/02-hybrid-multicloud-network-security.md){ target="_blank" } |
| Automation | AWX control-plane evidence and Ansible support | [A2 AWX evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane){ target="_blank" } |
| Private platform | Private AKS, AVD/FSLogix, private access patterns | [O4 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4){ target="_blank" } |
| AI governance | O6 evidence and local-ai-lab-infra companion model | [O6 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6){ target="_blank" } |

## Reviewer checks

| Check | Expected signal |
|---|---|
| Does the project distinguish implemented work from roadmap? | Release 3 is clearly marked as roadmap |
| Are evidence folders explained? | Evidence READMEs and the evidence guide provide context |
| Are Terraform boundaries clear? | State map and root folders show ownership |
| Are claims supported? | Proof gallery links to evidence folders and implementation source |
| Is AI positioned safely? | O6 and companion pages frame AI as human-reviewed infrastructure assistance |

## Technical reviewer takeaway

The repository is structured for auditability: site pages explain the system, GitHub folders hold the raw implementation and evidence, and roadmap content is separated from implemented capability.

[Back to Home](../index.md)
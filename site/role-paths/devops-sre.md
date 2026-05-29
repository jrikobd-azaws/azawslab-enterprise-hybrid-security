---
title: DevOps and SRE Focus
---

# DevOps and SRE Focus

This path focuses on delivery control, repeatability, validation, observability, and operational readiness.

## Delivery and operations model

| Area | Site signal | Repository signal |
|---|---|---|
| CI/CD | GitHub Actions OIDC delivery model | `.github/workflows/` |
| IaC | Terraform roots and state boundaries | `terraform/` and state map |
| Automation | AWX and Ansible operations pattern | `docs/release2/evidence/A2-awx-control-plane/` |
| Monitoring | Azure Monitor, Sentinel, Defender context | Release 2 evidence folders |
| Backup and recovery | Backup validation and recovery evidence | Release 2 evidence folders |
| Private platform | Private AKS and AVD access patterns | O4 and O5 evidence |
| AI operations | O6 governed AI-assisted workflow | O6 evidence and companion repo |

## Operational maturity signals

| Signal | What it shows |
|---|---|
| Workflow-controlled delivery | Infrastructure changes are routed through repeatable pipelines |
| Strict build validation | The portfolio site itself is built with `mkdocs build --strict` |
| Evidence folders | Operations are documented with reviewable artifacts |
| AWX control plane | Automation can be governed beyond local shell execution |
| Terraform state boundaries | Infrastructure ownership is separated to reduce accidental blast radius |
| Human-reviewed AI assistance | Generated infrastructure output is validated and reviewed before real use |

## Reliability review path

1. [GitHub Actions OIDC](../engineering/github-actions-oidc.md)
2. [Terraform state boundaries](../engineering/terraform-state-boundaries.md)
3. [Proof Gallery](../proof-gallery.md)
4. [A2 AWX evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane){ target="_blank" }
5. [Release 2 evidence root](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence){ target="_blank" }

## DevOps/SRE takeaway

The project demonstrates operational thinking: repeatable delivery, validation, automation control, monitoring evidence, recovery context, and clear separation between implementation and roadmap.

[Back to Home](../index.md)
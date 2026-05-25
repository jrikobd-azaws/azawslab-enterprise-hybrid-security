# Project Status

## Portfolio Identity

This repository is one flagship enterprise platform portfolio, structured as three staged releases.

The project presents a staged enterprise platform journey from hybrid Microsoft operations into Azure platform engineering, multi-cloud security, automation, private platform operations, AI-assisted CloudOps, and future multi-cloud Kubernetes delivery.

## Release Status

| Release   | Theme                                                                                 | Status                                                                |
| --------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Release 1 | Hybrid Modern Workplace, Identity & Endpoint Security                                                           | Complete and evidenced                                                |
| Release 2 | Azure Platform Engineering, Security, Automation, Private Platform, and AI Operations | Implemented and evidenced; portfolio documentation reorganization in progress |
| Release 3 | Multi-Cloud Kubernetes, GitOps, and DevSecOps                                         | Roadmap                                                               |

## Canonical Decisions

- This is one flagship platform repository, not multiple disconnected projects.
- Keep `release1`, `release2`, and `release3` naming.
- Use the six portfolio capability tracks.
- Final branch namespace is `br1.azawslab.co.uk`.
- A2 AWX automation control plane is complete and evidenced.
- O4 Private AKS is complete.
- O5 AVD + FSLogix is complete.
- O6 AI Operations Enclave work is complete and evidenced.
- Release 3 direction includes AKS, EKS, Argo CD, DevSecOps controls, image scanning, policy gates, protected ingress, observability, and resilience.

## Six Portfolio Capability Tracks

| Track | Name                                                 | Release   | What it proves                                                                                     |
| ----- | ---------------------------------------------------- | --------- | -------------------------------------------------------------------------------------------------- |
| 1     | Hybrid Modern Workplace, Identity & Endpoint Security                 | Release 1 | Entra ID, Active Directory, Microsoft 365, Intune, Autopilot, Purview, endpoint security, recovery |
| 2     | Azure Landing Zone, IaC and Governance               | Release 2 | Terraform, GitHub Actions OIDC, remote state, Azure Policy, RBAC, naming, controlled delivery      |
| 3     | Secure Hybrid and Multi-Cloud Networking             | Release 2 | Azure and AWS connectivity, hub-spoke, FortiGate, VyOS, Cisco, IPSec, BGP, transit routing         |
| 4     | Automation, SecOps and Resilience                    | Release 2 | Ansible, AWX, runtime secrets, monitoring, backup, validation, operational runbooks                |
| 5     | Private Platform, Secure Workspace and AI Operations | Release 2 | Private AKS, AVD, FSLogix, O6 AI Operations Enclave, RAG/MCP/tool boundary                         |
| 6     | Multi-Cloud Kubernetes, GitOps and DevSecOps         | Release 3 | AKS, EKS, Argo CD, image scanning, policy gates, secure ingress, observability, resilience         |

## Companion Project

The `local-ai-lab-infra` companion project supports the O6 AI Operations Enclave story. It provides a working local AI CloudOps pattern using Ollama, local RAG, Chroma, LiteLLM, deterministic validation, and human-in-the-loop review.

Use it as companion evidence for the AI-assisted CloudOps direction, not as a replacement for the main Release 2 documentation.

## Delivery Rules

- GitHub Actions controlled apply is the default path.
- Local Terraform apply is exceptional and should be documented when used.
- Terraform state, plans, secrets, kubeconfigs, private keys, and raw credentials must not be committed.
- Public-facing documentation should use confident, evidence-led portfolio language.
- Future work should be presented as platform evolution or Release 3 direction.

## Documentation Migration Rules

- Use `STATUS.md` as the source-truth lock during portfolio migration.
- Do not let stale Release 2 status text override this file.
- Do not use mojibake/corrupted Markdown as final prose.
- Use corrupted files only for facts until encoding cleanup is complete.
- Missing evidence links should be marked as placeholders until final proof paths are added.
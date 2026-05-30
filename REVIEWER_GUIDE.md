# Reviewer Guide

[![Enterprise Showroom](https://img.shields.io/badge/Enterprise%20Showroom-www.azawslab.co.uk-0B5CAD?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://www.azawslab.co.uk/)
[![Repository Home](https://img.shields.io/badge/Repository-Home-374151?style=for-the-badge)](README.md)
[![Proof Gallery](https://img.shields.io/badge/Proof%20Gallery-Evidence%20Backed-166534?style=for-the-badge)](PROOF_GALLERY.md)
[![Architecture](https://img.shields.io/badge/Architecture-Platform%20Journey-7C3AED?style=for-the-badge)](ARCHITECTURE.md)

> GitHub audit map for recruiters, hiring managers, technical reviewers, security architects, and DevOps/SRE reviewers.

---

## Purpose

The live portfolio site is the best guided showroom experience. This file is the GitHub-native audit map for reviewers who want to inspect the repository directly.

Use this guide to choose the right path without browsing the full repository tree manually.

---

## Two-minute review

| Goal | Start here |
|---|---|
| Understand the project quickly | [README.md](README.md) |
| Use the polished portfolio view | [www.azawslab.co.uk](https://www.azawslab.co.uk/) |
| Confirm current status | [STATUS.md](STATUS.md) |
| See strongest proof paths | [PROOF_GALLERY.md](PROOF_GALLERY.md) |

---

## Five-minute recruiter review

| Question | Best path |
|---|---|
| What roles does this project support? | [SKILLS_MATRIX.md](SKILLS_MATRIX.md) and [ROLE_GUIDE.md](ROLE_GUIDE.md) |
| Is this a serious portfolio or a small lab? | [PORTFOLIO.md](PORTFOLIO.md) |
| Is there visible proof? | [PROOF_GALLERY.md](PROOF_GALLERY.md) |
| Is there a polished front end? | [Live portfolio showroom](https://www.azawslab.co.uk/) |

---

## Fifteen-minute hiring-manager review

| Question | Best path |
|---|---|
| What business/platform problem does this solve? | [PORTFOLIO.md](PORTFOLIO.md) |
| How is the architecture structured? | [ARCHITECTURE.md](ARCHITECTURE.md) |
| How is delivery controlled? | [docs/release2/11-terraform-state-and-pipeline-map.md](docs/release2/11-terraform-state-and-pipeline-map.md) |
| How is evidence handled safely? | [EVIDENCE_GUIDE.md](EVIDENCE_GUIDE.md) |
| What is implemented vs roadmap? | [STATUS.md](STATUS.md) |

---

## Thirty-minute technical review

| Review area | Best path |
|---|---|
| Terraform root structure | [terraform/README.md](terraform/README.md) |
| State and pipeline boundaries | [docs/release2/11-terraform-state-and-pipeline-map.md](docs/release2/11-terraform-state-and-pipeline-map.md) |
| GitHub Actions workflows | [.github/workflows/](.github/workflows/) |
| Release 2 capability stories | [docs/release2/README.md](docs/release2/README.md) |
| Release 2 evidence | [docs/release2/evidence/](docs/release2/evidence/) |
| Kubernetes support manifests | [kubernetes/README.md](kubernetes/README.md) |

---

## Evidence-first review

| Evidence area | Best path |
|---|---|
| Curated proof map | [PROOF_GALLERY.md](PROOF_GALLERY.md) |
| Evidence handling and redaction | [EVIDENCE_GUIDE.md](EVIDENCE_GUIDE.md) |
| Release 1 screenshots | [screenshots/release1/README.md](screenshots/release1/README.md) |
| Release 2 evidence folders | [docs/release2/evidence/](docs/release2/evidence/) |
| O6 AI operations evidence | [docs/release2/evidence/O6/](docs/release2/evidence/O6/) |

---

## Security architecture review

| Security concern | Best path |
|---|---|
| Architecture and trust boundaries | [ARCHITECTURE.md](ARCHITECTURE.md) |
| Evidence redaction | [EVIDENCE_GUIDE.md](EVIDENCE_GUIDE.md) |
| Identity and endpoint foundation | [docs/release1/README.md](docs/release1/README.md) |
| Hybrid and multi-cloud network security | [docs/release2/02-hybrid-multicloud-network-security.md](docs/release2/02-hybrid-multicloud-network-security.md) |
| Private AKS and secure workspace | [docs/release2/04-private-platform-secure-workspace.md](docs/release2/04-private-platform-secure-workspace.md) |
| Governed AI operations | [docs/release2/05-ai-operations-enclave.md](docs/release2/05-ai-operations-enclave.md) |

---

## Terraform and IaC review

| Topic | Best path |
|---|---|
| Terraform overview | [terraform/README.md](terraform/README.md) |
| State boundary map | [docs/release2/11-terraform-state-and-pipeline-map.md](docs/release2/11-terraform-state-and-pipeline-map.md) |
| Platform networking root | [terraform/platform-networking/dev/](terraform/platform-networking/dev/) |
| Platform management root | [terraform/platform-management/dev/](terraform/platform-management/dev/) |
| Private AKS root | [terraform/platform-aks/dev/](terraform/platform-aks/dev/) |
| AVD root | [terraform/platform-avd/dev/](terraform/platform-avd/dev/) |
| AWS branch root | [terraform/aws-branch/dev/](terraform/aws-branch/dev/) |

---

## AI operations review

| Question | Best path |
|---|---|
| What is O6? | [docs/release2/05-ai-operations-enclave.md](docs/release2/05-ai-operations-enclave.md) |
| Where is the evidence? | [docs/release2/evidence/O6/](docs/release2/evidence/O6/) |
| Where are Kubernetes support manifests? | [kubernetes/README.md](kubernetes/README.md) |
| What is the companion AI lab? | [local-ai-lab-infra](https://github.com/jrikobd-azaws/local-ai-lab-infra) |
| What is the policy boundary? | [AI Operations site page](https://www.azawslab.co.uk/ai-operations/) |

---

## Release gateways

| Release | Purpose |
|---|---|
| [Release 1](docs/release1/README.md) | Hybrid Modern Workplace, Identity, Endpoint Security |
| [Release 2](docs/release2/README.md) | Azure Platform Engineering, Security, Automation, Private Platform, AI Operations |
| [Release 3](docs/release3/README.md) | Multi-cloud Kubernetes, GitOps, DevSecOps roadmap |

---

## Navigation

- [Live portfolio showroom](https://www.azawslab.co.uk/)
- [Repository home](README.md)
- [Proof gallery](PROOF_GALLERY.md)
- [Evidence guide](EVIDENCE_GUIDE.md)
- [Architecture](ARCHITECTURE.md)
- [Code traceability map](CODE_TRACEABILITY.md)
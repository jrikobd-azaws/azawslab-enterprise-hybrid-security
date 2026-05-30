# Code Traceability Map

> Part of: [Azawslab Enterprise Hybrid Security Platform](README.md)  
> Best for: technical reviewers, security architects, DevOps/SRE reviewers and hiring managers validating implementation depth  
> Purpose: map portfolio claims to documentation, source implementation and public-safe evidence

## How to use this map

This document connects the portfolio narrative to the engineering source tree.

Use it to verify:

- what the platform claims
- where the implementation source lives
- where public-safe evidence validates the claim

---

## Executive traceability

| Capability | Documentation | Source implementation | Evidence |
|---|---|---|---|
| Hybrid Modern Workplace, Identity, Endpoint Security and Microsoft 365 Operations | [Release 1 docs](docs/release1/) | [scripts/release1](scripts/release1/) | [screenshots/release1](screenshots/release1/) |
| Azure Platform Engineering, Security, Automation, Private Platform and AI Operations | [Release 2 docs](docs/release2/) | [terraform](terraform/), [ansible](ansible/), [kubernetes](kubernetes/), [.github/workflows](.github/workflows/) | [Release 2 evidence index](docs/release2/evidence/) |
| Multi-Cloud Kubernetes, GitOps and DevSecOps Roadmap | [Release 3 docs](docs/release3/) | Roadmap documentation | [Release 3 roadmap](docs/release3/00-roadmap.md) |

---

## Release 1 traceability

| Capability | Source / documentation | Evidence |
|---|---|---|
| Hybrid identity and Entra integration | [docs/release1](docs/release1/) | [screenshots/release1/identity-and-access](screenshots/release1/identity-and-access/) |
| Conditional Access and identity protection | [docs/release1](docs/release1/) | [screenshots/release1/identity-and-access](screenshots/release1/identity-and-access/) |
| Intune endpoint management | [docs/release1](docs/release1/) | [screenshots/release1/endpoint-management](screenshots/release1/endpoint-management/) |
| Windows Autopilot | [docs/release1](docs/release1/) | [screenshots/release1/endpoint-management](screenshots/release1/endpoint-management/) |
| Microsoft 365 operations | [docs/release1](docs/release1/) | [screenshots/release1/modern-workplace](screenshots/release1/modern-workplace/) |
| Purview information protection | [docs/release1](docs/release1/) | [screenshots/release1/information-protection](screenshots/release1/information-protection/) |
| Graph and PowerShell operations | [scripts/release1](scripts/release1/) | [screenshots/release1](screenshots/release1/) |
| Monitoring and operational recovery | [docs/release1](docs/release1/) | [screenshots/release1/monitoring-and-operations](screenshots/release1/monitoring-and-operations/) |

---

## Release 2 traceability

| Capability | Source implementation | Evidence |
|---|---|---|
| Terraform state boundaries | [terraform](terraform/), [Terraform state map](docs/release2/11-terraform-state-and-pipeline-map.md) | [P2a evidence](docs/release2/evidence/P2a/) |
| Secretless GitHub Actions OIDC | [.github/workflows](.github/workflows/) | [P0 evidence](docs/release2/evidence/P0/) |
| Ansible automation | [ansible](ansible/), [scripts](scripts/) | [Release 2 evidence index](docs/release2/evidence/) |
| AWX automation control plane | [terraform/platform-management/dev](terraform/platform-management/dev/), [ansible](ansible/) | [A2 AWX control-plane evidence](docs/release2/evidence/A2-awx-control-plane/) |
| Hybrid BGP and multi-cloud transit | [terraform/platform-networking/dev](terraform/platform-networking/dev/), [terraform/aws-branch/dev](terraform/aws-branch/dev/) | [O3b evidence](docs/release2/evidence/O3b/), [O3c evidence](docs/release2/evidence/O3c/) |
| Secure transmission, inspection and private routing | [terraform/platform-networking/dev](terraform/platform-networking/dev/), [terraform/platform-aks/dev](terraform/platform-aks/dev/), [terraform/platform-avd/dev](terraform/platform-avd/dev/) | [Release 2 evidence index](docs/release2/evidence/) |
| Private AKS platform | [terraform/platform-aks/dev](terraform/platform-aks/dev/), [terraform/modules/private-aks-platform](terraform/modules/private-aks-platform/) | [O4 evidence](docs/release2/evidence/O4/) |
| AVD secure workspace and FSLogix | [terraform/platform-avd/dev](terraform/platform-avd/dev/), [terraform/modules/avd-secure-workspace](terraform/modules/avd-secure-workspace/) | [O5 evidence](docs/release2/evidence/O5/) |
| Governed AI operations enclave | [kubernetes/o6-ai-enclave](kubernetes/o6-ai-enclave/), [kubernetes/o6-ai-enclave-live](kubernetes/o6-ai-enclave-live/) | [O6 evidence](docs/release2/evidence/O6/) |

---

## Reviewer shortcuts

| Reviewer goal | Start here |
|---|---|
| Understand the whole project | [README](README.md) and [Reviewer Guide](REVIEWER_GUIDE.md) |
| Validate architecture | [ARCHITECTURE.md](ARCHITECTURE.md) |
| Validate source implementation | [terraform](terraform/), [ansible](ansible/), [kubernetes](kubernetes/), [scripts](scripts/) |
| Validate evidence | [PROOF_GALLERY.md](PROOF_GALLERY.md), [EVIDENCE_GUIDE.md](EVIDENCE_GUIDE.md), [docs/release2/evidence](docs/release2/evidence/) |
| Match skills to roles | [SKILLS_MATRIX.md](SKILLS_MATRIX.md) |

---

## Navigation

- [Repository home](README.md)
- [Reviewer guide](REVIEWER_GUIDE.md)
- [Architecture](ARCHITECTURE.md)
- [Proof gallery](PROOF_GALLERY.md)
- [Evidence guide](EVIDENCE_GUIDE.md)
- [Live portfolio showroom](https://www.azawslab.co.uk/)
# Release 2 Evidence Index

[![Back to Release 2](https://img.shields.io/badge/Back%20to-Release%202-059669?style=flat-square)](../README.md)
[![Proof Gallery](https://img.shields.io/badge/Proof%20Gallery-Curated%20Evidence-166534?style=flat-square)](../../../PROOF_GALLERY.md)
[![Evidence Guide](https://img.shields.io/badge/Evidence%20Guide-Redaction%20and%20Proof-374151?style=flat-square)](../../../EVIDENCE_GUIDE.md)
[![Live Gallery](https://img.shields.io/badge/Live%20Gallery-www.azawslab.co.uk-0B5CAD?style=flat-square)](https://www.azawslab.co.uk/proof-gallery/)

> Part of: [Release 2 - Azure Platform Engineering, Security, Automation, Private Platform, and AI Operations](../README.md)  
> Purpose: capability-mapped evidence entry point for technical reviewers, security reviewers, and hiring managers  
> Scope: public-safe evidence summaries and validation artifacts only

---

## How to use this evidence

Release 2 evidence is organized by implementation milestone folders. Reviewers usually need to validate capabilities, not decode phase names. This index maps the evidence folders to the architecture and engineering outcomes they support.

| Reviewer | Best path |
|---|---|
| Recruiter | Start with the [Proof Gallery](../../../PROOF_GALLERY.md) for curated, high-level proof |
| Hiring manager | Review the capability groups below to understand delivery maturity and operational scope |
| Technical reviewer | Open the relevant folder, then compare evidence with implementation files and workflow definitions |
| Security architect | Focus on governance, networking, private platform, O6 AI operations, and evidence-handling guidance |
| Evidence-first reviewer | Use this page with the [Evidence Guide](../../../EVIDENCE_GUIDE.md) |

---

## Platform governance and IaC maturity

| Evidence folder | What it proves |
|---|---|
| [P0](P0/) | GitHub Actions OIDC and workflow-controlled Terraform delivery foundation |
| [P1](P1/) | Early Release 2 platform baseline and validation evidence |
| [P2a](P2a/) | Terraform state split and root boundary validation |
| [P2b](P2b/) | Follow-on platform state and management refinement evidence |
| [P3](P3/) | Governance, policy, and platform control-plane validation context |
| [backend-migration](backend-migration/) | Terraform backend migration and remote-state discipline |

---

## Secure hybrid and multi-cloud networking

| Evidence folder | What it proves |
|---|---|
| [P4](P4/) | Core networking and routing validation for Release 2 platform growth |
| [P5](P5/) | Hybrid connectivity, routing, and inspection evidence |
| [P5-vpn](P5-vpn/) | VPN-specific validation and hybrid connectivity proof |
| [O3b](O3b/) | AWS branch and hybrid or multi-cloud integration evidence |
| [O3c](O3c/) | Extended hybrid or multi-cloud trust-path and routing validation evidence |

---

## Automation and management control plane

| Evidence folder | What it proves |
|---|---|
| [A1-ansible-network-baseline](A1-ansible-network-baseline/) | Ansible network baseline and automation validation |
| [A2-awx-control-plane](A2-awx-control-plane/) | AWX automation control-plane implementation and validation |
| [platform-management-state-split](platform-management-state-split/) | Management-plane Terraform state isolation and ownership boundary |
| [ephemeral-ops-resources](ephemeral-ops-resources/) | Temporary operational resource lifecycle: provision, validate, and clean up |

---

## Private platform and secure workspace

| Evidence folder | What it proves |
|---|---|
| [O1](O1/) | Release 2 operational capability evidence supporting the private-platform journey |
| [O2](O2/) | Supporting operational evidence for later private platform and management-plane capabilities |
| [O4](O4/) | Private AKS platform validation and controlled access or egress evidence |
| [O5](O5/) | Azure Virtual Desktop and FSLogix secure workspace evidence |

---

## Security, monitoring, and resilience

| Evidence folder | What it proves |
|---|---|
| [P6](P6/) | Supporting platform security or operational validation evidence |
| [P7](P7/) | Defender, security posture, and platform protection evidence |
| [P8](P8/) | Sentinel, governance, and policy exemption validation evidence |
| [P9a](P9a/) | Monitoring, alerting, and operational response evidence |
| [P9b](P9b/) | Backup, recovery, and resilience evidence |
| [P9b-redesign](P9b-redesign/) | Improved backup and governance design validation evidence |

---

## Governed AI operations

| Evidence folder | What it proves |
|---|---|
| [O6](O6/) | Policy-mediated AI operations enclave, MCP-style boundary, Kubernetes support manifests, and AI operations validation evidence |

---

## Supporting lab foundation

| Evidence folder | What it proves |
|---|---|
| [HyperVLab](HyperVLab/) | Local Hyper-V foundation supporting the hybrid lab and enterprise-style environment design |

---

## Reviewer notes

- Evidence folders are public-safe summaries and redacted validation artifacts.
- Some folder names preserve historical implementation milestone names. The capability groups above explain how each folder should be reviewed.
- For the curated visual path, use the [live proof gallery](https://www.azawslab.co.uk/proof-gallery/).
- For evidence-handling rules, use the [Evidence Guide](../../../EVIDENCE_GUIDE.md).

---

## Navigation

- [Back to Release 2](../README.md)
- [Repository home](../../../README.md)
- [Reviewer guide](../../../REVIEWER_GUIDE.md)
- [Proof gallery](../../../PROOF_GALLERY.md)
- [Evidence guide](../../../EVIDENCE_GUIDE.md)
- [Live portfolio showroom](https://www.azawslab.co.uk/)
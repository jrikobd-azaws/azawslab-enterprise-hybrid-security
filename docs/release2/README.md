# Release 2 â€” Azure Platform Engineering, Security, Automation, Private Platform & AI Operations

> **Part of the [Azawslab Enterprise Hybrid Security Platform](../../README.md)**
>
> **Status:** Implemented and evidenced.

---

## Overview

Release 2 transforms the Release 1 Hybrid Modern Workplace, Identity & Endpoint Security foundation into a governed, multi-cloud enterprise platform. It moves operations from manual portal management to a strict **Git-driven, IaC-first delivery model**. This release proves the ability to engineer secure Azure landing zones, implement multi-cloud network transit, automate infrastructure via AWX, deliver private containerised platforms, and govern AI-assisted CloudOps.

Every capability in this release is **operationally validated** through CLI-first evidence, Git-controlled deployments, and documented validation workflows.

---

## Capability Tracks

Release 2 is organised into the following capability stories, which serve as the primary reading path for technical reviewers and hiring managers:

| Capability Story | Focus |
|---|---|
| **01. Landing Zone, IaC & Governance** | Infrastructure as Code (Terraform), OIDC-authenticated CI/CD, Azure Policy guardrails, and naming standards. |
| **02. Hybrid & Multi-Cloud Networking** | Hub-spoke architecture, FortiGate/VyOS/Cisco transit, IPSec/BGP routing, and private service connectivity. |
| **03. Automation, SecOps & Resilience** | AWX control plane, Ansible configuration management, runtime secrets (Key Vault/SSM), and backup/recovery. |
| **04. Private Platform & Secure Workspace** | Private AKS, Azure Virtual Desktop with FSLogix, and hardened endpoint-to-platform connectivity. |
| **05. AI Operations Enclave** | Human-approved AI CloudOps: MCP gateway, RAG/LLM governance, and tool-use boundaries. |

---

## How to Read Release 2

This release is designed for role-based navigation. Use the following guide to find the technical depth relevant to your review:

| Role | Recommended Starting Point |
|---|---|
| **Cloud Platform Reviewer** | [01. Landing Zone & IaC](./01-landing-zone-iac-governance.md) |
| **Network & Security Reviewer** | [02. Hybrid & Multi-Cloud Networking](./02-hybrid-multicloud-network-security.md) |
| **DevOps / SRE Reviewer** | [03. Automation & SecOps](./03-automation-secops-resilience.md) |
| **Private Platform / AVD Specialist** | [04. Private Platform & Secure Workspace](./04-private-platform-secure-workspace.md) |
| **AI Operations / Security Reviewer** | [05. AI Operations Enclave](./05-ai-operations-enclave.md) |
| **Hiring Manager / Recruiter** | [06. Skills & Evidence Index](./06-skills-and-evidence-index.md) |

---

## Documentation Navigation

The following documents define the Release 2 operational and engineering reality:

| File | Purpose |
|---|---|
| [00. Summary](./00-summary.md) | Executive proof and validated outcome summary |
| [01. Landing Zone & IaC](./01-landing-zone-iac-governance.md) | Governance, IaC, and CI/CD engineering stories |
| [02. Hybrid & Multi-Cloud Networking](./02-hybrid-multicloud-network-security.md) | Transit architecture, firewalling, and routing validation |
| [03. Automation & SecOps](./03-automation-secops-resilience.md) | Ansible, AWX, monitoring, and secrets management |
| [04. Private Platform & Secure Workspace](./04-private-platform-secure-workspace.md) | Private AKS, AVD, and FSLogix integration |
| [05. AI Operations Enclave](./05-ai-operations-enclave.md) | AI-assisted operations, governance, and validation |
| [06. Skills & Evidence Index](./06-skills-and-evidence-index.md) | Capability-to-proof mapping |
| [11. Terraform State & Pipeline Map](./11-terraform-state-and-pipeline-map.md) | IaC state boundaries and pipeline execution model |
| [Phase Reference](./10-phase-reference/) | Deep technical implementation logs and phase-level tracing |

---

## Evidence Model

Release 2 evidence is **CLI-first and engineering-led**. We prioritise verifiable runtime state over portal screenshots. Evidence is organised by capability within `docs/release2/evidence/`.

*   **Terraform Evidence:** Plan/apply logs, state boundary audits, and pipeline execution success (OIDC).
*   **Networking Evidence:** Routing tables, FortiGate policy flow logs, BGP status, and connectivity validation.
*   **Automation Evidence:** AWX job stdout, playbook execution logs, and Key Vault/SSM secret retrieval validation.
*   **AKS/AVD/Enclave Evidence:** Cluster API posture, FSLogix profile container tests, MCP gateway policy logs, and human-in-the-loop review records.

*Note: All evidence is redacted to preserve tenant security. Links to specific proof items that are currently undergoing reorganization are marked `proof link to be inserted`.*

---

## Phase Reference Snapshot

For implementation traceability and deep technical audits, individual phases are tracked below. These serve as the supporting implementation backbone for the capability stories above.

| Phase | Description | Status |
|---|---|---|
| P0-P4 | Foundation, Governance, and Lighthouse | Complete and evidenced |
| P5-P6, O1 | Networking, Firewall, and Service Chaining | Complete and evidenced |
| P7-P9a | Defender, Sentinel, and Monitor Alerts | Complete and evidenced |
| P9b | Backup & Recovery Services Vault | Complete and evidenced |
| A1, A2 | Ansible Baseline & AWX Automation | Complete and evidenced |
| O4 | Private AKS | Complete and evidenced |
| O5 | AVD + FSLogix Secure Workspace | Complete and evidenced |
| O6 | AI Operations Enclave | Complete and evidenced |

---

## Key Design Principles

- **IaC-First Delivery:** GitHub Actions controlled apply is the default execution model. Local Terraform apply is exceptional.
- **Secrets Management:** No secrets in source code. Runtime retrieval via Key Vault and AWS SSM is enforced.
- **Network Boundaries:** `br1.azawslab.co.uk` defines the branch office namespace, maintaining clean identity and routing isolation.
- **Operational Reality:** Documentation includes recovery scenarios, idempotency proofs, and remediation workflows to prove the system is supportable, not just deployable.
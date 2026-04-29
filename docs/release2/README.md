# Release 2 – Azure Platform Engineering & Security

> **Part of the [azawslab Enterprise Hybrid Security Platform](../README.md)**  
> Status: **In progress** – see [implementation tracker](../implementation-tracker.md)

## Overview

Release 2 builds a modern Azure landing zone from scratch, using **infrastructure as code (Terraform)** and **secretless CI/CD (GitHub Actions + OIDC)**. It establishes a hub‑spoke network, centralised security inspection (Azure Firewall, optionally FortiGate NVA), cloud security posture management (Defender for Cloud), a SIEM (Microsoft Sentinel), and optional advanced capabilities: multi‑cloud BGP routing (AWS Cisco), hybrid management (Azure Arc), Zero Trust SSE (Entra Global Secure Access), and modern VDI (AVD + FSLogix).

All resources follow a strict **naming convention** and are validated via **CLI‑first commands** – not just portal screenshots.

---

## Key Deliverables (Phases P0–P9c, O1–O5)

| Category | Phases | What is built |
|----------|--------|----------------|
| **Foundation** | P0, P1, P2a, P2b, P2c | OIDC bootstrap, Terraform backend, management groups, policy guardrails, reusable Terraform modules, Ansible roles, CI/CD pipelines |
| **Network & Security** | P5, P6, O1 | Hub‑spoke VNets, Azure Firewall, dual‑firewall with FortiGate NVA (optional), forced tunneling, UDRs |
| **Governance & MSP** | P3, P4 | Policy‑as‑code (allowed regions, VM SKUs, mandatory tags), least‑privilege RBAC, Azure Lighthouse cross‑tenant delegation |
| **Observability & SIEM** | P7, P8, P9a | Defender for Cloud (CSPM), Microsoft Sentinel (analytic rules, incidents), Azure Monitor alerts (CPU >85% email) |
| **Disaster Recovery** | P9b | Recovery Services Vault with immutability, Multi‑User Authorization (Resource Guard), optional ASR |
| **Hybrid & Multi‑Cloud** | O2, O3a, O3b, O3c | Azure Arc (on‑prem projection), BGP over IPSec (FortiGate ↔ Hyper‑V), AWS Cisco NVA with segmented BGP, transitive routing (global hub) |
| **Zero Trust & VDI** | O4, O5 | Entra Global Secure Access (ZTNA, replaces legacy VPN), AVD with FSLogix profile containers, auto‑scaling |

---

## Documentation & Tracking

| Document | Purpose |
|----------|---------|
| [Master Plan](./README_PLAN.md) | Complete step‑by‑step phases, CLI commands, and architecture diagrams (source of truth) |
| [Implementation Tracker](../implementation-tracker.md) | Status checklists, evidence paths, FinOps teardown commands |
| [Architecture Decisions](../architecture.md) | ADRs explaining why we made each choice (OIDC, dual‑firewall, GSA, etc.) |
| [Naming Conventions](../naming-conventions.md) | Resource naming patterns for VNets, VMs, Key Vault, etc. |
| [Phase Steps](./phase-with-steps.md) | Copy‑paste ready commands for each phase (extracted from master plan) |

---

## Transition from Release 1 to Release 2

Release 1 successfully established a hybrid workplace foundation using the `corp.azawslab.co.uk` AD domain and a Microsoft 365 tenant. During that phase, the domain was verified and configured.

For Release 2, the goal is to build a modern Azure platform with full infrastructure‑as‑code, Zero Trust networking, and advanced security monitoring. To create a clean, production‑intent environment free from legacy constraints, I established a new Microsoft Entra ID tenant with a dedicated namespace, `entra.azawslab.co.uk`. The on‑premises identity anchor is now `hq.azawslab.co.uk`, representing corporate headquarters, while a branch RODC uses `br1.azawslab.co.uk`.

This separation reflects real‑world scenarios where enterprises spin up greenfield cloud initiatives while maintaining existing on‑prem infrastructure. Microsoft Entra Connect synchronises identities between `hq.azawslab.co.uk` (and optionally the RODC) to `entra.azawslab.co.uk` using UPN suffix transformation – a standard pattern for rebranding or centralising cloud identity.

Release 1 remains in the repository as a completed, independent phase, demonstrating the foundational hybrid workplace skills. Release 2 advances the portfolio into Azure platform engineering and security, using a fresh identity namespace to align with best practices.


### Domain Namespaces

| Phase | Purpose | Domain / Namespace | Status |
|-------|---------|--------------------|--------|
| Release 1 baseline | Original hybrid workplace foundation | `corp.azawslab.co.uk` | Completed |
| Release 1 advanced validation | Cloud‑first continuation | `belfast.azawslab.co.uk` | Completed |
| Release 2 HQ AD | Greenfield corporate identity anchor | `hq.azawslab.co.uk` | New |
| Release 2 branch RODC | Branch office identity namespace | `br1.azawslab.co.uk` | New |
| Release 2 Entra tenant | Greenfield cloud identity namespace | `entra.azawslab.co.uk` | New |

---

## Evidence & Validation

All validation outputs (CLI logs, Terraform plans, KQL queries, and limited screenshots) are stored in:

**`/docs/release2/evidence/`** (not `/screenshots/release2/`)

This aligns with the **CLI‑first** validation approach of Release 2. Each phase has its own subfolder (e.g., `P0/`, `P6/`, `O1/`). Raw terminal outputs and text logs are the primary evidence; screenshots are supplementary.

For Release 1 evidence, see `/screenshots/release1/`.

---

## Getting Started with Release 2

1. Read the [Master Plan](./README_PLAN.md) – it contains all prerequisites and phases.
2. Use the [Implementation Tracker](../implementation-tracker.md) to follow your progress.
3. Run commands from [Phase Steps](./phase-with-steps.md) – but always refer back to the master plan for context.
4. Capture evidence into `/docs/release2/evidence/<phase>/` using the naming convention described in the master plan.

> **Important:** Release 2 uses a **separate Entra ID tenant** (`entra.azawslab.co.uk`) and a **greenfield AD domain** (`hq.azawslab.co.uk`). Do not reuse Release 1 identities.

---

**Part of the azawslab Enterprise Hybrid Security Platform – building from hybrid workplace to cloud‑native security.**
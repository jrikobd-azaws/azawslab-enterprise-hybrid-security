# Release 2 – Azure Platform Engineering & Security

> **Part of the [azawslab Enterprise Hybrid Security Platform](../README.md)**  
> Status: **In progress** – see [implementation tracker](../implementation-tracker.md)

## Overview

Release 2 builds a modern Azure landing zone from scratch using **Infrastructure as Code (Terraform)** and **secretless CI/CD (GitHub Actions + OIDC)**. It establishes a hub-spoke network, centralised security inspection, governance guardrails, cloud security posture management, SIEM visibility, and optional advanced capabilities for hybrid, multi-cloud, Zero Trust access, and virtual desktop delivery.

The project is designed to demonstrate:
- Azure platform engineering
- secure automation with OIDC
- policy-as-code governance
- hybrid and multi-cloud networking
- operational validation with CLI-first evidence

All resources follow a strict **naming convention** and are validated primarily through **CLI-first evidence**, not just portal screenshots.

---

## Key Deliverables (Phases P0–P9c, O1–O5)

| Category | Phases | What is built |
|----------|--------|----------------|
| **Foundation** | P0, P1, P2a, P2b, P2c | OIDC bootstrap, Terraform backend, management groups, policy guardrails, reusable Terraform modules, Ansible roles, CI/CD pipelines |
| **Network & Security** | P5, P6, O1 | Hub-spoke VNets, Azure Firewall, dual-firewall with FortiGate NVA (optional), forced tunneling, UDRs |
| **Governance & MSP** | P3, P4 | Policy-as-code (allowed regions, VM SKUs, mandatory tags), least-privilege RBAC, Azure Lighthouse cross-tenant delegation |
| **Observability & SIEM** | P7, P8, P9a | Defender for Cloud (CSPM), Microsoft Sentinel (analytic rules, incidents), Azure Monitor alerts |
| **Disaster Recovery** | P9b | Recovery Services Vault with immutability, Multi-User Authorization (Resource Guard), optional ASR-aligned controls |
| **Hybrid & Multi-Cloud** | O2, O3a, O3b, O3c | Azure Arc, BGP over IPSec (FortiGate ↔ VyOS on Hyper-V), AWS Cisco NVA with segmented BGP, transitive routing validation |
| **Zero Trust & VDI** | O4, O5 | Entra Global Secure Access (ZTNA / private access), AVD with FSLogix profile containers |

---

## Documentation & Tracking

| Document | Purpose |
|----------|---------|
| [Master Plan](./README_PLAN.md) | Authoritative source of truth for scope, architecture, sequencing, and implementation intent |
| [Implementation Tracker](../implementation-tracker.md) | Operational control document for readiness, phase progress, validation status, blockers, and teardown tracking |
| [Architecture Decisions](../architechture.md) | ADRs that explain why major design choices were made |
| [Naming Conventions](../naming-conventions.md) | Canonical naming, tagging, identity, evidence, and repo file naming standards |
| [Phase Guide](./Phases-with-steps.md) | Operator-focused phase execution guide with configuration snapshots, compact text diagrams, steps, validation, and evidence reminders |
| [Build Checklist](../build_checklist.md) | Build-time execution checklist for organized implementation flow |

---

## Release 2 Design Themes

### 1. Secretless Automation
GitHub Actions authenticates to Azure using **OIDC federation**, removing the need for long-lived client secrets.

### 2. Governance First
Management groups, Azure Policy, tagging, and RBAC are established early so the platform is controlled before it scales.

### 3. Private-Only Workloads
Workload VMs remain private unless a public IP is explicitly required by the design. Administrative and hybrid access flows are controlled intentionally.

### 4. Hybrid and Multi-Cloud Depth
The project goes beyond a standard Azure landing zone by introducing:
- FortiGate-based hybrid transit
- VyOS-based on-prem simulation on Hyper-V
- AWS Cisco branch routing
- transitive routing validation through a central Azure transit hub

### 5. CLI-First Validation
Evidence is collected primarily through:
- Azure CLI output
- Terraform plan/apply logs
- Ansible output
- route validation output
- KQL / monitoring results

---

## Transition from Release 1 to Release 2

Release 1 established a hybrid workplace foundation using the `corp.azawslab.co.uk` domain and Microsoft 365-oriented services.

Release 2 moves into full Azure platform engineering and security by introducing:
- a new Microsoft Entra namespace: `entra.azawslab.co.uk`
- a new HQ AD anchor: `hq.azawslab.co.uk`
- an optional branch namespace: `br1.azawslab.co.uk`

This separation reflects a realistic greenfield cloud initiative where a new Azure platform is built with modern governance, Zero Trust principles, and infrastructure-as-code while legacy or previous environments remain distinct.

---

## Tenant and Subscription Setup Rationale

To build a fully functional Azure Virtual Desktop (AVD) lab without upfront cost, I first created an Azure Free Trial subscription using my personal Microsoft Account (MSA), which provided the $200 Azure credit that Microsoft does not offer directly to newly created work/school tenants. Since Microsoft 365 E5 trials are only available to organizational tenants, I then created a new Microsoft Entra ID (work) tenant and activated the Microsoft 365 E5 trial there to unlock AVD‑required services such as Windows Enterprise, Entra ID P2, Intune, and Defender. Because Azure credits cannot be issued directly to a new work tenant, I transferred the Azure subscription (and its remaining $200 credit) from the personal MSA directory into the new organizational tenant. This unified all compute, identity, and licensing under a single enterprise tenant, enabling a clean, production‑style environment for deploying and testing Azure Virtual Desktop.

## Domain Namespaces

| Phase / Scope | Purpose | Domain / Namespace | Status |
|---------------|---------|--------------------|--------|
| Release 1 baseline | Original hybrid workplace foundation | `corp.azawslab.co.uk` | Completed |
| Release 1 advanced validation | Cloud-first continuation | `belfast.azawslab.co.uk` | Completed |
| Release 2 HQ AD | Greenfield corporate identity anchor | `hq.azawslab.co.uk` | New |
| Release 2 branch RODC | Branch office identity namespace | `br1.azawslab.co.uk` | New |
| Release 2 Entra tenant | Greenfield cloud identity namespace | `entra.azawslab.co.uk` | New |

---

## Evidence & Validation

All Release 2 evidence should be stored under:

`docs/release2/evidence/`

This aligns with the CLI-first validation model of the project.

Each phase should have its own evidence subfolder, for example:
- `docs/release2/evidence/P0/`
- `docs/release2/evidence/P5/`
- `docs/release2/evidence/O3a/`

Preferred evidence types:
- `.txt`
- `.md`

Screenshots are supplementary and should only be used where text-first evidence is not enough.

For Release 1 evidence, see the Release 1 evidence path in that part of the repository.

---

## Getting Started with Release 2

1. Read the [Master Plan](./README_PLAN.md) first.
2. Review the [Implementation Tracker](../implementation-tracker.md) to understand readiness, dependencies, and current status.
3. Use the [Phase Guide](./Phases-with-steps.md) as the working execution companion during implementation.
4. Follow the [Naming Conventions](../naming-conventions.md) when creating resources, identities, files, evidence, and workflows.
5. Capture validation output into `docs/release2/evidence/<Phase>/`.
6. Use the [Build Checklist](../build_checklist.md) to stay organized during execution.

---


## Current P2b implementation note

P2b currently proves the Azure-connected management-host and Ansible control path:
- temporary Linux management host in a separate management plane
- private WinRM reachability to the Windows workload VM
- role-based Ansible scaffold
- validated common role with idempotent rerun

Execution of d-join to hq.azawslab.co.uk is deferred until HQ AD and hybrid connectivity are ready.

## Recommended Working Order

For the most controlled implementation flow:

1. Align documentation and file references.
2. Complete environment readiness and pre-P0 checks.
3. Execute the core platform phases first.
4. Add optional advanced phases only after the core platform is stable.
5. Tear down expensive ephemeral resources as soon as validation is complete.
6. Finish with final evidence review and portfolio packaging.

---

## Core Release 2 Principles

- **Source of truth:** `README_PLAN.md`
- **Execution guide:** `Phases-with-steps.md`
- **Operational control:** `implementation-tracker.md`
- **Naming authority:** `naming-conventions.md`
- **Architecture rationale:** `architechture.md`
- **Execution discipline:** validate, capture evidence, then tear down ephemeral components

---


## Environment Readiness Status

- **Project Status:** Deployment ready  
- **Identity:** Primary lab admin account:** `admin-lab@entra.azawslab.co.uk`  
- **Break-glass global account:** `hashib@entra.azawslab.co.uk`  
- **Funding:** Azure `$200` credit successfully moved  
- **Licensing:** Microsoft 365 E5 is active and assigned  
- **Namespace:** `entra.azawslab.co.uk` is the verified tenant boundary

---

## Current Status

- **P0:** Complete
- **P1:** Complete
- **P2a:** Complete
- **P2c:** Complete
- **Finalized implementation region:** `norwayeast`
- **Finalized VM SKU:** `Standard_B2als_v2`
- **Current active Terraform backend:** `rg-dev-terraformstate-norwayeast` / `stdevtfstatene01`

Release 2 region and VM sizing were treated as validated implementation inputs rather than static assumptions.
Candidate regions and SKUs were assessed against actual subscription-level deployability first, and the Terraform design was then aligned to the confirmed implementation target.

Terraform automation is now operational and validated end to end:
- PR-triggered CI passed for governance, platform-shared/dev, and workload-dev
- controlled apply passed on `main` for governance, platform-shared/dev, and workload-dev
- OIDC-based Azure authentication validated for CI and apply

## Final Note

This release is intended to be more than a lab build. It is structured as a portfolio-grade Azure platform engineering project that demonstrates architectural thinking, secure automation, governance maturity, hybrid networking depth, and operational discipline.


# 11. Terraform State & Pipeline Map - Release 2

> **Part of** [Release 2 - Azure Platform Engineering, Security, Automation, Private Platform & AI Operations](./README.md)
>
> **Status:** Implemented and evidenced.

---

## Purpose

This document is the reference map for the **Terraform state architecture** and the **CI/CD pipeline execution model** used in Release 2. It shows how infrastructure delivery is governed, how state boundaries align with operational lifecycles, and how every change flows from Git to Azure through a controlled, secretless pipeline.

Technical reviewers, DevOps/SRE engineers, and hiring managers can use this map to understand:
- Why the state is split the way it is.
- Where each Terraform root lives and what it controls.
- How the GitHub Actions workflow enforces review-before-apply.
- How OpenID Connect (OIDC) eliminates static credentials from the delivery path.

---

## Terraform State Boundaries

Release 2 uses a **split-state model** rather than a single monolithic Terraform root. Each root owns a distinct operational lifecycle, reducing blast radius and enabling independent planning, review, and application.

The paths below are shown relative to the repository's `terraform/` directory.

| Terraform Root | Lifecycle Scope | Key Resources | Evidence |
|---|---|---|---|
| `governance` | Platform governance and management structure | Management groups, policy assignments, RBAC definitions | [`P1`](./evidence/P1/), [`P3`](./evidence/P3/) |
| `platform-shared/dev` | Shared platform services | Key Vault, shared networking primitives, management identity | [`P2a`](./evidence/P2a/), [`P2b`](./evidence/P2b/) |
| `platform-networking/dev` | Hub-spoke network fabric | Hub VNet, Azure Firewall, VPN Gateway, FortiGate NVA, route tables, NSGs; active-profile enable flags for optional hybrid resources | [`P5`](./evidence/P5/), [`P6`](./evidence/P6/), [`P5-vpn`](./evidence/P5-vpn/), [`O1`](./evidence/O1/) |
| `platform-aks/dev` | Private container runtime | Private AKS cluster, ACR, managed Prometheus/Grafana, workload identity | [`O4`](./evidence/O4/) |
| `platform-avd/dev` | Secure administrative workspace | AVD host pool, workspace, session hosts, FSLogix storage, private endpoints | [`O5`](./evidence/O5/) |
| `platform-management/dev` | Operations and automation tooling | Management VM, Bastion, AWX hosting infrastructure | [`P2b`](./evidence/P2b/), [`A2-awx-control-plane`](./evidence/A2-awx-control-plane/) |
| `workloads/dev` | Workload-level resources | Workload VMs, application-layer resources | Implementation source: [`terraform/workloads/dev`](../../terraform/workloads/dev/); split-state context: [`P2a`](./evidence/P2a/) |
| `aws-branch/dev` | AWS multi-cloud edge | AWS Transit Gateway, Cisco CSR 8000V, BGP configuration, route maps; active-profile enable flags for optional resources | [`O3b`](./evidence/O3b/), [`O3c`](./evidence/O3c/) |

The retired root `environments/dev-retired-after-state-split` documents the original three-root model (`governance`, `platform-shared`, `workloads`) from which the current granular structure evolved.

![Release 2 Terraform state boundaries](../../diagrams/release2/terraform-state-boundaries.png)

**Design principles:**
- Each root has its own remote state file in Azure Storage, with native blob leasing to prevent concurrent modifications.
- State files are never committed to the repository.
- Changes to networking, AKS, AVD, and management are isolated; a change to the AVD host pool cannot accidentally affect the AKS cluster.
- The `governance` root is intentionally minimal and stable, protecting the policy and RBAC foundation from frequent change.

---

## Active Profile Guardrails

Some Release 2 roots include optional or cost-sensitive resources controlled by enable flags. This includes networking and hybrid/multi-cloud resources such as Azure VPN Gateway, FortiGate, Cisco 8000V, Azure Firewall, and validation infrastructure. Many enable flags intentionally default to `false` so optional resources are not created by accident.

A raw local `terraform plan` can be misleading when the active profile flags are not supplied, because Terraform may propose destroying resources that are intentionally retained for the current validation window.

**Active profile roots and their wrapper scripts:**

| Root | Active Profile | Wrapper Script |
|---|---|---|
| `platform-networking/dev` | `current-hybrid` | `.\scripts\release2\plan-platform-networking-current-hybrid.ps1` |
| `aws-branch/dev` | `o3b-dev` | `.\scripts\release2\plan-aws-o3b-current.ps1` |

**Rule:** Use profile-aware wrapper scripts for active optional roots where applicable. Local Terraform is limited to `init`, `validate`, `plan`, and preflight checks. Apply remains GitHub Actions controlled unless explicitly approved.

**Stop conditions:** Stop immediately if any plan shows destroy/replacement of VPN Gateway, FortiGate VM/NIC, Cisco EC2/ENI/EIP, route tables, or unexpected public access widening.

---

## GitHub Actions Pipeline Model

All infrastructure delivery follows the **GitHub Actions controlled-apply model**. Local Terraform apply is exceptional, documented, and never the default.

### Pipeline workflow

```text
Pull Request (feature branch -> main)
        |
        v
+------------------------------+
|  terraform plan              |
|  (OIDC-authenticated)        |
|  Plan output captured for    |
|  review                      |
+--------------+---------------+
               |
               v
+------------------------------+
|  Human review of plan output |
|  (resources created, changed,|
|   destroyed)                 |
+--------------+---------------+
               |
               v
+------------------------------+
|  Review / approval gate      |
+--------------+---------------+
               |
               v
+------------------------------+
|  Approved controlled apply   |
|  stage (OIDC-authenticated)  |
|  terraform apply executed    |
+------------------------------+
```

![Release 2 controlled Terraform pipeline flow](../../diagrams/release2/pipeline-flow.png)

### Key properties
- **Secretless authentication:** GitHub Actions authenticates to Azure via OpenID Connect (OIDC). No client secrets, service principal keys, or connection strings are stored in the repository.
- **Plan-review-apply separation:** The `plan` and `apply` stages are distinct jobs. Plan output must be reviewed by a human before apply can proceed.
- **State locking:** Azure Storage blob leasing prevents concurrent modification of the same remote state file.
- **Bounded execution scope:** Pipeline execution is designed around explicit root selection so review and apply scope remain bounded, preventing cross-boundary side effects.

---

## Evidence & Verification

The controlled-apply model is evidenced through pipeline logs and Terraform outputs stored in the Release 2 evidence tree:

| What to verify | Evidence |
|---|---|
| OIDC trust configuration and backend bootstrap | [`P0`](./evidence/P0/) |
| Management group and governance foundation | [`P1`](./evidence/P1/), [`P3`](./evidence/P3/) |
| Terraform module and split-state foundation | [`P2a`](./evidence/P2a/), [`P2b`](./evidence/P2b/) |
| Networking and active-profile hybrid evidence | [`P5`](./evidence/P5/), [`P6`](./evidence/P6/), [`P5-vpn`](./evidence/P5-vpn/), [`O1`](./evidence/O1/) |
| AWS branch and active-profile evidence | [`O3b`](./evidence/O3b/), [`O3c`](./evidence/O3c/) |
| Pipeline execution logs | Workflow source: [`release2-terraform-ci.yml`](../../.github/workflows/release2-terraform-ci.yml), [`release2-terraform-apply.yml`](../../.github/workflows/release2-terraform-apply.yml), platform-specific workflows under [`.github/workflows`](../../.github/workflows/), and public run history in [GitHub Actions](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/actions) |

For reviewers who need to trace a specific infrastructure change from commit to cloud, follow the path:

```text
Git commit hash -> GitHub Actions run -> terraform plan output -> review/approval gate -> terraform apply output -> evidence folder
```

---

## Operational Notes

- **Local apply is exceptional.** Developers may run `terraform plan` locally for testing, but any infrastructure mutation must go through the GitHub Actions pipeline.
- **State files are excluded from Git.** Remote state in Azure Storage is the single source of truth.
- **Apply requires explicit approval.** There is no auto-apply on push to main.
- **Active-profile roots require wrapper scripts.** For `platform-networking/dev` and `aws-branch/dev`, use the profile-aware wrapper scripts to supply the correct enable flags; raw local plans may propose unintended destruction.
- **Evidence is saved per phase.** Final-process evidence is stored under `docs/release2/evidence/<phase>/`. Do not commit `.tfplan`, `.tfstate`, private keys, raw secrets, PSKs, or unsanitized router running-config backups.

---

## What This Proves

The split-state model and controlled-apply pipeline prove several senior engineering competencies:

- **Infrastructure lifecycle design:** State boundaries align with operational lifecycles, not convenience. The evolution from the original three-root model to the current granular structure is documented and traceable.
- **Secrets hygiene:** OIDC eliminates credential rotation and leak risks from CI/CD.
- **Delivery discipline:** Plan-review-approve-apply ensures every change is deliberate and reviewed.
- **Blast radius control:** A failed AKS change is contained to the AKS state boundary and does not require touching the network or AVD roots.
- **Cost-aware architecture:** Active-profile enable flags prevent accidental deployment of costly resources while allowing them to be activated when needed.
- **Auditability:** Every change is traceable from Git commit through plan output to apply result and evidence folder.

---

*This map is maintained alongside the Release 2 Terraform roots and pipeline definitions. It is updated when state boundaries change or pipeline architecture evolves.*
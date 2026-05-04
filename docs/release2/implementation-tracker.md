# Implementation Tracker – Release 2 (Azure Platform Engineering & Security)

**Last Updated:** [02-May-2026]  
**Owner:** HASHIBUR RAHMAN  
**Repository:** `https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/docs/release2/`  
**Primary Source of Truth:** `README_PLAN.md`  
**Purpose:** Operational control document for planning, deployment, validation, evidence capture, and teardown of Release 2.

---

## 1. How to Use This Tracker

This tracker is the execution control document for Release 2.

Use it to:
- track phase readiness and completion
- record validation outcomes
- capture evidence paths
- identify blockers before proceeding
- enforce teardown of ephemeral resources to stay within budget

This file does **not** replace the master plan.  
It should be used together with:
- `README_PLAN.md` – authoritative phase design and detailed implementation logic
- `Phases-with-steps.md` – step execution support
- `naming-conventions.md` – naming and tagging standards
- `architechture.md` – architecture decisions and rationale
- `build_checklist.md` – execution checklist once finalised

---

## 2. Status Legend

| Symbol | Meaning                              |
| ------ | ------------------------------------ |
| [ ]    | Not started                          |
| [~]    | In progress                          |
| [x]    | Completed and validated              |
| [!]    | Blocked                              |
| [E]    | Ephemeral – destroy after validation |
| [O]    | Optional phase                       |

---

## 3. Operating Rules

### 3.1 Source-of-Truth Rule
If this tracker conflicts with `README_PLAN.md`, follow `README_PLAN.md` and update this tracker immediately.

### 3.2 Validation Rule
A phase is only marked complete when:
1. deployment/configuration succeeds
2. validation command(s) succeed
3. evidence is saved to the correct path
4. teardown is completed for ephemeral resources where required

### 3.3 Evidence Rule
Release 2 is **CLI-first**.  
Preferred evidence:
- CLI output logs
- Terraform plan/apply output
- KQL query results
- validation notes in `.md` or `.txt`

Screenshots are supplementary, not primary evidence.

### 3.4 FinOps Rule
Any phase marked `[E]` must include same-day teardown after validation unless the resource is actively needed for the next dependent phase.

### 3.5 Documentation Gate Rule
Do not begin infrastructure execution until these docs are aligned:
- `README_PLAN.md`
- `implementation-tracker.md`
- `Phases-with-steps.md`
- `naming-conventions.md`

---

## 4. Pre-Execution Readiness (Planning Phase)

This section reflects the current project state: planning/documentation first, execution environment later.

### 4.1 Master Documentation Alignment
- [x] Confirm `README_PLAN.md` is the current master plan
- [x] Confirm all support docs reference `README_PLAN.md` consistently
- [x] Remove stale RRAS references from all Release 2 support docs
- [x] Confirm VyOS is the on-prem routing standard for O3a / O3c
- [x] Confirm evidence root path is `docs/release2/evidence/`

### 4.2 Repository Planning Readiness
- [x] Repository structure reviewed for Release 2
- [x] Branching approach defined for docs and implementation
- [x] vscode workflow currently working for commit/push
- [x] Decision recorded to use VS Code + Codespaces before P0 execution
- [ ] `.gitignore` reviewed for Terraform, Ansible, logs, and local secrets

### 4.3 Execution Environment Readiness (to complete before P0 build work)
- [ ] VS Code workspace opened successfully for the repo
- [ ] GitHub Codespaces plan confirmed
- [ ] `.devcontainer/devcontainer.json` created or updated
- [ ] `az --version` works in the intended execution environment
- [ ] `terraform --version` works in the intended execution environment
- [ ] `ansible --version` works in the intended execution environment
- [ ] `git` works inside the intended execution environment
- [ ] `az login --use-device-code` or equivalent sign-in works

**Suggested `.devcontainer/devcontainer.json` baseline:**
```json
{
  "image": "mcr.microsoft.com/devcontainers/universal:2",
  "features": {
    "ghcr.io/devcontainers/features/terraform:1": {},
    "ghcr.io/devcontainers/features/azure-cli:1": {},
    "ghcr.io/devcontainers/features/ansible:1": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "hashicorp.terraform",
        "redhat.ansible",
        "ms-vscode.azurecli"
      ]
    }
  }
}
```

---

## 5. Preparation Phase (Pre-P0)

### 5.1 Azure Account, Tenant, and Subscription
- [ ] Azure subscription upgraded to Pay-As-You-Go
- [ ] Verified domain `entra.azawslab.co.uk` available in Entra ID
- [ ] Subscription ID recorded
- [ ] Cost alerts created ($10 / $50 / $100)
- [ ] Finalized implementation region confirmed as `norwayeast`

### 5.2 Global IP Addressing Strategy
- [ ] Azure Hub: `10.0.0.0/16`
- [ ] Azure Workload Spoke: `10.10.0.0/16`
- [ ] Azure AVD / optional spoke(s): `10.2.0.0/16`
- [ ] On-prem simulation network: `192.168.1.0/24`
- [ ] AWS branch VPC: `172.16.0.0/16`
- [ ] No CIDR overlap confirmed across all segments

### 5.3 GitHub Setup
- [ ] Repo exists and is reachable
- [ ] Environment `release-2` created in GitHub
- [ ] Branch strategy defined
- [ ] Planned protected branch identified
- [ ] Placeholder secrets list prepared:
  - [ ] `AZURE_CLIENT_ID`
  - [ ] `AZURE_TENANT_ID`
  - [ ] `AZURE_SUBSCRIPTION_ID`
- [ ] Optional local env var plan documented:
  - [ ] `ARM_CLIENT_ID`
  - [ ] `ARM_TENANT_ID`
  - [ ] `ARM_SUBSCRIPTION_ID`

### 5.4 Local / On-Prem Simulation Readiness
- [ ] Hyper-V host available, or alternative local virtualisation platform confirmed
- [ ] VyOS VM planned for on-prem edge simulation
- [ ] VyOS management access method documented
- [ ] VyOS interface plan documented
- [ ] On-prem test VM/DC plan documented
- [ ] Outbound internet connectivity for local lab confirmed
- [ ] Local subnet and gateway assignments documented

### 5.5 AWS Readiness for O3b
- [ ] AWS account available
- [ ] IAM user / access model confirmed
- [ ] Required credentials stored securely
- [ ] AWS free tier / cost guardrails reviewed
- [ ] Teardown expectation documented for AWS ephemeral resources

### 5.6 Entra ID & Service Principal Bootstrap Readiness
- [X] Role capability confirmed for app registration and RBAC assignment
- [X] OIDC app registration naming confirmed
- [X] Subscription scope for Contributor role confirmed
- [X] GitHub repo/environment subject format documented for federated credential


### P2b dependency note
- [x] Azure-connected Linux management host path established
- [x] Private WinRM path to m-dev-client-01 validated
- [x] Role-based Ansible scaffold created
- [x] common role validated with idempotent rerun
- [ ] d-join execution deferred until hq.azawslab.co.uk and hybrid connectivity are ready
### 5.7 Pre-P0 Smoke Test
- [ ] `az account show` returns the correct subscription
- [ ] `terraform init` succeeds in a test directory
- [ ] Repo can be cloned/opened in the intended execution environment
- [ ] Documentation alignment checkpoint completed

**Preparation Gate:**  
Do **not** start P0 until sections 4 and 5 are complete.

---

## 6. Core Phase Tracker (P0–P9c, O1–O5)

| Phase | Name                                           | Depends On | Est. Time | Status | Evidence Path                 | Validation Gate                                                      | Teardown / Cost Action                                         |
| ----- | ---------------------------------------------- | ---------- | --------- | ------ | ----------------------------- | -------------------------------------------------------------------- | -------------------------------------------------------------- |
| P0    | Foundation & OIDC Backend                      | Prep       | 1h        | [x]    | `docs/release2/evidence/P0/`  | OIDC workflow succeeds; backend init succeeds                        | Persistent                                                     |
| P1    | Landing Zone & Management Groups               | P0         | 30m       | [x]    | `docs/release2/evidence/P1/`  | MG hierarchy exists; policy assignments visible                      | Persistent                                                     |
| P2a   | Terraform Reusable Modules                     | P1         | 1h        | [x]    | `docs/release2/evidence/P2a/` | `terraform validate` and `plan` succeed; no public IP on workload VM | Persistent                                                     |
| P2b   | Ansible Configuration Management               | P2a        | 45m       | [~]    | `docs/release2/evidence/P2b/` | management host path works; WinRM path validated; common role succeeds; rerun shows idempotency; AD join deferred until HQ AD and hybrid connectivity are ready | Management host ephemeral; deallocate when not actively needed |
| P2c   | CI/CD Pipeline                                 | P0, P2a    | 45m       | [ ]    | `docs/release2/evidence/P2c/` | PR plan workflow succeeds; merge/apply workflow succeeds             | Persistent                                                     |
| P3    | Enterprise Governance & Guardrails             | P1         | 30m       | [x]    | `docs/release2/evidence/P3/`  | deny policy tested; RBAC verified                                    | Persistent                                                     |
| P4    | Azure Lighthouse                               | P0         | 30m       | [ ]    | `docs/release2/evidence/P4/`  | delegated visibility works cross-tenant                              | Remove if no longer needed                                     |
| P5    | Hub-Spoke Networking                           | P0         | 1h        | [ ]    | `docs/release2/evidence/P5/`  | peering and routing validated                                        | Persistent                                                     |
| P6    | Azure Firewall                                 | P5         | 1h        | [ ]    | `docs/release2/evidence/P6/`  | forced tunneling and block test succeed                              | [E] destroy after validation unless needed for O1              |
| P7    | Defender for Cloud                             | P5         | 30m       | [ ]    | `docs/release2/evidence/P7/`  | plans enabled; recommendations visible                               | Persistent                                                     |
| P8    | Microsoft Sentinel                             | P7         | 45m       | [ ]    | `docs/release2/evidence/P8/`  | incident generation path validated                                   | Persistent                                                     |
| P9a   | Azure Monitor Alerts                           | P7         | 30m       | [ ]    | `docs/release2/evidence/P9a/` | alert rule fires and action group works                              | Persistent                                                     |
| P9b   | Backup / Recovery Services Vault               | P5         | 45m       | [ ]    | `docs/release2/evidence/P9b/` | backup policy and protected item verified                            | Persistent                                                     |
| P9c   | Final Validation & Portfolio Evidence Pack     | P0–P9b     | 1h        | [ ]    | `docs/release2/evidence/P9c/` | all mandatory evidence complete                                      | Persistent                                                     |
| O1    | FortiGate NVA Dual-Firewall Pattern            | P5, P6     | 1h        | [ ]    | `docs/release2/evidence/O1/`  | UDR steering and East-West inspection validated                      | [E] destroy after validation                                   |
| O2    | Azure Arc                                      | P5         | 45m       | [ ]    | `docs/release2/evidence/O2/`  | Arc machine shows connected                                          | Persistent / optional                                          |
| O3a   | FortiGate ↔ VyOS BGP over IPSec                | O1         | 1.5h      | [ ]    | `docs/release2/evidence/O3a/` | BGP session up; routes learned                                       | [E] destroy cloud-side ephemeral assets if not needed          |
| O3b   | AWS Cisco Branch with Segmented BGP            | O3a        | 1.5h      | [ ]    | `docs/release2/evidence/O3b/` | AWS branch routes propagate correctly                                | [E] destroy AWS NVA after validation                           |
| O3c   | Global Transit / Transitive Routing Validation | O3a, O3b   | 1h        | [ ]    | `docs/release2/evidence/O3c/` | end-to-end path validation succeeds                                  | [E] teardown transient routing lab components                  |
| O4    | Entra Global Secure Access                     | P5         | 1h        | [ ]    | `docs/release2/evidence/O4/`  | private access validated; remote network works                       | Optional persistent                                            |
| O5    | Azure Virtual Desktop + FSLogix                | P5         | 1.5h      | [ ]    | `docs/release2/evidence/O5/`  | host pool, profiles, and session validation succeed                  | [E] destroy session hosts after validation if budget-sensitive |

---

## 7. Detailed Phase Control Notes

### P0 – Foundation & OIDC Backend
**Objective:** Establish secretless automation and remote Terraform backend.

**Checklist**
- [X] Create OIDC app/service principal for GitHub Actions
- [X] Assign Contributor at subscription scope
- [X] Create resource group for state backend
- [X] Create storage account for Terraform state
<!-- - [X$$] Create `tfstate` container -->
- [X] Test OIDC GitHub workflow
- [X] Test backend `terraform init`

**Minimum Validation**
- [X] OIDC login succeeds in GitHub Actions
- [X] `terraform init` succeeds against remote backend
- [X] role assignment visible for the workload identity

**Evidence**
- [ ] `oidc-test.txt`
- [ ] `backend-init.txt`
- [ ] `role-assignment.txt`

---

### P1 – Landing Zone & Management Groups
**Objective:** Build the governance scaffold.

**Checklist**
- [ ] Create management groups
- [ ] place subscription under correct management group
- [ ] deploy policy definitions
- [ ] assign policy definitions at correct scope

**Minimum Validation**
- [ ] management group hierarchy visible
- [ ] policy assignments listed successfully
- [ ] non-compliant region deployment test fails

**Evidence**
- [ ] `mg-hierarchy.txt`
- [ ] `policy-assignments.txt`
- [ ] `deny-test-region.txt`

---

### P2a – Terraform Reusable Modules
**Objective:** Build reusable IaC modules with dynamic secrets and private-only compute.

**Checklist**
- [x] module structure created
- [x] security module created
- [x] networking module created
- [x] compute module created
- [ ] monitoring module created if included in the phase scope
- [x] Key Vault integration confirmed
- [x] workload VM deployed without public IP

**Minimum Validation**
- [x] `terraform fmt -check`
- [x] `terraform validate`
- [x] `terraform plan`
- [x] workload NIC has no public IP

**Evidence**
- [ ] `tf-validate.txt`
- [ ] `tf-plan.txt`
- [ ] `vm-validation-norwayeast.txt`

---

### P2b – Ansible Configuration Management
**Objective:** Apply post-deployment configuration and prove idempotent automation.

**Checklist**
- [x] role structure created
- [ ] `common` role created
- [ ] `ad-join` role created
- [ ] `webserver` role created
- [x] inventory created
- [ ] vault strategy documented
- [x] `site.yml` created

**Minimum Validation**
- [ ] `ansible-lint` succeeds
- [x] first playbook run succeeds
- [x] second run shows idempotent behavior
- [ ] domain join verified where applicable (deferred until HQ AD and hybrid connectivity are ready)
- [ ] IIS/content validation completed where applicable

**Evidence**
- [ ] `ansible-lint.txt`
- [ ] `ansible-run-01.txt`
- [ ] `ansible-run-02-idempotent.txt`
- [ ] `domain-join-check.txt`

### P2b management path note
- P2b will be executed from a separate Azure-connected management host in the same Azure subscription
- The management host is treated as an operations-plane resource, not as part of the workload tier
- The workload VM remains private-only
- Separation for P2b is maintained by role, network path, and lifecycle rather than by using a separate subscription
- The management host should be kept minimal and deallocated or destroyed after P2b validation unless needed by the next dependent phase
---

### P2c – CI/CD Pipeline
**Objective:** Enforce PR-based automation using OIDC and GitHub Actions.

**Checklist**
- [ ] OIDC test workflow present
- [ ] Terraform CI workflow present
- [ ] Terraform CD workflow present
- [ ] branch protection configured
- [ ] required checks configured

**Minimum Validation**
- [ ] PR triggers plan workflow
- [ ] plan is visible in PR output
- [ ] merge triggers apply workflow
- [ ] workflow completes successfully

**Evidence**
- [ ] `oidc-workflow-run.txt`
- [ ] `terraform-plan-pr-comment.txt`
- [ ] `terraform-apply-run.txt`
- [ ] `branch-protection-notes.md`

---

### P3 – Enterprise Governance & Guardrails
**Objective:** Enforce data sovereignty, tagging, and cost controls.

**Checklist**
- [ ] allowed locations policy active
- [ ] allowed VM SKU policy active
- [ ] mandatory tags policy active
- [ ] RBAC assignments reviewed

**Minimum Validation**
- [ ] non-approved region test denied
- [ ] disallowed SKU test denied
- [ ] missing tag test denied
- [ ] principal/role assignments verified

**Evidence**
- [ ] `policy-state.txt`
- [ ] `deny-test-region.txt`
- [ ] `deny-test-sku.txt`
- [ ] `deny-test-tags.txt`
- [ ] `rbac-assignments.txt`

---

### P4 – Azure Lighthouse
**Objective:** Demonstrate delegated cross-tenant administration.

**Checklist**
- [ ] registration definition deployed
- [ ] registration assignment deployed
- [ ] delegated access confirmed

**Minimum Validation**
- [ ] delegated resources visible from managing tenant
- [ ] cross-tenant read operation succeeds

**Evidence**
- [ ] `lighthouse-registration.txt`
- [ ] `cross-tenant-visibility.txt`

---

### P5 – Hub-Spoke Networking
**Objective:** Establish core connectivity for all later platform/security phases.

**Checklist**
- [ ] hub VNet deployed
- [ ] spoke VNet(s) deployed
- [ ] subnets created
- [ ] peerings configured
- [ ] NSGs / route tables created where required

**Minimum Validation**
- [ ] peering state is connected
- [ ] route tables associated as designed
- [ ] private connectivity works across intended paths

**Evidence**
- [ ] `vnet-list.txt`
- [ ] `vnet-peering.txt`
- [ ] `route-table-validation.txt`

---

### P6 – Azure Firewall [E]
**Objective:** Validate controlled egress and inspection via Azure Firewall.

**Checklist**
- [ ] Azure Firewall deployed
- [ ] Firewall policy deployed
- [ ] UDR sends `0.0.0.0/0` to Azure Firewall
- [ ] allow/deny rules configured
- [ ] test workload routed through firewall

**Minimum Validation**
- [ ] public egress path confirmed
- [ ] deny rule test succeeds
- [ ] Azure Firewall logs show expected traffic

**Evidence**
- [ ] `firewall-deploy.txt`
- [ ] `udr-validation.txt`
- [ ] `blocked-request-test.txt`
- [ ] `firewall-log-query.txt`

**Teardown**
- [ ] destroy Azure Firewall after validation unless explicitly retained for O1

---

### P7 – Defender for Cloud
**Objective:** Enable cloud security posture visibility.

**Checklist**
- [ ] Defender plans enabled as required
- [ ] recommendations reviewed
- [ ] secure score baseline captured

**Minimum Validation**
- [ ] recommendations visible
- [ ] secure score captured
- [ ] target subscription covered

**Evidence**
- [ ] `defender-plan-status.txt`
- [ ] `secure-score.txt`
- [ ] `recommendations-summary.md`

---

### P8 – Microsoft Sentinel
**Objective:** Establish SIEM ingestion and incident visibility.

**Checklist**
- [ ] Sentinel enabled on workspace
- [ ] required connectors enabled
- [ ] analytic rule deployed or enabled
- [ ] incident generation path tested

**Minimum Validation**
- [ ] data connector healthy
- [ ] analytics rule active
- [ ] incident visible from test condition

**Evidence**
- [ ] `sentinel-enable.txt`
- [ ] `connector-status.txt`
- [ ] `analytics-rule-status.txt`
- [ ] `incident-validation.txt`

---

### P9a – Azure Monitor Alerts
**Objective:** Validate platform alerting and action groups.

**Checklist**
- [ ] action group created
- [ ] alert rule created
- [ ] target resource associated
- [ ] test signal generated if feasible

**Minimum Validation**
- [ ] alert rule enabled
- [ ] action group linked
- [ ] test or actual alert fired successfully

**Evidence**
- [ ] `action-group.txt`
- [ ] `alert-rule.txt`
- [ ] `alert-validation.txt`

---

### P9b – Backup / Recovery Services Vault
**Objective:** Validate backup controls and recovery governance.

**Checklist**
- [ ] Recovery Services Vault deployed
- [ ] backup policy configured
- [ ] protected item registered
- [ ] immutability / protection settings reviewed
- [ ] Resource Guard / MUA configured if in scope

**Minimum Validation**
- [ ] backup item protected
- [ ] policy assigned
- [ ] initial backup state confirmed

**Evidence**
- [ ] `rsv-deploy.txt`
- [ ] `backup-policy.txt`
- [ ] `protected-item-status.txt`

---

### P9c – Final Validation & Portfolio Evidence Pack
**Objective:** Close the loop on implementation quality and portfolio readiness.

**Checklist**
- [ ] all mandatory phases reviewed
- [ ] all evidence paths populated
- [ ] all stale notes removed
- [ ] teardown completed for ephemeral phases
- [ ] README navigation checked
- [ ] recruiter-facing summary notes prepared

**Minimum Validation**
- [ ] no mandatory evidence gaps remain
- [ ] no unintended costly resources remain
- [ ] documentation links resolve correctly

**Evidence**
- [ ] `phase-completion-summary.md`
- [ ] `resource-final-state.txt`
- [ ] `cost-review.txt`

---

## 8. Optional Advanced Phases

### O1 – FortiGate NVA Dual-Firewall Pattern [E][O]
- [ ] FortiGate deployed
- [ ] East-West / hybrid UDRs configured
- [ ] traffic separation from Azure Firewall validated
- [ ] validation evidence captured
- [ ] teardown completed after validation

### O2 – Azure Arc [O]
- [ ] Arc agent deployed to target machine
- [ ] machine appears in Azure
- [ ] tags/policy/management visibility confirmed

### O3a – FortiGate ↔ VyOS BGP over IPSec [E][O]
- [ ] VyOS prepared locally
- [ ] IPSec tunnel established
- [ ] BGP peering established
- [ ] route learning verified
- [ ] validation evidence captured
- [ ] cloud-side ephemeral assets destroyed when no longer required

### O3b – AWS Cisco Branch with Segmented BGP [E][O]
- [ ] AWS branch VPC created
- [ ] Cisco NVA deployed
- [ ] IPSec/BGP to Azure path established
- [ ] branch segmentation validated
- [ ] teardown completed after validation

### O3c – Global Transit / Transitive Routing Validation [E][O]
- [ ] end-to-end route propagation verified
- [ ] path tests completed
- [ ] packet path notes saved
- [ ] transit lab resources torn down after validation

### O4 – Entra Global Secure Access [O]
- [ ] remote network configured
- [ ] connector/dependency setup completed
- [ ] private access policy validated
- [ ] legacy VPN replacement narrative documented

### O5 – Azure Virtual Desktop + FSLogix [E][O]
- [ ] host pool created
- [ ] workspace created
- [ ] app group configured
- [ ] FSLogix storage configured
- [ ] user session validation completed
- [ ] teardown plan completed for session hosts if cost-sensitive

---

## 9. Evidence Directory Template

```text
docs/
`-- release2/
    `-- evidence/
        |-- P0/
        |-- P1/
        |-- P2a/
        |-- P2b/
        |-- P2c/
        |-- P3/
        |-- P4/
        |-- P5/
        |-- P6/
        |-- P7/
        |-- P8/
        |-- P9a/
        |-- P9b/
        |-- P9c/
        |-- O1/
        |-- O2/
        |-- O3a/
        |-- O3b/
        |-- O3c/
        |-- O4/
        `-- O5/
```

---

## 10. Blocker Log

Use this section during execution.

| Date   | Phase   | Blocker          | Impact         | Action Taken | Status        |
| ------ | ------- | ---------------- | -------------- | ------------ | ------------- |
| [Date] | [Phase] | [Describe issue] | [Low/Med/High] | [Mitigation] | [Open/Closed] |

---

## 11. Change Log

| Date   | Change                                                | Reason                                                                         |
| ------ | ----------------------------------------------------- | ------------------------------------------------------------------------------ |
| [Date] | Initial rewritten tracker aligned to `README_PLAN.md` | Removed stale RRAS path, restructured prep flow, strengthened validation gates |

---

## 12. Final Completion Review

### Mandatory Completion Gate
- [ ] P0 complete
- [ ] P1 complete
- [ ] P2a complete
- [ ] P2b complete
- [ ] P2c complete
- [ ] P3 complete
- [ ] P5 complete
- [ ] P7 complete
- [ ] P8 complete
- [ ] P9a complete
- [ ] P9b complete
- [ ] P9c complete

### Optional Completion Gate
- [ ] P4 complete if included
- [ ] P6 complete if included
- [ ] O1 complete if included
- [ ] O2 complete if included
- [ ] O3a complete if included
- [ ] O3b complete if included
- [ ] O3c complete if included
- [ ] O4 complete if included
- [ ] O5 complete if included

### Final Operational Checks
- [ ] No stale RRAS references remain in Release 2 docs
- [ ] No unintended public IPs remain on workload VMs
- [ ] No unnecessary high-cost resources remain running
- [ ] Evidence folders are populated and readable
- [ ] Repo docs correctly reference the final file names
- [ ] Recruiter-facing summary points extracted from validated work

---

## 13. Sign-Off

**Release 2 Execution Status:**  
- [ ] Planning only
- [ ] Pre-execution ready
- [ ] Core build in progress
- [ ] Core build complete
- [ ] Optional validation in progress
- [ ] Fully validated and portfolio-ready

**Signed off by:** HASHIBUR RAHMAN 
**Date:** 29-April-2026
---

## P1 Closure Update

Status: Complete

Completed outcomes:
- Management groups created:
  - mg-platform-prod-global
  - mg-landingzones-prod-global
  - mg-sandbox-prod-global
- Subscription moved under mg-landingzones-prod-global
- Governance baseline implemented through Terraform policy assignments
- Total active policy assignments: 7
  - pa-loc-prod-norwayeast
  - pa-rgloc-prod-norwayeast
  - pa-vmsku-prod-b2alsv2
  - pa-tag-env
  - pa-tag-proj
  - pa-tag-own
  - pa-tag-cost
- Azure-side policy assignment verification completed
- Resource-group location deny test succeeded for a non-approved region

Notes:
- Governance-plane work was executed under the break-glass account due to management-group scope permissions.
- P1 evidence is captured in docs/release2/evidence/P1/p1-evidence.txt
- P1 raw execution history is captured in docs/release2/evidence/P1/p1-execution-log.txt

### P2a completion note
- Region and VM SKU were confirmed after subscription-and-region deployability validation
- Implemented region: `norwayeast`
- Implemented VM SKU: `Standard_B2als_v2`
- Policy alignment:
  - `pa-loc-prod-norwayeast`
  - `pa-rgloc-prod-norwayeast`
  - `pa-vmsku-prod-b2alsv2`
- Implemented resource pattern:
  - `rg-dev-security-norwayeast`
  - `rg-dev-workload-norwayeast`
  - `vnet-dev-norwayeast-spoke-workload`
  - `nic-vm-dev-client-01-01`
  - `vm-dev-client-01`
  - `kvdevazawsne01`
- Private-only workload outcome confirmed:
  - VM running in Norway East
  - NIC private IP `10.10.0.4`
  - no public IP returned in CLI validation
- Phase P2a is complete from an implementation and validation perspective
### P2a terraform state boundary refinement
- Terraform module reuse model was retained
- Terraform root/state ownership was separated to align lifecycle boundaries
- Active Terraform roots are now:
  - `terraform/governance`
  - `terraform/platform-shared/dev`
  - `terraform/workloads/dev`
- Governance policy assignments are now managed from `terraform/governance`
- Shared security resources are now managed from `terraform/platform-shared/dev`
- Workload networking and compute are now managed from `terraform/workloads/dev`
- This refinement was implemented to reduce destroy risk and isolate operational lifecycles without changing the underlying Release 2 design

---

## P3 Completion Note - Enterprise Governance & Guardrails

**Completed:** 2026-05-04 17:25:13
**Status:** Completed and validated

### Validation completed
- Governance policy assignments reviewed at `mg-landingzones-prod-global`.
- RBAC reviewed for key Release 2 principals.
- `sp-terraform-gh` confirmed with Contributor at subscription scope for GitHub Actions OIDC-based Terraform deployment.
- Region/resource group location deny behavior validated with `eastus` resource group creation attempt.
- Mandatory resource group tag deny behavior initially failed, was diagnosed, corrected in Terraform, deployed through GitHub Actions controlled apply, and retested successfully.
- Disallowed VM SKU deny behavior validated with attempted `Standard_B1s` VM creation.
- Temporary validation resources were confirmed not created or deleted after testing.

### Evidence
- `docs/release2/evidence/P3/p3-execution-log.txt`
- `docs/release2/evidence/P3/p3-evidence.txt`
- `docs/release2/evidence/P3/p3-deny-test-rg-location-eastus.txt`
- `docs/release2/evidence/P3/p3-deny-test-rg-missing-tags.txt`
- `docs/release2/evidence/P3/p3-deny-retest-rg-missing-tags-after-fix.txt`
- `docs/release2/evidence/P3/p3-deny-test-vm-sku.txt`
- `docs/release2/evidence/P3/p3-current-tag-policy-assignment-review.txt`
- `docs/release2/evidence/P3/p3-tag-policy-definition-discovery.txt`

### Result
P3 governance guardrails are validated for allowed region, mandatory tags, VM SKU restriction, RBAC review, and controlled Terraform deployment.

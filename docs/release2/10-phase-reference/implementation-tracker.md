# Implementation Tracker â€" Release 2 (Azure Platform Engineering & Security)

<!-- portfolio-source-truth:start -->

## Portfolio Migration Source-Truth Note

This note is the source-truth lock for portfolio migration.

- Final branch namespace is br1.azawslab.co.uk.
- A2 AWX automation control plane is complete and evidenced.
- O4 Private AKS is complete.
- O5 AVD + FSLogix is complete.
- O6 is the remaining Release 2 closeout / AI Operations Enclave work.
- Release 3 direction is AKS + EKS + Argo CD + DevSecOps.
- If older sections conflict with this note, use STATUS.md and update the stale section during the migration.
- Files with mojibake/encoding artifacts should not be used as final public prose until cleaned.

<!-- portfolio-source-truth:end -->

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
- `README_PLAN.md` â€" authoritative phase design and detailed implementation logic
- `Phases-with-steps.md` â€" step execution support
- `naming-conventions.md` â€" naming and tagging standards
- `architechture.md` â€" architecture decisions and rationale
- `build_checklist.md` â€" execution checklist once finalised

---

## 2. Status Legend

| Symbol | Meaning                                                                    |
| ------ | -------------------------------------------------------------------------- |
| [ ]    | Not started                                                                |
| [~]    | In progress                                                                |
| [x]    | Completed and validated                                                    |
| [!]    | Blocked                                                                    |
| [E]    | Ephemeral â€" destroy after validation |
| [O]    | Optional phase                                                             |

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

## 6. Core Phase Tracker (P0â€"P9c, O1â€"O5)

| Phase | Name                                                | Depends On                                   | Est. Time | Status | Evidence Path                 | Validation Gate                                                                                                                                                 | Teardown / Cost Action                                                      |
| ----- | --------------------------------------------------- | -------------------------------------------- | --------- | ------ | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| P0    | Foundation & OIDC Backend                           | Prep                                         | 1h        | [x]    | `docs/release2/evidence/P0/`  | OIDC workflow succeeds; backend init succeeds                                                                                                                   | Persistent                                                                  |
| P1    | Landing Zone & Management Groups                    | P0                                           | 30m       | [x]    | `docs/release2/evidence/P1/`  | MG hierarchy exists; policy assignments visible                                                                                                                 | Persistent                                                                  |
| P2a   | Terraform Reusable Modules                          | P1                                           | 1h        | [x]    | `docs/release2/evidence/P2a/` | `terraform validate` and `plan` succeed; no public IP on workload VM                                                                                            | Persistent                                                                  |
| P2b   | Ansible Configuration Management                    | P2a                                          | 45m       | [x]    | `docs/release2/evidence/P2b/` | management host path works; WinRM path validated; common role succeeds; rerun shows idempotency; AD join deferred until HQ AD and hybrid connectivity are ready | Management host ephemeral; deallocate when not actively needed              |
| P2c   | CI/CD Pipeline                                      | P0, P2a                                      | 45m       | [ ]    | `docs/release2/evidence/P2c/` | PR plan workflow succeeds; merge/apply workflow succeeds                                                                                                        | Persistent                                                                  |
| P3    | Enterprise Governance & Guardrails                  | P1                                           | 30m       | [x]    | `docs/release2/evidence/P3/`  | deny policy tested; RBAC verified                                                                                                                               | Persistent                                                                  |
| P4    | Azure Lighthouse                                    | P0                                           | 30m       | [x]    | `docs/release2/evidence/P4/`  | delegated Reader visibility works cross-tenant                                                                                                                  | Persistent until later teardown decision                                    |
| P5    | Hub-Spoke Networking                                | P0                                           | 1h        | [x]    | `docs/release2/evidence/P5/`  | peering and routing validated                                                                                                                                   | Persistent                                                                  |
| P6    | Azure Firewall                                      | P5                                           | 1h        | [x]    | `docs/release2/evidence/P6/`  | Firewall deployed; forced-tunneling route and workload egress validated; teardown complete                                                                      | [E] destroyed after validation                                              |
| P7    | Defender for Cloud                                  | P5                                           | 30m       | [~]    | `docs/release2/evidence/P7/`  | security contact deployed; secure score and recommendations captured; post-change review pending                                                                | Persistent                                                                  |
| P8    | Microsoft Sentinel                                  | P7                                           | 45m       | [ ]    | `docs/release2/evidence/P8/`  | incident generation path validated                                                                                                                              | Persistent                                                                  |
| P9a   | Azure Monitor Alerts                                | P7                                           | 30m       | [ ]    | `docs/release2/evidence/P9a/` | alert rule fires and action group works                                                                                                                         | Persistent                                                                  |
| P9b   | Backup / Recovery Services Vault                    | P5                                           | 45m       | [ ]    | `docs/release2/evidence/P9b/` | backup policy and protected item verified                                                                                                                       | Persistent                                                                  |
| P9c   | Final Validation & Portfolio Evidence Pack          | P0â€"P9b | 1h        | [ ]    | `docs/release2/evidence/P9c/` | all mandatory evidence complete                                                                                                                                 | Persistent                                                                  |
| O1    | FortiGate Azure-to-HQ Service-Chaining / Inspection | P5, O3a                                      | 1h        | [x]    | `docs/release2/evidence/O1/`  | Azure workload to HQ traffic validated through FortiGate policy 1 with SNAT lab delta                                                                           | Retain only while dependent hybrid validation needs FortiGate/VPN resources |
| O2    | Azure Arc                                           | P5                                           | 45m       | [ ]    | `docs/release2/evidence/O2/`  | Arc machine shows connected                                                                                                                                     | Persistent / optional                                                       |
| O3a   | Azure VPN Gateway to VyOS Hybrid Connectivity       | P5                                           | 1.5h      | [x]    | `docs/release2/evidence/O3a/` | VPN connected; AES256/SHA256/DHGroup14/PFS14 validated; workload reaches VyOS LAN gateway                                                                       | Retain only while O1/O3 service-chaining validation depends on it           |
| O3b   | AWS Cisco Branch with Segmented BGP                 | O3a                                          | 1.5h      | [ ]    | `docs/release2/evidence/O3b/` | AWS branch routes propagate correctly                                                                                                                           | [E] destroy AWS NVA after validation                                        |
| O3c   | Global Transit / Transitive Routing Validation      | O3a, O3b                                     | 1h        | [ ]    | `docs/release2/evidence/O3c/` | end-to-end path validation succeeds                                                                                                                             | [E] teardown transient routing lab components                               |
| O4    | Entra Global Secure Access                          | P5                                           | 1h        | [ ]    | `docs/release2/evidence/O4/`  | private access validated; remote network works                                                                                                                  | Optional persistent                                                         |
| O5    | Azure Virtual Desktop + FSLogix                     | P5                                           | 1.5h      | [ ]    | `docs/release2/evidence/O5/`  | host pool, profiles, and session validation succeed                                                                                                             | [E] destroy session hosts after validation if budget-sensitive              |

---

## 7. Detailed Phase Control Notes

### P0 â€" Foundation & OIDC Backend
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

### P1 â€" Landing Zone & Management Groups
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

### P2a â€" Terraform Reusable Modules
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

### P2b â€" Ansible Configuration Management
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
- [x] domain join verified where applicable: Windows workload and HQ Linux host completed
- [x] IIS/Apache content validation completed where applicable

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

### P2c â€" CI/CD Pipeline
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

### P3 â€" Enterprise Governance & Guardrails
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

### P4 â€" Azure Lighthouse
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

### P5 â€" Hub-Spoke Networking
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

### P6 â€" Azure Firewall [E]
**Objective:** Validate controlled egress and inspection via Azure Firewall.

**P6 deployment note:** Azure Firewall was deployed through GitHub Actions controlled Terraform Apply after correcting the Firewall SKU from Basic to Standard. Basic failed because it requires a management IP configuration and `AzureFirewallManagementSubnet`; the current P5 hub design uses `AzureFirewallSubnet` only. The active firewall is intentionally ephemeral and must be disabled after validation evidence is complete.

**Checklist**
- [x] Azure Firewall deployed
- [x] Firewall policy deployed
- [x] UDR sends `0.0.0.0/0` to Azure Firewall
- [x] allow rules configured; deny/log validation still pending
- [x] test workload routed through firewall

**Minimum Validation**
- [x] public egress path confirmed
- [x] social-media block test succeeded
- [~] Azure Firewall log validation deferred; diagnostics were not enabled for ephemeral P6 deployment

**Evidence**
- [x] `p6-firewall-post-apply-validation.txt`
- [x] `p6-firewall-post-apply-validation.txt`
- [x] `p6-workload-egress-test.txt`
- [~] `p6-firewall-diagnostics-check.txt`

**Teardown**
- [x] destroy Azure Firewall after validation unless explicitly retained for O1

---

### P7 â€" Defender for Cloud
**Objective:** Validate Microsoft Defender for Cloud / CSPM visibility and implement a low-cost security posture improvement.

**Checklist**
- [x] Defender for Cloud readiness baseline captured
- [x] Microsoft.Security provider registration validated
- [x] Defender pricing plan status captured
- [x] Secure Score baseline captured
- [x] Defender recommendations captured
- [x] Defender security contact deployed through Terraform
- [ ] post-change recommendations / Secure Score review captured

**Minimum Validation**
- [x] Defender plan data visible
- [x] recommendations visible
- [x] secure score captured
- [x] security contact exists in Terraform state and Azure
- [ ] post-change Defender recommendation status reviewed

**Evidence**
- [x] `p7-readiness-current-state.txt`
- [x] `defender-plan-status.txt`
- [x] `secure-score.txt`
- [x] `recommendations-summary.md`
- [x] `p7-platform-shared-plan.txt`
- [x] `p7-defender-security-contact-validation.txt`

**Cost / FinOps**
- [x] No paid Defender workload plan enabled during this step
- [x] M365 E5 licensing context noted separately from Azure Defender pricing state

---

### P8 â€" Microsoft Sentinel
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

### P9a â€" Azure Monitor Alerts
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

### P9b â€" Backup / Recovery Services Vault
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

### P9c â€" Final Validation & Portfolio Evidence Pack
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

### O1 â€" FortiGate NVA Dual-Firewall Pattern [E][O]
- [x] FortiGate deployed
- [ ] East-West / hybrid UDRs configured
- [ ] traffic separation from Azure Firewall validated
- [ ] validation evidence captured
- [ ] teardown completed after validation

### O2 â€" Azure Arc [O]
- [ ] Arc agent deployed to target machine
- [ ] machine appears in Azure
- [ ] tags/policy/management visibility confirmed

### O3a â€" Azure VPN Gateway to VyOS Hybrid Connectivity [E][O]
- [x] VyOS prepared locally
- [ ] IPSec tunnel established
- [ ] BGP peering established
- [ ] route learning verified
- [ ] validation evidence captured
- [ ] cloud-side ephemeral assets destroyed when no longer required

### O3b â€" AWS Cisco Branch with Segmented BGP [E][O]
- [ ] AWS branch VPC created
- [ ] Cisco NVA deployed
- [ ] IPSec/BGP to Azure path established
- [ ] branch segmentation validated
- [ ] teardown completed after validation

### O3c â€" Global Transit / Transitive Routing Validation [E][O]
- [ ] end-to-end route propagation verified
- [ ] path tests completed
- [ ] packet path notes saved
- [ ] transit lab resources torn down after validation

### O4 â€" Entra Global Secure Access [O]
- [ ] remote network configured
- [ ] connector/dependency setup completed
- [ ] private access policy validated
- [ ] legacy VPN replacement narrative documented

### O5 â€" Azure Virtual Desktop + FSLogix [E][O]
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

| Date       | Change                                                | Reason                                                                                                                                                |
| ---------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Date]     | Initial rewritten tracker aligned to `README_PLAN.md` | Removed stale RRAS path, restructured prep flow, strengthened validation gates                                                                        |
| 2026-05-04 | P4 Azure Lighthouse Reader delegation completed       | Registration definition and assignment deployed; customer subscription visible from managing tenant via Reader delegation                             |
| 2026-05-04 | P5 Hub-Spoke Networking completed                     | Platform-networking root deployed hub VNet, reserved hub subnets, bidirectional peering, and workload route-table association                         |
| 2026-05-05 | Platform management state split completed             | Temporary Ansible management host moved from workload-dev state to dedicated platform-management-dev state with no Azure resource destroy or recreate |

---

## 12. Final Completion Review

### Mandatory Completion Gate
- [ ] P0 complete
- [ ] P1 complete
- [ ] P2a complete
- [x] P2b complete
- [ ] P2c complete
- [ ] P3 complete
- [x] P5 complete
- [ ] P7 complete
- [ ] P8 complete
- [ ] P9a complete
- [ ] P9b complete
- [ ] P9c complete

### Optional Completion Gate
- [x] P4 complete if included
- [x] P6 complete if included
- [x] O1 complete if included
- [ ] O2 complete if included - no Azure Arc/O2 evidence captured yet
- [x] O3a complete if included
- [ ] O3b complete if included
- [ ] O3c complete if included
- [x] O4 complete if included - previously validated; resources currently destroyed for cost control
- [x] O5 complete if included - previously validated; resources currently destroyed for cost control

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




### Post-P5 platform-management state split

**Objective:** Separate temporary operations-plane management resources from workload infrastructure state.

**Completed outcome**
- [x] Created `terraform/platform-management/dev`
- [x] Created dedicated backend key `platform-management-dev.tfstate`
- [x] Imported existing management resources into platform-management state:
  - `azurerm_resource_group.management`
  - `azurerm_public_ip.management`
  - `azurerm_network_interface.management`
  - `azurerm_linux_virtual_machine.management`
- [x] Removed management resources from `workload-dev.tfstate`
- [x] Removed management resource blocks from `terraform/workloads/dev/main.tf`
- [x] Validated `workload-dev` plan: no changes
- [x] Validated `platform-management-dev` plan: no changes
- [x] Updated GitHub Actions Terraform workflow matrix to include `platform-management-dev`

**Evidence**
- `docs/release2/evidence/platform-management-state-split/platform-management-state-split-audit.txt`
- `docs/release2/evidence/platform-management-state-split/platform-management-state-split-plan.txt`
- `docs/release2/evidence/platform-management-state-split/platform-management-state-split-validation.txt`
- `docs/release2/evidence/platform-management-state-split/state-backups/`

**Architecture note**
The temporary Ansible management host is now owned by the platform management state boundary rather than the workload state boundary. This better reflects its role as an operations-plane control node, not a workload-tier resource.




### P5 Ephemeral Bastion validation update

Date: 2026-05-05 20:55:24 +01:00

P5 secure administration validation was strengthened with an ephemeral Azure Bastion validation window.

Validated:
- Azure Bastion was enabled through the controlled GitHub Actions Terraform workflow.
- `vm-dev-client-01` was started temporarily for validation.
- `vm-dev-client-01` remained private-only with no public IP.
- Private RDP access through Azure Bastion was validated.
- Screenshot evidence and CLI/text evidence were captured under `docs/release2/evidence/P5/`.
- The workload VM was deallocated after validation.
- Bastion is being disabled again to restore the cost-safe state.

Evidence:
- `docs/release2/evidence/P5/p5-github-actions-bastion-enable-apply-success.png`
- `docs/release2/evidence/P5/p5-bastion-private-rdp-session-access.png`
- `docs/release2/evidence/P5/p5-bastion-private-rdp-session-validation.png`
- `docs/release2/evidence/P5/p5-ephemeral-bastion-validation.txt`
- `docs/release2/evidence/P5/p5-ephemeral-bastion-enable-plan.txt`
- `docs/release2/evidence/P5/p5-ephemeral-bastion-disable-plan.txt`

Current FinOps action:
- Bastion disablement is pending GitHub Actions apply from the follow-up disable commit.

### P8 Microsoft Sentinel implementation update

Date: 2026-05-05 22:32:34 +01:00

P8 Microsoft Sentinel deployment was completed through the controlled GitHub Actions Terraform Apply workflow.

Completed:
- Monitoring resource group created: `rg-dev-monitoring-norwayeast`
- Log Analytics workspace created: `law-dev-platform-norwayeast`
- Microsoft Sentinel onboarding completed
- Sentinel scheduled analytic rule deployed:
  - `rule-p8-azure-activity-write-delete`
- Subscription diagnostic setting configured for Azure Activity ingestion
- Terraform outputs confirmed Sentinel onboarding and analytic rule IDs
- Defender portal workspace connection was completed manually after Terraform onboarding
- Required governance tags were confirmed on the Log Analytics workspace
- A narrow RG-scoped policy exemption was created for Sentinel onboarding child resources that are not taggable through the current Terraform provider resource

Evidence:
- `docs/release2/evidence/P8/p8-sentinel-enabled-plan.txt`
- `docs/release2/evidence/P8/p8-sentinel-policy-exemptions-rg-scope.txt`
- `docs/release2/evidence/P8/p8-sentinel-post-apply-validation.txt`

Status:
- P8 deployment: completed
- P8 post-apply validation: completed
- Incident generation path: pending if required for final P8 closeout

### P9a Azure Monitor Alerts completion update

Date: 2026-05-06 00:59:25 +01:00

P9a Azure Monitor alerting was deployed and validated.

Completed:
- Azure Monitor Action Group created: `ag-p9a-platform-ops`
- Action group membership email received
- VM CPU metric alert created: `alert-p9a-vm-cpu-high`
- Alert target configured for `vm-dev-client-01`
- Metric namespace: `Microsoft.Compute/virtualMachines`
- Metric name: `Percentage CPU`
- Controlled CPU load generated on `vm-dev-client-01`
- Alert fired successfully and was captured in Azure Portal
- Azure Monitor alert notification email was received
- VM was deallocated after validation

Evidence:
- `docs/release2/evidence/P9a/p9a-monitor-alerts-enabled-plan.txt`
- `docs/release2/evidence/P9a/p9a-monitor-alerts-post-apply-validation.txt`
- `docs/release2/evidence/P9a/p9a-monitor-alerts-alert-test.txt`
- `docs/release2/evidence/P9a/p9a-cpu-stress-test.ps1`
- `docs/release2/evidence/P9a/p9a-action-group-membership-email-validation.png`
- `docs/release2/evidence/P9a/p9a-action-group-alert-email-notification.png`
- `docs/release2/evidence/P9a/p9a-alert-fired-portal-validation.png`

Status:
- P9a deployment: completed
- P9a alert firing validation: completed
- P9a action group email notification validation: completed



### Current P5/O3a Hybrid Design Note

The active validated hybrid design is Azure VPN Gateway to VyOS IPSec, with FortiGate retained for inspection and service chaining.

```text
Azure VPN Gateway:
  connectivity plane and IPSec termination

FortiGate:
  inspection plane and future service-chain validation

VyOS:
  HQ/on-prem edge simulation
```

The previous direct FortiGate-to-VyOS IPSec objective is retained only as design history and lab-delta context. It is not the current active implementation path.




### O1 Closeout â€" FortiGate Azure-to-HQ Service Chaining

O1 is validated for the Azure workload to HQ direction.

Validated path:

```text
10.10.0.4
  -> workload UDR for 192.168.1.0/24
  -> FortiGate port2 / 10.0.3.36
  -> FortiGate policy ID 1
  -> SNAT to 10.0.3.4
  -> FortiGate port1
  -> Azure VPN Gateway
  -> VyOS / 192.168.1.254
  -> reply through FortiGate back to 10.10.0.4
```

Evidence confirms:
- effective route to `192.168.1.0/24` via `10.0.3.36`
- FortiGate debug flow `Allowed by Policy-1: SNAT`
- FortiGate SNAT `10.10.0.4 -> 10.0.3.4`
- VyOS tcpdump saw requests from `10.0.3.4` and replies to `10.0.3.4`
- FortiGate sniffer showed the four-leg request/reply path

This does not yet claim HQ-initiated inspection toward Azure workloads. That remains a later routing and enterprise-design decision.


---

## Update - P2b Ansible AD Join, IIS, and Key Vault Runtime Secrets

Status: Completed for current Windows workload scope.

Completed:
- vm-dev-mgmt-01 is the private Ansible control node.
- Ansible connects to vm-dev-client-01 over private WinRM.
- Windows local admin password is sourced from Key Vault at runtime using the management VM managed identity.
- Domain join password is sourced from Key Vault at runtime using the management VM managed identity.
- vm-dev-client-01 is joined to hq.azawslab.co.uk.
- Computer object is placed in OU=Workstations,OU=AzawsLab,DC=hq,DC=azawslab,DC=co,DC=uk.
- IIS is installed by Ansible and serves the Release 2 validation page.

Evidence:
- docs/release2/evidence/P2b/p2b-ansible-keyvault-ad-iis-validation.txt

## Update - P5 FortiGate HQ-to-Azure Symmetry Validation

Status: Validated manually; Terraform reconciliation required.

Completed:
- FortiGate policies were consolidated into a clean two-policy baseline.
- Azure-to-HQ policy handles Windows AD, PING, and NTP.
- HQ-to-Azure policy handles HTTP, HTTPS, and PING.
- Root cause of DC1-to-workload failure was identified as asymmetric routing.
- GatewaySubnet UDR was manually validated to steer 10.10.0.0/24 ingress through FortiGate port1, then reconciled into terraform/platform-networking/dev and applied through the normal GitHub Actions Terraform workflow.

Open follow-up:
- GatewaySubnet route table and route reconciled into terraform/platform-networking/dev.
- P5/O1/O3a hybrid service-chain path is validated and IaC-aligned for the current O1/P2b scope.

Evidence:
- docs/release2/evidence/P5-vpn/p5-fortigate-gateway-ingress-symmetry-validation.txt

## Update - P2b Linux AD Join, Apache, and Delegated Service Account

Final P2b Linux configuration management validation is complete.

Implemented final state:
- `vm-dev-mgmt-01` remains the private Ansible control node.
- `hq-linux-vm01` at `192.168.1.30` is joined to `hq.azawslab.co.uk`.
- DC1 confirms the computer object:
  `CN=HQ-LINUX-VM01,OU=Linux,OU=AzawsLab,DC=hq,DC=azawslab,DC=co,DC=uk`
- Linux AD join uses `svc.ansible` as the delegated domain-join account.
- `svc.ansible` is a member of `azw-hq-ansible-operators`.
- `azw-hq-ansible-operators` has Linux OU-scoped computer-join delegation.
- Linux SSH/sudo access uses local account `hq-admin`.
- Runtime secrets are retrieved from Key Vault by `vm-dev-mgmt-01` managed identity.
- No plaintext secrets are stored in inventory.
- No root login was used.
- No passwordless sudo was used.
- `sssd` is active.
- `apache2` is active and returns `HTTP/1.1 200 OK`.

Evidence:
- `docs/release2/evidence/P2b/p2b-linux-ad-join-validation.txt`
- `docs/release2/evidence/P2b/p2b-dc1-delegate-linux-ou-computer-join-rights.ps1`

## Update - P5/O1/O3a Hybrid Inspection Closeout

P5/O1/O3a status has been aligned with the final validated hybrid inspection state.

Closed scope:
- P5 hub-spoke networking foundation remains complete.
- O3a Azure VPN Gateway to VyOS IPSec connectivity is complete.
- O1 FortiGate service chaining is complete for the current Azure workload and HQ scope.
- HQ/DC1-to-Azure workload symmetry was corrected using a targeted GatewaySubnet UDR for `10.10.0.0/24` via FortiGate port1 `10.0.3.4`.
- FortiGate policy baseline is consolidated into two directional policies.
- GatewaySubnet UDR was manually validated, then reconciled into Terraform and applied through the normal GitHub Actions workflow.

O2 / Azure Arc remains open because no O2/Arc evidence exists in the repository.

Evidence:
- `docs/release2/evidence/P5-vpn/p5-o1-o3a-closeout-summary.md`
- `docs/release2/evidence/P5-vpn/p5-o3a-fortigate-stage1-validation.txt`
- `docs/release2/evidence/P5-vpn/p5-o3a-azure-vpngw-vyos-data-plane-validation.txt`
- `docs/release2/evidence/P5-vpn/firewall-policy-current-post-gateway-udr.json`
- `docs/release2/evidence/P5-vpn/p5-fortigate-gateway-ingress-symmetry-validation.txt`



### O2 Azure Arc MEM1 Closeout

O2 was completed using MEM1 as the first Azure Arc-enabled server target.

Validated state:
- Target: `mem1.hq.azawslab.co.uk`
- IP: `192.168.1.20`
- Arc resource name: `mem1`
- Resource group: `rg-dev-arc-norwayeast`
- Location: `norwayeast`
- Agent version: `1.63.03384.2896`
- Azure-side status: `Connected`
- Provisioning state: `Succeeded`

Design notes:
- MEM1 was selected instead of DC1 to avoid using a sensitive domain controller as the first Arc target.
- MEM1 egress uses the HQ/VyOS path.
- The scoped onboarding service principal remains limited to Azure Connected Machine Onboarding on `rg-dev-arc-norwayeast`.
- Mandatory governance tags were applied during onboarding: `Environment`, `Project`, `Owner`, and `CostCenter`.

Evidence:
- `docs/release2/evidence/O2/o2-mem1-vyos-gateway-arc-preflight.txt`
- `docs/release2/evidence/O2/o2-arc-onboarding-identity-bootstrap.txt`
- `docs/release2/evidence/O2/o2-mem1-arc-connect-console.txt`
- `docs/release2/evidence/O2/o2-mem1-arc-azure-validation.txt`



### O3b/O3c Architecture Alignment Note

O3b and O3c follow the validated P5/O1/O3a design.

```text
Azure VPN Gateway:
  IPSec/BGP transit hub for external peers.

FortiGate:
  Azure-side inspection and service-chaining plane.

VyOS:
  HQ/on-prem edge.

Cisco 8000V:
  AWS branch/customer router.
```

O3b validates Cisco 8000V in AWS peering with Azure VPN Gateway using IPSec/BGP. O3c validates transitive routing between Azure, HQ, and AWS. FortiGate inspection is only claimed where FortiGate policy counters or logs prove traversal.


### O3b Selective BGP Validation Requirement

O3b must validate segmented BGP route control.

Required O3b behavior:
- Cisco 8000V advertises `172.16.1.0/24` trusted subnet.
- Cisco 8000V does not advertise `172.16.2.0/24` DMZ subnet.
- Azure VPN Gateway learns the trusted AWS prefix through BGP.
- Azure VPN Gateway does not learn the DMZ prefix during the first segmented validation.
- Trusted Linux VM validates the positive route path.
- DMZ Linux VM validates the intentionally non-propagated route path.

Do not mark O3b complete if only full VPC summary propagation is tested.


### O5 Secure Admin and Dev Workspace Alignment

O5 is aligned as a secure admin and development workspace using Azure Virtual Desktop and FSLogix.

Required validation:
- AVD host pool, workspace, and desktop application group deployed.
- Session host access works through AVD.
- FSLogix profile container mounts through Azure Files private endpoint path.
- Profile persistence validates across logoff/logon.
- AVD egress follows Azure Firewall where enabled.
- AVD-to-HQ private path follows approved hybrid routing.
- FortiGate inspection is claimed only where counters/logs prove traversal.
- Admin/dev toolchain validates: Azure CLI, kubectl, Helm, Git, VS Code, Docker CLI or approved container tooling.
- AKS validation is conditional on AKS existence.

Do not mark O5 complete based only on AVD host pool creation. O5 is complete only when workspace access, profile persistence, routing, and tooling validation are proven.


### O4/O5 Serial Alignment

The active serial order is:

```text
O4 first:
  Private AKS modern app platform using existing management host as the first private control point.

O5 later:
  AVD + FSLogix secure admin/dev workspace for a polished operator experience.
```

Rationale:
- O4 can be implemented using the existing Azure-connected management host.
- O5 adds useful operator experience but is not required before private AKS.
- Entra Global Secure Access / ZTNA is deferred as a future access-modernization enhancement.


### O4 Modern App Platform Alignment

O4 is now scoped as a private AKS modern application platform.

Design:
- private AKS cluster
- Azure CNI or Azure CNI Overlay after final IP capacity check
- AKS subnet `10.10.2.0/24`
- outbound type `userDefinedRouting`
- Azure Firewall for cloud-native egress
- FortiGate for hybrid/private path inspection where intentionally service-chained
- ACR with anonymous pull disabled
- managed identity / AcrPull integration
- Workload Identity and OIDC issuer enabled
- Key Vault Secrets Store CSI Driver where included

O4 must not be marked complete until private API access, image pull, internal app validation, routing, evidence, and teardown/cost decision are complete.

### O3c closeout - segmented private multi-cloud routing validated

O3c validation is complete.

Validated behavior:

    HQ / VyOS -> AWS trusted private VM:
      pass

    HQ / VyOS -> AWS DMZ private VM:
      expected failure

    Azure management VM -> AWS trusted private VM:
      pass

    Azure management VM -> AWS DMZ private VM:
      expected failure

Route-control outcome:

    Advertised AWS private prefix:
      172.16.1.0/24

    Withheld AWS private prefixes:
      172.16.2.0/24
      172.16.0.0/16

Evidence:

    docs/release2/evidence/O3c/o3c-closeout-summary.md
    docs/release2/evidence/O3c/o3c-hq-azure-to-aws-trusted-dmz-private-validation.txt
    docs/release2/evidence/O3c/o3c-aws-post-apply-sg-route-ssm-validation.txt
    docs/release2/evidence/O3c/o3c-aws-post-apply-current-profile-plan.txt
    docs/release2/evidence/O3c/o3c-post-merge-aws-current-profile-plan.txt
    docs/release2/evidence/O3c/o3c-post-merge-platform-networking-current-hybrid-plan.txt

Non-claim:

    FortiGate AWS inspection is not claimed until FortiGate route path, policy counters, or logs prove traversal.

---

## A1/A2 Automation Control Plane Tracker

### A1 - Ansible Network/Security Automation Baseline [x]

Status: Completed and validated.

Completed:

- FortiGate read-only API validation through least-privilege token.
- FortiGate sanitized API snapshot backup.
- VyOS read-only validation and sanitized backup.
- Cisco RESTCONF read-only validation.
- Cisco controlled OpenSSH fallback for CLI-only BGP/routing/running-config evidence.
- Runtime secrets loaded from Azure Key Vault and AWS SSM.
- Idempotency/no-device-change proof validated.

Evidence:

- `docs/release2/evidence/A1-ansible-network-baseline/evidence/a1-fortigate-readonly-validation.txt`
- `docs/release2/evidence/A1-ansible-network-baseline/evidence/a1-vyos-readonly-validation.txt`
- `docs/release2/evidence/A1-ansible-network-baseline/evidence/a1-cisco-readonly-validation.txt`
- `docs/release2/evidence/A1-ansible-network-baseline/evidence/a1-idempotency-no-change-proof.txt`
- `docs/release2/evidence/A1-ansible-network-baseline/sanitized-backups/`

### A2 - AWX Automation Control Plane [x]

Status: Completed and validated.

Completed:

- AWX management access through the approved SSH tunnel and management path.
- AWX project sync from GitHub branch `a2-awx-platform-management-design`.
- Management-host dispatcher model.
- Azure Key Vault runtime secret retrieval.
- AWS SSM runtime secret retrieval through Roles Anywhere.
- Entra / Azure AD SSO login.
- AWX social user creation for `awx-admin@entra.azawslab.co.uk`.
- AWX Tier 1 through Tier 5 templates.
- First low-risk reversible VyOS write and rollback.

Evidence:

- `docs/release2/evidence/A2-awx-control-plane/a2-awx-control-plane-closure-evidence.md`
- `docs/release2/evidence/A2-awx-control-plane/a2-awx-api-final-state.json`
- `docs/release2/evidence/A2-awx-control-plane/a2-entra-awx-sso-final-state.json`
- `docs/release2/evidence/A2-awx-control-plane/a2-awx-job-46-stdout.txt`
- `docs/release2/evidence/A2-awx-control-plane/a2-awx-entra-sso-social-user-awxadmin-login.png`

Current resource state:

- A2 was validated and evidence was captured.
- Cloud resources are currently destroyed or deallocated where applicable to control cost.

---

## A2/O4/O5 Integrated Design Tracker

### A2 - AWX Automation Control Plane

Status: Completed and validated. Evidence captured. Resources currently destroyed or deallocated where applicable for cost control.

Scope:

- [ ] Deploy or prepare AWX host `vm-dev-awx-01`
- [ ] Configure bootstrap admin `awx-admin`
- [ ] Integrate Entra/Azure AD login
- [ ] Configure AWX RBAC groups
- [ ] Configure GitHub project sync
- [ ] Configure Azure Key Vault runtime secret model
- [ ] Configure AWS SSM runtime secret model
- [ ] Create Tier 1 read-only validation templates
- [ ] Create Tier 2 sanitized backup templates
- [ ] Create Tier 3 preflight/dry-run templates
- [ ] Create Tier 4 approved write/change workflow
- [ ] Create Tier 5 rollback/emergency workflow
- [ ] Validate first low-risk write and rollback on VyOS
- [ ] Validate separate FortiGate write token before FortiGate write workflow
- [ ] Keep Cisco broad write disabled until transport is enterprise-stable

Evidence path:

```text
docs/release2/evidence/A2-awx-control-plane/
```

### O4 - Private AKS Modern Application Platform

Status: Previously validated. Current cloud resources are destroyed for cost control.

Scope:

- [ ] Private AKS cluster
- [ ] ACR integration
- [ ] Workload Identity
- [ ] OIDC issuer
- [ ] Key Vault CSI Driver
- [ ] Internal NGINX ingress or internal AGIC decision
- [ ] NGINX or .NET sample app
- [ ] Azure Firewall egress validation
- [ ] FortiGate hybrid/private inspection only where proven by route/policy/log evidence

Evidence path:

```text
docs/release2/evidence/O4-private-aks-platform/
```

### O5 - AVD + FSLogix Secure Admin/Dev Workspace

Status: Previously validated. Current cloud resources are destroyed for cost control.

Scope:

- [ ] Single-user admin/dev AVD workspace
- [ ] FSLogix profile container
- [ ] Azure Files private endpoint
- [ ] Secure admin/dev toolchain
- [ ] AKS validation tooling
- [ ] AWX access validation
- [ ] GitHub/Terraform/Ansible/cloud CLI tooling validation

Evidence path:

```text
docs/release2/evidence/O5-avd-fslogix-workspace/
```

<!-- O5-CORRECTED-TRACKING-ALIGNMENT:START -->

### O5 - Corrected Implementation Tracking Alignment

O5 tracks the secure admin/dev workspace, not a generic pooled desktop service.

Required O5 tracking behavior:

- [ ] O4 private AKS is closed or stable enough that O5 will not disrupt it.
- [ ] O5 uses a dedicated Terraform root, expected name `terraform/platform-avd/dev`.
- [ ] O5 uses a root-specific GitHub Actions workflow.
- [ ] O5 uses canonical names: `vdpool-dev-norwayeast`, `vdws-dev-norwayeast`, `vdag-dev-norwayeast`, `stdevavdfsne01`, `fslogix-profiles`.
- [ ] O5 validates personal/single-user admin/dev workspace behavior.
- [ ] O5 validates FSLogix profile persistence through Azure Files private endpoint.
- [ ] O5 validates AVD required endpoints through approved egress.
- [ ] O5 validates HQ DNS/AD reachability if domain join is used.
- [ ] O5 validates O4 private AKS access from the AVD workspace.
- [ ] O5 does not claim FortiGate inspection unless route path and FortiGate counters/logs prove traversal.

<!-- O5-CORRECTED-TRACKING-ALIGNMENT:END -->
### O6 - Secure AI Operations Enclave Integration Pattern [O]

Status: Prepared as documentation and optional live-validation scaffold. Not currently deployed.

Current cloud state:

- No cloud resources are currently active.
- No O6 AKS namespace is currently deployed.
- O6 live AKS validation is deferred to a future approved short validation window.

Scope:

O6 is a Release 2 design extension and architecture integration pattern. It documents how the companion Local AI Infrastructure Operations Lab can map into the private AKS and AVD-governed operational boundary without granting autonomous production write access.

Prepared:

- [x] O6 architecture pattern documented
- [x] O6 relationship to Local AI Infrastructure Operations Lab documented
- [x] Terraform / Ansible / AWX responsibility boundaries documented
- [x] MCP/tool gateway allow/deny boundary documented
- [x] Redaction and output-filtering model documented
- [x] API/tool-call monitoring model documented
- [x] Human approval boundary documented

Future live validation:

- [ ] Optional live AKS deployment of `ai-enclave` namespace validated
- [ ] Optional Workload Identity manifests applied and validated
- [ ] Optional NetworkPolicy manifests applied and validated
- [ ] Optional Azure Monitor / Log Analytics dashboard validated
- [ ] Optional AWX job-template proposal examples created in AWX UI/API

Evidence path:

```text
docs/release2/evidence/O6/
```

Cost control:

O6 live validation must be executed only during an approved short validation window. After evidence capture, any temporary cloud resources must be destroyed or deallocated.
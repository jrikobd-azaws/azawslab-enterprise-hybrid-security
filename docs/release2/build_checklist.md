# Build Checklist – Release 2

**Version:** 1.0  
**Last Updated:** [02-May-2026]  
**Primary Source of Truth:** `README_PLAN.md`  
**Supports:** `implementation-tracker.md`, `Phases-with-steps.md`, `naming-conventions.md`  
**Purpose:** Practical hands-on execution checklist for building Release 2 in an organized, low-drift, evidence-first way.

---

## 1. What This File Is For

This file is the **working build checklist** for Release 2.

Use it:
- before starting a build session
- before beginning a new phase
- before applying Terraform or running Ansible
- before merging changes
- before marking a phase complete
- before ending the day
- before tearing down ephemeral resources

This file is **not** the project status tracker.  
That role belongs to `implementation-tracker.md`.

### File Role Split
- `README_PLAN.md` = architecture and master source of truth
- `implementation-tracker.md` = phase status, blockers, validation ownership, evidence locations
- `Phases-with-steps.md` = operator guide with config snapshots and diagrams
- `build_checklist.md` = day-to-day execution discipline
- `naming-conventions.md` = naming and tagging authority

---

## 2. Core Build Rules

- [ ] If a support doc conflicts with `README_PLAN.md`, follow `README_PLAN.md` and fix the support doc
- [ ] Do not start infrastructure build work until docs are aligned
- [ ] Do not create resources with ad hoc names
- [ ] Do not skip validation just because deployment succeeded
- [ ] Do not skip evidence capture until “later”
- [ ] Do not leave expensive ephemeral resources running unnecessarily
- [ ] Do not reintroduce RRAS terminology or config assumptions into Release 2
- [ ] Treat Release 2 as CLI-first: capture text evidence first, screenshots second

---

## 3. Current Working Mode Check

### 3.1 Current Reality Check
- [ ] I am clear whether I am in **planning mode** or **build mode**
- [ ] I am not mixing documentation cleanup with live infrastructure changes in the same uncontrolled session
- [ ] I know whether I am using:
  - [ ] GitHub Desktop only
  - [ ] local VS Code
  - [ ] GitHub Codespaces
  - [ ] Azure CLI from local machine
  - [ ] Azure CLI from Codespaces

### 3.2 Repo Control Check
- [ ] I am working in the correct repo
- [ ] I am on the intended branch
- [ ] I know what file(s) I intend to change before I start
- [ ] I am not making unrelated doc and infra changes in one commit unless deliberate

---

## 4. Documentation Alignment Checklist

Complete this before active build execution.

### 4.1 Source-of-Truth Alignment
- [ ] `README_PLAN.md` is confirmed as the master plan
- [ ] `implementation-tracker.md` is aligned
- [ ] `Phases-with-steps.md` is aligned
- [ ] `naming-conventions.md` is aligned
- [ ] `README.md` links resolve correctly
- [ ] `build_checklist.md` reflects the current build approach

### 4.2 Terminology Alignment
- [x] O3a uses **VyOS**, not RRAS
- [ ] O3c transit-routing wording matches the current hybrid design
- [ ] file names referenced in docs match actual repo file names
- [ ] evidence path is consistently `docs/release2/evidence/`

### 4.3 Operator Readiness
- [ ] I can navigate the docs without confusion
- [ ] I can identify the next phase to execute
- [ ] I know where the relevant validation commands live
- [ ] I know where to save evidence for the next phase

---

## 5. Environment Preparation Checklist

### 5.1 Azure / Subscription Readiness
- [ ] Azure subscription funding / offer state reviewed as a non-blocking readiness item
- [X] Correct subscription selected
- [ ] Entra domain `entra.azawslab.co.uk` verified
- [x] finalized implementation region confirmed as `norwayeast`
- [ ] budget / cost alerts configured

### 5.2 Addressing and Topology Readiness
- [ ] Azure Hub CIDR confirmed
- [ ] Azure Workload Spoke CIDR confirmed
- [ ] additional Azure spoke CIDR confirmed if used
- [ ] on-prem lab CIDR confirmed
- [ ] AWS branch CIDR confirmed if used
- [ ] no CIDR overlap exists

### 5.3 GitHub Readiness
- [ ] repo reachable
- [X] GitHub environment `release-2` exists
- [ ] branch strategy decided
- [ ] protected branch identified
- [ ] planned secrets/variables list documented

### 5.4 Local / On-Prem Readiness
- [ ] Hyper-V or alternative local virtualization platform confirmed
- [ ] VyOS plan documented
- [ ] on-prem VM/DC plan documented
- [ ] internet connectivity for the local lab confirmed

### 5.5 AWS Readiness (if O3b planned)
- [ ] AWS account ready
- [ ] credential handling plan documented
- [ ] expected cost risk understood
- [ ] teardown plan prepared

---

## 6. VS Code / Codespaces Bootstrap Checklist

Complete this before serious build execution if you intend to use Codespaces.

### 6.1 Workspace Setup
- [ ] repo opens correctly in VS Code
- [ ] repo opens correctly in Codespaces if using it
- [ ] `.devcontainer/devcontainer.json` exists or is intentionally deferred
- [ ] required extensions are available

### 6.2 Tooling Check
- [ ] `az --version` works
- [ ] `terraform --version` works
- [ ] `ansible --version` works
- [ ] `git --version` works

### 6.3 Authentication Check
- [X] Azure sign-in works in the intended execution environment
- [ ] Git works from the intended execution environment
- [ ] repo push/pull workflow is understood before making infra changes

---

## 7. Before Starting Any Phase

Use this section every time before beginning a new phase.

- [ ] I have read the phase section in `README_PLAN.md`
- [ ] I have read the same phase in `Phases-with-steps.md`
- [ ] I understand dependencies for this phase
- [ ] I know whether the phase is persistent or ephemeral
- [ ] I know the success criteria
- [ ] I know the validation method
- [ ] I know the evidence folder path
- [ ] I know the teardown expectation if applicable

### Phase Intent Check
- [ ] I can explain what this phase is supposed to prove
- [ ] I know what “done” means for this phase
- [ ] I am not starting the phase just because it “looks next” without readiness

---

## 8. Pre-Apply Terraform Checklist

Use this before every Terraform apply.

### 8.1 Config Hygiene
- [ ] resource names follow `naming-conventions.md`
- [ ] tags are defined correctly
- [ ] region is correct
- [ ] no unintended public IPs are being added
- [ ] no stale or experimental values remain in files
- [ ] sensitive values are not hardcoded

### 8.2 State and Backend Check
- [ ] correct backend is configured
- [ ] correct environment directory is selected
- [ ] state target is understood
- [ ] I know whether this apply could affect existing resources

### 8.3 Terraform Command Discipline
- [ ] run `terraform fmt -check`
- [ ] run `terraform init`
- [x] run `terraform validate`
- [x] run `terraform plan`
- [x] review plan before apply
- [x] confirm the plan matches intended change scope

### 8.4 Risk Check
- [ ] no surprise destroys are present unless intentional
- [ ] no unexpected public exposure is introduced
- [ ] no obviously expensive resources are being created unintentionally
- [ ] ephemeral resources are clearly identified before apply

---

## 9. Pre-Run Ansible Checklist

Use this before running playbooks.

- [ ] target hosts are correct
- [ ] inventory file is correct
- [ ] connectivity path is correct
- [ ] variables are correct
- [ ] no secrets are exposed in plaintext files unnecessarily
- [ ] expected host roles are understood
- [ ] `ansible-lint` has been run
- [ ] I know what “successful rerun” should look like for idempotency

---

## 10. Pre-Merge / CI-CD Checklist

Use this before merging workflow or Terraform changes.

- [ ] workflow file names are correct
- [ ] OIDC assumptions are correct
- [ ] no static secrets are being introduced accidentally
- [ ] branch protection expectations are understood
- [ ] PR description explains what changed
- [ ] plan output has been reviewed
- [ ] merge is appropriate for the current state of the phase

---

## 11. Evidence Capture Checklist

Do this during the phase, not at the end of the week.

### 11.1 Evidence Discipline
- [ ] evidence folder for the phase exists
- [X] validation output is saved immediately after successful check
- [ ] filenames are short, readable, and phase-appropriate
- [X] text evidence is preferred over screenshots
- [ ] screenshots are only used when text evidence is insufficient

### 11.2 Minimum Evidence Questions
Before leaving a phase, confirm:
- [x] do I have proof it deployed?
- [x] do I have proof it validated?
- [x] do I have proof the important control or behavior works?
- [x] do I have enough evidence that future me can understand what happened?

### 11.3 Naming Check
- [ ] evidence filenames match the naming convention
- [ ] files are saved under the correct phase folder
- [ ] I did not leave important output only in terminal history

---

## 12. Phase Completion Checklist

Before marking any phase as complete in `implementation-tracker.md`:

- [x] deployment/configuration succeeded
- [x] validation completed successfully
- [x] evidence captured in correct folder
- [x] notes updated if anything deviated from the plan
- [ ] follow-on dependency impact checked
- [ ] teardown completed if the phase is ephemeral
- [x] tracker status updated

### Completion Quality Check
- [ ] I could explain this phase clearly in an interview
- [ ] I could show evidence for the claim
- [ ] I understand the tradeoff or design reason behind the phase

---

## 13. Ephemeral Resource Teardown Checklist

Use this immediately after validating expensive or temporary phases.

### 13.1 Teardown Decision
- [ ] this resource is truly no longer needed by the next dependent phase
- [ ] evidence has already been captured
- [ ] config artifacts are saved before destroy
- [ ] I know exactly what is being destroyed

### 13.2 High-Cost / Ephemeral Review
Check especially for:
- [ ] Azure Firewall
- [ ] FortiGate NVA
- [ ] AWS Cisco NVA
- [ ] AVD session hosts
- [ ] any test VM or temporary compute left running
- [ ] any extra public IP or load-balancing component created only for validation

### 13.3 After Destroy
- [ ] destroy output saved if useful
- [ ] tracker updated
- [ ] README / notes do not imply the resource is still active
- [ ] cost risk reduced before ending the day

---

## 14. End-of-Day Checklist

Use this before finishing a working session.

- [ ] commit-worthy changes are saved locally
- [ ] evidence created today is stored in the repo structure
- [ ] notes about blockers or deviations are written down
- [ ] tracker is updated honestly
- [ ] no expensive ephemeral resources are accidentally left running
- [ ] I know the exact next step for the next session

### Git Hygiene
- [ ] commit message reflects the actual change
- [ ] unrelated work is not mixed into the same commit
- [ ] pushed or intentionally not pushed
- [ ] I know whether the repo state is clean before stopping

---

## 15. GitHub Desktop Working Checklist

Use this while you are still working mainly through GitHub Desktop.

### Before Commit
- [ ] review changed files carefully
- [ ] confirm no accidental generated files are included
- [ ] confirm no local secrets are included
- [ ] confirm only intended documentation or infra files are staged

### Before Push
- [ ] branch name is correct
- [ ] commit message is useful
- [ ] I understand what the remote repo will receive
- [ ] I am not pushing half-finished changes unless intentional

### Transition-to-Codespaces Reminder
- [ ] once build execution begins, shift toward VS Code / Codespaces for consistency
- [ ] keep GitHub Desktop useful for simple commit/push flow if preferred
- [ ] avoid mixing too many execution environments without documenting what changed where

---

## 16. Common Mistakes to Avoid

- [ ] starting infra build before docs are aligned
- [ ] using wrong file paths from outdated docs
- [ ] forgetting to update the tracker after completing a phase
- [ ] capturing screenshots but not preserving CLI output
- [ ] leaving firewall or NVA resources running
- [ ] using inconsistent naming
- [ ] forgetting tags
- [ ] reintroducing stale RRAS wording
- [ ] treating “deployment succeeded” as “phase completed”
- [ ] making too many file changes at once without controlled commits

---

## 17. Minimal Working Sequence for Release 2

Use this when you need a simple execution memory aid.

### Stage A – Control the Docs
- [ ] align `README_PLAN.md`
- [ ] align `implementation-tracker.md`
- [ ] align `Phases-with-steps.md`
- [ ] align `naming-conventions.md`
- [ ] align `README.md`
- [ ] align `build_checklist.md`

### Stage B – Prepare the Build Environment
- [ ] Azure readiness
- [ ] repo readiness
- [ ] VS Code / Codespaces readiness
- [ ] GitHub environment readiness
- [ ] on-prem / AWS optional readiness

### Stage C – Execute Core Phases
- [ ] P0
- [ ] P1
- [ ] P2a
- [x] P2b
- [ ] P2c
- [ ] P3
- [x] P5
- [ ] P7
- [ ] P8
- [ ] P9a
- [ ] P9b
- [ ] P9c

### Stage D – Execute Optional Phases Only If Ready
- [x] P4
- [ ] P6
- [x] O1
- [ ] O2
- [x] O3a
- [ ] O3b
- [ ] O3c
- [ ] O4
- [ ] O5

### P5 Hub-Spoke closeout note
- [x] `terraform/platform-networking/dev` created as a separate platform networking root
- [x] `platform-networking-dev.tfstate` backend configured
- [x] hub VNet deployed in `rg-connectivity-prod-norwayeast`
- [x] reserved hub subnets deployed: `AzureBastionSubnet`, `AzureFirewallSubnet`, `GatewaySubnet`
- [x] bidirectional hub/spoke peering validated as Connected
- [x] workload route table scaffold associated to `snet-workload`
- [x] existing workload and deallocated management VM were not changed during deployment
- [x] evidence saved under `docs/release2/evidence/P5/`

### P4 Lighthouse closeout note
- [x] Azure Lighthouse Reader delegation deployed
- [x] customer-side service provider offer visible in portal
- [x] delegated Reader role visible for `azw-Platform-Admins`
- [x] managing-side CLI shows delegated `azawslab` subscription through `managedByTenants`
- [x] native Release 2 subscription remains default after validation
- [x] evidence saved under `docs/release2/evidence/P4/`
- [x] Lighthouse delegation intentionally retained for portfolio demonstration until later teardown decision

### Stage E – Final Review
- [ ] evidence complete
- [ ] costly resources reviewed
- [ ] tracker honest and updated
- [ ] docs still consistent
- [ ] final repo presentation coherent

---

## 18. Sign-Off Checklist

### Planning Stage
- [ ] documentation aligned
- [ ] build path understood
- [ ] environment prep plan complete

### Build Stage
- [ ] execution environment ready
- [ ] first phase ready to start
- [ ] evidence flow ready
- [ ] teardown discipline understood

### Portfolio Readiness Stage
- [ ] completed phases are evidenced
- [ ] architecture decisions are understandable
- [ ] naming and file references are consistent
- [ ] project can be explained clearly to a reviewer

---

## 19. Personal Session Notes

### Today’s Target
- [ ] ___________________________________________

### Blockers
- [ ] ___________________________________________
- [ ] ___________________________________________

### Evidence to Capture Today
- [ ] ___________________________________________
- [ ] ___________________________________________

### Teardown to Remember Today
- [ ] ___________________________________________

### Next Exact Step
- [ ] ___________________________________________
## Workspace Strategy for Release 2

Use this execution split for the project:

### Local machine / local VS Code
Primary environment for:
- documentation work
- markdown editing
- Terraform authoring
- GitHub workflow authoring
- repository cleanup and structure updates
- git review, commit preparation, and normal file editing
- Azure CLI and Terraform where private network reachability is not required

### Workspace / Codespace
Use as a short-lived execution environment for:
- **P2b** Ansible configuration work
- **P2c** CI/CD validation and workflow-related command checks
- any short command-driven session where the remote Linux environment is more convenient

### Working rule
The workspace is **not** the primary all-day editor for Release 2.  
Use it as a targeted execution environment, then stop or delete it after the session if appropriate.

### Cost-control rule
- start the workspace only when needed
- commit and push before deleting it
- avoid keeping it running for general writing or planning work

---

## P1 Closure Checkpoint

Phase status: Complete

Validated:
- Management-group hierarchy created
- Subscription placement under landing-zones confirmed
- Governance baseline applied
- Azure policy assignments verified
- Deny test for disallowed resource-group location succeeded

Evidence:
- docs/release2/evidence/P1/p1-evidence.txt
- docs/release2/evidence/P1/p1-execution-log.txt

## P2a cost-control reminder
- The Norway East workload VM and supporting workload resources are ephemeral from a cost-control perspective
- After documentation and evidence alignment are complete, deallocate or destroy the workload promptly to avoid unnecessary spend
## Terraform state boundary check
- [x] governance resources are managed from `terraform/governance`
- [x] shared security resources are managed from `terraform/platform-shared/dev`
- [x] workload networking and compute are managed from `terraform/workloads/dev`
- [x] temporary Ansible management host is managed from `terraform/platform-management/dev`
- [x] `platform-management-dev.tfstate` backend configured
- [x] each active Terraform root plans cleanly with no unexpected changes
- [x] state separation aligns lifecycle boundaries without changing reusable module structure
- [x] post-P5 platform-management state split completed without Azure resource destroy/recreate


## P2b current completion note
- [x] Temporary Azure-connected management host validated
- [x] Private WinRM path validated
- [x] Role-based Ansible scaffold created
- [x] common role validated with idempotent rerun
- [ ] d-join execution deferred until HQ AD and hybrid connectivity are ready

## Backend alignment note
- [x] Active Terraform backend aligned to g-dev-terraformstate-norwayeast
- [x] Active storage account aligned to stdevtfstatene01
- [ ] Old backend retained temporarily as rollback safety until final retirement

---

## P3 Build Completion Checkpoint - Enterprise Governance & Guardrails

**Completed:** 2026-05-04 17:25:13
**Phase status:** Completed and validated

### Build discipline completed
- [x] P3 source-of-truth and support documentation reviewed before implementation.
- [x] Governance-plane policy assignments reviewed before changes.
- [x] RBAC reviewed for `hashib`, `admin-lab`, and `sp-terraform-gh`.
- [x] Terraform correction for resource group tag enforcement validated locally.
- [x] Terraform correction deployed through GitHub Actions controlled apply.
- [x] Region/resource group deny behavior validated.
- [x] Mandatory tag deny behavior validated after correction.
- [x] Disallowed VM SKU deny behavior validated.
- [x] Temporary validation resources cleaned up.
- [x] Raw CLI evidence and curated evidence captured under `docs/release2/evidence/P3/`.

### P3 evidence location
- `docs/release2/evidence/P3/`





## P6 active cost-control note

- [x] Azure Firewall deployment was intentionally enabled for P6 validation.
- [x] Azure Firewall is confirmed as an ephemeral cost-heavy platform-networking resource.
- [x] Deployment evidence has been captured under `docs/release2/evidence/P6/`.
- [x] Traffic validation completed; firewall log evidence deferred because diagnostics were not enabled for the ephemeral deployment.
- [x] After validation, set `enable_azure_firewall = false` through a follow-up PR.
- [x] Run controlled GitHub Actions Terraform Apply after disabling to remove Azure Firewall resources and stop ongoing cost.


## P7 Defender for Cloud implementation note

- [x] Microsoft.Security provider registration validated.
- [x] Defender pricing plan status captured.
- [x] Secure Score baseline captured.
- [x] Defender recommendations captured.
- [x] Security contact deployed through Terraform in `terraform/platform-shared/dev`.
- [x] No paid Defender workload plan enabled during this step.
- [ ] Post-change Defender recommendations / Secure Score review still needs to be captured.

## P5 Ephemeral Bastion validation checkpoint

Date: 2026-05-05 20:55:24 +01:00

- [x] Bastion enabled ephemerally for private access validation
- [x] Bastion enable apply completed through GitHub Actions
- [x] Workload VM started temporarily for validation
- [x] Workload VM confirmed private-only with no public IP
- [x] Private RDP access through Bastion validated
- [x] Bastion validation screenshots captured
- [x] Text validation evidence captured under `docs/release2/evidence/P5/`
- [x] Workload VM deallocated after validation
- [~] Bastion disablement / teardown pending GitHub Actions apply

## P8 Microsoft Sentinel validation checkpoint

Date: 2026-05-05 22:32:34 +01:00

- [x] Log Analytics workspace created
- [x] Microsoft Sentinel onboarding completed
- [x] Sentinel scheduled analytic rule deployed
- [x] Subscription diagnostic setting configured for Azure Activity ingestion
- [x] Terraform outputs captured
- [x] Terraform state validation captured
- [x] Defender portal workspace connection completed manually
- [x] Governance policy issue documented
- [x] Narrow RG-scoped policy exemption created for non-taggable Sentinel onboarding child resource
- [x] P8 post-apply validation evidence captured
- [~] Incident generation path still pending if final closeout requires an incident

## P9a Azure Monitor Alerts validation checkpoint

Date: 2026-05-06 00:59:25 +01:00

- [x] Azure Monitor Action Group deployed
- [x] Action group membership email received
- [x] VM CPU metric alert deployed
- [x] Alert target associated to `vm-dev-client-01`
- [x] Terraform outputs captured
- [x] Terraform state validation captured
- [x] Post-apply resource validation captured
- [x] Controlled CPU load generated on target VM
- [x] Alert firing evidence captured
- [x] Azure Monitor alert email notification captured
- [x] VM deallocated after validation

---

## O1 FortiGate Service-Chain Closeout Checklist

- [x] FortiGate policy created for Azure workload to HQ ICMP validation.
- [x] FortiGate address objects created for `10.10.0.0/16` and `192.168.1.0/24`.
- [x] FortiGate static route added for Azure workload return route via `port2`.
- [x] Azure workload UDR applied for `192.168.1.0/24 -> VirtualAppliance 10.0.3.36`.
- [x] FortiGate debug flow showed `Allowed by Policy-1: SNAT`.
- [x] FortiGate SNAT translated `10.10.0.4 -> 10.0.3.4`.
- [x] VyOS tcpdump confirmed ICMP request/reply on `vti1`.
- [x] FortiGate sniffer confirmed four-leg request/reply traversal.
- [x] SNAT documented as a lab delta.
- [x] HQ-initiated inspection toward Azure workload validated for the current O1/P2b scope.
- [x] GatewaySubnet route change validated and reconciled into Terraform for the current O1/P2b scope.


---

## P2b / P5 Validation Checklist Addendum

- [x] Ansible control node uses Key Vault-backed runtime secret retrieval.
- [x] Plaintext Windows and domain join passwords removed from committed inventory pattern.
- [x] vm-dev-client-01 joined to hq.azawslab.co.uk.
- [x] AD computer object confirmed in Workstations OU.
- [x] IIS installed by Ansible webserver role.
- [x] IIS private HTTP validation from vm-dev-mgmt-01 succeeded.
- [x] FortiGate policy baseline consolidated into directional policies.
- [x] HQ-to-Azure asymmetric routing root cause identified.
- [x] GatewaySubnet UDR validation fixed DC1-to-workload path.
- [x] Codify GatewaySubnet UDR in terraform/platform-networking/dev.
- [ ] Replace temporary/manual route validation with GitHub Actions-applied Terraform state.

## P2b Linux AD Join Closeout

- [x] HQ Linux host `hq-linux-vm01` joined to `hq.azawslab.co.uk`.
- [x] DC1 computer object confirmed under `OU=Linux,OU=AzawsLab,DC=hq,DC=azawslab,DC=co,DC=uk`.
- [x] Linux join used delegated account `svc.ansible`.
- [x] `svc.ansible` delegated through `azw-hq-ansible-operators` with Linux OU-scoped computer-join rights.
- [x] Runtime secrets sourced from Key Vault using `vm-dev-mgmt-01` managed identity.
- [x] No plaintext secrets stored in inventory.
- [x] No root login used.
- [x] No passwordless sudo used.
- [x] `sssd` active.
- [x] `apache2` active.
- [x] Apache local validation returned `HTTP/1.1 200 OK`.
- [x] Evidence captured under `docs/release2/evidence/P2b/`.

## P5/O1/O3a Closeout Checkpoint

- [x] FortiGate Stage 1 deployment validated.
- [x] FortiGate interface mapping confirmed: port1 `10.0.3.4`, port2 `10.0.3.36`.
- [x] Azure VPN Gateway to VyOS IPSec tunnel validated.
- [x] AES256/SHA256/DHGroup14/PFS14 path confirmed.
- [x] Azure workload to VyOS data-plane validation completed.
- [x] FortiGate policy baseline consolidated into two directional policies.
- [x] GatewaySubnet symmetry correction validated.
- [x] GatewaySubnet UDR reconciled into Terraform for current O1/P2b scope.
- [x] Evidence captured under `docs/release2/evidence/P5-vpn/`.
- [ ] O2 / Azure Arc evidence is not present and remains open.


### O2 Azure Arc Closeout

- [x] MEM1 selected as first Arc target instead of DC1
- [x] MEM1 network path validated through VyOS gateway `192.168.1.254`
- [x] Azure endpoint TCP/443 preflight passed
- [x] Scoped Arc onboarding service principal created
- [x] Arc onboarding secret stored in Key Vault and not committed
- [x] Required Arc resource providers registered
- [x] MEM1 connected to Azure Arc
- [x] Azure-side validation showed `Connected` and `Succeeded`
- [x] Mandatory governance tags present on Arc resource
- [x] O2 evidence saved under `docs/release2/evidence/O2/`


### O3b/O3c Architecture Gate

- [x] Azure VPN Gateway is documented as the O3b/O3c IPSec/BGP transit hub
- [x] FortiGate is documented as the Azure-side inspection/service-chaining plane
- [x] Cisco 8000V is documented as the AWS branch router
- [x] VyOS is documented as the HQ/on-prem edge
- [x] Cisco Marketplace BYOL subscription confirmed
- [ ] Terraform/Ansible implementation audited before Cisco enablement
- [ ] Cisco deployment remains disabled until planned O3b implementation
- [ ] O3c transitive routing is not claimed until Azure/HQ/AWS paths are validated
- [ ] FortiGate inspection is not claimed for AWS flows until FortiGate counters/logs prove traversal


### O3b Selective BGP Checklist

- [ ] Cisco 8000V deployment plan keeps segmentation visible
- [ ] Trusted subnet `172.16.1.0/24` is the first advertised AWS branch prefix
- [ ] DMZ subnet `172.16.2.0/24` is intentionally not advertised during first validation
- [ ] Full VPC summary `172.16.0.0/16` is not used for first segmented proof
- [ ] Trusted AWS Linux VM proves positive private route behavior
- [ ] DMZ AWS Linux VM proves negative / non-propagated route behavior
- [ ] Azure VPN Gateway route learning confirms trusted prefix only
- [ ] Evidence captures both positive and negative validation
- [ ] O3b is not marked complete until selective BGP behavior is proven


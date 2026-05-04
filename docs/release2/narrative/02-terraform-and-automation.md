# 02-terraform-and-automation

## 1. Objective

This chapter covers the automation layer of Release 2. It combines:
- **P2a**: reusable Terraform modules
- **P2b**: Ansible configuration management
- **P2c**: CI/CD automation pipeline

The objective was to move from foundational control-plane setup into repeatable infrastructure deployment, workload configuration, and pipeline-driven execution.

## 2. Business Problem

Even with a sound landing zone, platform engineering work remains fragile if:
- infrastructure code is monolithic
- secrets are hardcoded or manually handled
- configuration management is inconsistent
- deployments rely on manual steps
- validation is not embedded into the workflow

Release 2 addresses this by combining Terraform, Ansible, and CI/CD into a layered automation model.

## 3. Technical Solution

The automation layer implemented:
- reusable Terraform modules for governance, security, networking, and compute
- separated Terraform roots to reduce lifecycle coupling
- Key Vault-backed secret handling and sensitive-value protection
- a private-only workload VM pattern
- an Ansible role-based model for post-deployment configuration
- GitHub Actions CI and controlled apply workflows using OIDC authentication
- validation gates for formatting, planning, applying, and no-change state validation across the active roots

This phase turns the platform from static design into operationally repeatable automation.

## 4. Architecture Snapshot

Active Terraform roots:
- `terraform/governance`
- `terraform/platform-shared/dev`
- `terraform/workloads/dev`

Terraform reusable module families:
- `modules/security`
- `modules/networking`
- `modules/compute`

Platform-shared active state:
- `rg-dev-security-norwayeast`
- `kvdevazawsne01`
- `local-admin-password` secret flow

Workload active state:
- `rg-dev-workload-norwayeast`
- `vnet-dev-norwayeast-spoke-workload`
- `nic-vm-dev-client-01-01`
- `vm-dev-client-01`

Automation path:
- PR-triggered Terraform CI across all active roots
- controlled `workflow_dispatch` Terraform apply on `main`
- OIDC-based Azure authentication for both CI and apply

## 5. Implementation Summary

### P2a – Terraform reusable modules
Key implementation outcomes:
- deployment target finalized as:
  - region: `norwayeast`
  - VM SKU: `Standard_B2als_v2`
- reusable module pattern validated successfully
- dynamic local admin password generation and Key Vault secret storage confirmed
- workload networking deployed successfully
- workload VM deployed successfully with a private-only NIC and no public IP
- implemented active state included:
  - `rg-dev-security-norwayeast`
  - `rg-dev-workload-norwayeast`
  - `vnet-dev-norwayeast-spoke-workload`
  - `kvdevazawsne01`
  - `nic-vm-dev-client-01-01`
  - `vm-dev-client-01`

### Terraform state boundary refinement
A hardening refinement was completed after the validated build:
- `terraform/governance`
  - management-group policy assignments
- `terraform/platform-shared/dev`
  - shared security resources
  - Key Vault
  - secret flow
- `terraform/workloads/dev`
  - workload networking
  - workload compute

This reduced destroy risk by separating governance, shared security, and workload lifecycles while keeping the reusable module structure intact.

### P2b – Ansible configuration management
Current role in the automation model:
- role-based configuration path defined for post-deployment workload configuration
- management-host-based execution model defined for private workloads
- current validated scope includes:
  - temporary Azure-connected management host path
  - private WinRM path
  - role-based scaffold
  - `common` role idempotent rerun
- deferred item:
  - `ad-join` remains deferred until `hq.azawslab.co.uk` and hybrid connectivity are ready

### P2c – CI/CD pipeline
Key implementation outcomes:
- GitHub Actions Terraform CI workflow implemented
- GitHub Actions controlled Terraform apply workflow implemented
- OIDC-based Azure authentication validated for CI and apply
- split-state matrix execution validated across:
  - governance
  - platform-shared/dev
  - workload-dev
- PR-triggered CI passed for all active Terraform roots
- controlled apply passed on `main` for all active Terraform roots

## 6. Validation Summary

Validation for this chapter demonstrated for **P2a**:
- `terraform fmt`, `init`, `validate`, and `plan` succeeded
- Key Vault secret retrieval confirmed the secret flow
- VM validation confirmed:
  - location: `norwayeast`
  - SKU: `Standard_B2als_v2`
  - power state: running
  - private IP only
  - no public IP
- NIC validation confirmed private-only behavior
- governance, platform-shared, and workloads roots each planned cleanly with no unexpected changes after state separation

Validation for **P2c** demonstrated:
- PR-triggered Terraform CI succeeded for governance, platform-shared/dev, and workload-dev
- controlled Terraform apply succeeded on `main` for governance, platform-shared/dev, and workload-dev
- OIDC-based Azure authentication worked successfully for both CI and apply
- split-state Terraform automation is now operational end to end

Validation still pending for the remaining **P2b** deferred scope:
- domain join verification once HQ AD and hybrid connectivity are ready
- any later application-specific configuration beyond the current baseline path

## 7. Evidence Path

Primary evidence folders:
- `docs/release2/evidence/P2a/`
- `docs/release2/evidence/P2b/`
- `docs/release2/evidence/P2c/`

Typical evidence files:
- `p2a-evidence.txt`
- `p2a-execution-log.txt`
- `governance-state-validation.txt`
- `platform-shared-state-validation.txt`
- `workloads-state-validation.txt`
- `terraform-state-split-summary.md`
- `p2c-evidence.txt`
- `p2c-execution-log.txt`

## 8. Key Commands Used

Typical commands and tooling used in this phase:
- `terraform fmt`
- `terraform init`
- `terraform validate`
- `terraform plan`
- `terraform apply`
- `terraform state list`
- `az keyvault secret show`
- `az vm show`
- `az network nic show`
- `ansible-playbook`
- GitHub Actions CI and apply workflows

## 9. Lessons Learned

Key lessons from this phase:
- separating Terraform roots improves change control and reduces accidental lifecycle coupling
- Key Vault-backed secret handling is stronger than passing sensitive values through ad hoc variables
- private-only workload design changes how configuration tooling must be executed
- state-boundary refinement is a worthwhile hardening step once the initial build is proven
- controlled apply is easier to reason about when CI and apply are split into separate workflow paths
- Ansible scope should stay honest when core pathing is validated but domain-join dependencies are not yet ready

## 10. Recruiter-Ready Outcome Statement

Built the automation backbone of Release 2 by implementing reusable Terraform modules, dynamic secret flow through Azure Key Vault, a private-only workload deployment pattern, a hardened multi-root Terraform state model, and OIDC-based GitHub Actions CI/CD automation. The active Terraform roots now validate and apply successfully end to end through a controlled split-state workflow model.

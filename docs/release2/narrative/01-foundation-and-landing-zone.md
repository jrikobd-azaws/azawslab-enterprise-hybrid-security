# 01-foundation-and-landing-zone

## 1. Objective

This chapter covers the foundational platform bootstrap for Release 2. It combines:
- **P0**: secretless automation bootstrap with GitHub Actions OIDC and Terraform backend
- **P1**: Azure landing zone and governance foundation

The goal was to establish a controlled Azure platform baseline before moving into reusable infrastructure modules and workload automation.

## 2. Business Problem

Cloud environments built without an initial control plane tend to suffer from:
- unmanaged authentication patterns
- overuse of long-lived secrets
- weak governance at subscription level
- inconsistent naming and structure
- poor auditability for infrastructure deployment

To avoid this, Release 2 starts by building the identity, backend, and governance plumbing first.

## 3. Technical Solution

The foundation layer implemented:
- GitHub Actions authentication to Azure using **OIDC federation**
- an Entra application / service principal for automation
- a remote Terraform backend in Azure Storage with state locking
- a management group hierarchy for governance structure
- Azure Policy guardrails for region, VM SKU, and mandatory tags
- a CLI-first validation and evidence model

This design aligns the release to a secretless, auditable, infrastructure-as-code operating model.

## 4. Architecture Snapshot

Core foundation components:
- Entra tenant boundary: `entra.azawslab.co.uk`
- GitHub environment: `release-2`
- automation identity: `sp-terraform-gh`
- current Terraform state resource group: `rg-dev-terraformstate-norwayeast`
- current backend storage account: `stdevtfstatene01`
- backend container: `tfstate`

Landing zone governance components:
- `mg-platform-prod-global`
- `mg-landingzones-prod-global`
- `mg-sandbox-prod-global`

Governance baseline components:
- `pa-loc-prod-norwayeast`
- `pa-rgloc-prod-norwayeast`
- `pa-vmsku-prod-b2alsv2`
- `pa-tag-env`
- `pa-tag-proj`
- `pa-tag-own`
- `pa-tag-cost`

Later P3 validation strengthened this baseline by adding resource-group-specific mandatory tag assignments:
- `pa-rgtag-env`
- `pa-rgtag-proj`
- `pa-rgtag-own`
- `pa-rgtag-cost`

## 5. Implementation Summary

### P0 – Foundation and automation bootstrap
Key implementation outcomes:
- Azure subscription context confirmed
- GitHub environment prepared for Release 2 deployment control
- OIDC trust model defined between GitHub Actions and Azure
- remote Terraform backend established successfully
- current active Terraform roots aligned to:
  - `rg-dev-terraformstate-norwayeast`
  - `stdevtfstatene01`
- initial repository structure scaffolded for Terraform, Ansible, workflows, and evidence

### P1 – Landing zone and governance foundation
Key implementation outcomes:
- management groups created successfully:
  - `mg-platform-prod-global`
  - `mg-landingzones-prod-global`
  - `mg-sandbox-prod-global`
- the active subscription was placed under `mg-landingzones-prod-global`
- the governance baseline was aligned to the confirmed implementation target:
  - region: `norwayeast`
  - VM SKU: `Standard_B2als_v2`
- the initial Azure Policy assignments were applied at management-group scope
- deny validation succeeded for a non-approved region resource-group creation attempt

This created the minimum viable enterprise landing zone baseline for the rest of Release 2.

## 6. Validation Summary

Validation for this chapter demonstrated:
- OIDC workflow success without static secrets
- service principal visibility and correct RBAC scope
- successful Terraform backend initialization
- current active Terraform roots using the standardized backend target
- visible management group hierarchy
- verified policy assignment baseline at `mg-landingzones-prod-global`
- successful deny-path validation for non-compliant location deployment behavior; later P3 validation extended this into mandatory tag and VM SKU deny testing

## 7. Evidence Path

Primary evidence folders:
- `docs/release2/evidence/P0/`
- `docs/release2/evidence/P1/`

Typical evidence files:
- `p0-evidence.txt`
- `p0-execution-log.txt`
- `p0-backend-current-state.txt`
- `p1-evidence.txt`
- `p1-execution-log.txt`

## 8. Key Commands Used

Typical commands and tooling used in this phase:
- `az account show`
- `az ad app list`
- `az ad sp create`
- `az role assignment list`
- `az ad app federated-credential list`
- `az account management-group create`
- `az account management-group subscription add`
- `az policy assignment list`
- `az group create`
- `terraform init`
- `terraform validate`
- `terraform plan`
- `terraform apply`

## 9. Lessons Learned

Key lessons from this phase:
- secretless automation requires more initial setup, but produces a cleaner long-term operating model
- governance is easier to enforce when hierarchy and policy intent are introduced early
- management-group work may require the break-glass account when the working admin lacks governance-plane visibility
- backend/state design should be settled before module sprawl begins
- the important recruiter-facing truth is the current validated backend target and governance outcome, not every intermediate bootstrap attempt
- documentation and evidence structure must be established before deeper implementation work

## 10. Recruiter-Ready Outcome Statement

Established the foundational Azure landing zone and automation control plane for Release 2 by implementing GitHub Actions OIDC authentication, a remote Terraform backend with state locking, and a governance-aligned management group structure. The active Terraform roots are standardized on the current `norwayeast` backend target, and the landing-zone governance baseline is enforced through management-group Azure Policy assignments with validated deny behavior.


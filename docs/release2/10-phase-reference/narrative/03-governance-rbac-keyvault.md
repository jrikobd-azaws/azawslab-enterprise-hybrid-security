# 03-governance-rbac-keyvault

## 1. Objective

Phase P3 implemented and validated enterprise governance guardrails for Release 2.

The objective was to move beyond simply assigning Azure Policy definitions and prove that the guardrails actively deny non-compliant deployments. This phase focused on:

- management-group-scoped Azure Policy enforcement
- allowed region control
- mandatory tagging
- VM SKU cost guardrails
- RBAC review for the human and automation identities used in Release 2
- controlled Terraform deployment through GitHub Actions and OIDC

## 2. Business Problem

Without enforceable governance controls, a cloud platform can drift quickly.

Common risks include:

- resources created in non-approved regions
- untagged resources that weaken cost tracking and ownership
- oversized or unsupported VM SKUs increasing cost
- excessive permissions for automation identities
- policies that appear assigned but do not actually enforce the intended behavior

For a platform engineering project, the important test is not whether policies exist. The important test is whether they stop the wrong deployment at the right scope.

## 3. Technical Solution

P3 used Azure Policy assignments at the `mg-landingzones-prod-global` management group to enforce guardrails across the landing zone scope.

The active governance controls included:

- allowed locations: `norwayeast`
- allowed resource group locations: `norwayeast`
- allowed VM SKU: `Standard_B2als_v2`
- mandatory resource tags:
  - `Environment`
  - `Project`
  - `Owner`
  - `CostCenter`
- mandatory resource group tags:
  - `Environment`
  - `Project`
  - `Owner`
  - `CostCenter`

The governance root is managed through:

- `terraform/governance/main.tf`
- remote backend key: `governance.tfstate`
- backend resource group: `rg-dev-terraformstate-norwayeast`
- backend storage account: `stdevtfstatene01`
- backend container: `tfstate`

Deployment was performed through GitHub Actions controlled Terraform Apply using OIDC authentication through `sp-terraform-gh`.

## 4. Architecture Snapshot

```text
[Entra tenant: entra.azawslab.co.uk]
        |
        v
[Azure Subscription 1]
        |
        v
[Management Group: mg-landingzones-prod-global]
        |
        +-- Policy: allowed locations = norwayeast
        +-- Policy: allowed RG locations = norwayeast
        +-- Policy: allowed VM SKU = Standard_B2als_v2
        +-- Policy: required resource tags
        +-- Policy: required resource group tags
        |
        v
[Landing zone resources]
        |
        +-- compliant region required
        +-- mandatory tags required
        +-- approved VM SKU required
```

Identity model:

```text
hashib
  - Owner / Global Admin style account
  - used for governance-plane verification when required

admin-lab
  - day-to-day lab administration account
  - Contributor and User Access Administrator at subscription scope

sp-terraform-gh
  - GitHub OIDC automation principal
  - Contributor at subscription scope
  - used by GitHub Actions Terraform CI/CD
```

## 5. Implementation Summary

P3 began as a review and validation phase because several governance policies were already present from earlier foundation work.

The initial review confirmed policy assignments at `mg-landingzones-prod-global`, including:

- `pa-loc-prod-norwayeast`
- `pa-rgloc-prod-norwayeast`
- `pa-vmsku-prod-b2alsv2`
- `pa-tag-env`
- `pa-tag-proj`
- `pa-tag-own`
- `pa-tag-cost`

RBAC was also reviewed:

- `sp-terraform-gh` was confirmed as the GitHub OIDC automation service principal.
- `sp-terraform-gh` was confirmed with Contributor at subscription scope.
- `hashib` was confirmed as suitable for governance-plane validation.
- `admin-lab` was confirmed as the day-to-day administrative account.

During validation, the resource group location deny test succeeded, but the mandatory tag resource group test initially failed. A resource group could be created in `norwayeast` without tags, which exposed a real governance gap.

The cause was identified through Azure Policy discovery:

- existing resource tag policy: `Require a tag on resources`
- mode: `Indexed`
- result: did not enforce tags on resource groups

The correct policy was:

- resource group tag policy: `Require a tag on resource groups`
- mode: `All`

Terraform was updated to add resource-group-specific tag assignments:

- `pa-rgtag-env`
- `pa-rgtag-proj`
- `pa-rgtag-own`
- `pa-rgtag-cost`

The Terraform correction was validated locally with:

- `terraform fmt -check`
- `terraform init`
- `terraform validate`
- `terraform plan`

The plan showed:

```text
Plan: 4 to add, 0 to change, 0 to destroy.
```

The correction was then deployed through GitHub Actions controlled Terraform Apply.

A separate workload remote-state backend issue was also corrected during the PR process. The workload root still referenced the retired UK South backend for the `platform-shared-dev` remote state data source. This was corrected so the workload root now reads remote state from the active Norway East backend.

## 6. Validation Summary

P3 validation was CLI-first.

### Region deny validation

A test resource group was attempted in `eastus`.

Expected result:

- denied because only `norwayeast` is allowed

Actual result:

- denied with `RequestDisallowedByPolicy`
- enforcing policy assignment: `pa-rgloc-prod-norwayeast`
- cleanup check confirmed the resource group was not created

### Mandatory resource group tag validation

Initial test:

- attempted to create a resource group in `norwayeast` without tags

Initial result:

- resource group creation succeeded
- this proved the existing mandatory tag policy did not enforce resource group tags

Correction:

- added resource-group-specific tag policy assignments with Terraform
- deployed through GitHub Actions controlled Terraform Apply

Retest result:

- denied with `RequestDisallowedByPolicy`
- enforcing assignments:
  - `pa-rgtag-own`
  - `pa-rgtag-env`
  - `pa-rgtag-proj`
  - `pa-rgtag-cost`
- cleanup check confirmed the resource group was not created

### VM SKU deny validation

A temporary compliant test resource group was created in `norwayeast`.

A VM creation was attempted with:

- VM name: `vm-p3-deny-sku-01`
- disallowed SKU: `Standard_B1s`

Expected result:

- denied because only `Standard_B2als_v2` is allowed

Actual result:

- denied with `RequestDisallowedByPolicy`
- enforcing policy assignment: `pa-vmsku-prod-b2alsv2`
- policy definition: `Allowed virtual machine size SKUs`
- allowed SKU parameter: `Standard_B2als_v2`
- VM check confirmed the VM was not created
- cleanup check confirmed the temporary test resource group was deleted

### RBAC validation

RBAC validation confirmed the intended identity model:

- `hashib` retained governance-level authority for high-privilege verification.
- `admin-lab` remained the day-to-day lab administration identity.
- `sp-terraform-gh` was confirmed as the GitHub Actions OIDC deployment principal with Contributor at subscription scope.

## 7. Evidence Path

P3 evidence is stored under:

```text
docs/release2/evidence/P3/
```

Key evidence files:

```text
p3-execution-log.txt
p3-evidence.txt
p3-deny-test-rg-location-eastus.txt
p3-deny-test-rg-missing-tags.txt
p3-deny-retest-rg-missing-tags-after-fix.txt
p3-deny-test-vm-sku.txt
p3-current-tag-policy-assignment-review.txt
p3-tag-policy-definition-discovery.txt
```

Evidence model:

- `p3-execution-log.txt` records the raw implementation journey and important validation events.
- `p3-evidence.txt` provides the curated final evidence summary.
- The individual deny-test files retain the real CLI output for validation proof.

## 8. Key Commands Used

Policy assignment review:

```powershell
az policy assignment list `
  --scope "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global" `
  --query "[].{Name:name, DisplayName:displayName, Scope:scope, PolicyDefinitionId:policyDefinitionId}" `
  --output table
```

RBAC review for the GitHub OIDC service principal:

```powershell
az ad sp list `
  --display-name "sp-terraform-gh" `
  --query "[0].{DisplayName:displayName, AppId:appId, ObjectId:id}" `
  --output json

az role assignment list `
  --assignee "<sp-terraform-gh-object-id>" `
  --scope "/subscriptions/<subscription-id>" `
  --query "[].{Principal:principalName, Type:principalType, Role:roleDefinitionName, Scope:scope}" `
  --output table
```

Resource group location deny test:

```powershell
az group create `
  --name rg-p3-denytest-eastus `
  --location eastus `
  --tags Environment=dev Project=Azawslab-Release2 Owner=Hashib CostCenter=Lab
```

Mandatory tag deny retest:

```powershell
az group create `
  --name rg-p3-denytest-missing-tags-afterfix `
  --location norwayeast
```

VM SKU deny test:

```powershell
az vm create `
  --resource-group rg-p3-denytest-vmsku `
  --name vm-p3-deny-sku-01 `
  --image Ubuntu2204 `
  --size Standard_B1s `
  --admin-username azureuser `
  --generate-ssh-keys
```

Terraform validation:

```powershell
terraform -chdir="terraform\governance" fmt -check
terraform -chdir="terraform\governance" init
terraform -chdir="terraform\governance" validate
terraform -chdir="terraform\governance" plan -no-color -input=false
```

## 9. Lessons Learned

The main lesson from P3 was that governance must be validated by behavior, not assumed from policy assignment presence.

The mandatory tag issue was especially valuable. The environment had tag policies assigned, but the first resource group test proved that the policy did not enforce the intended control. The root cause was the difference between Azure Policy modes:

- `Indexed` policies apply to resources that support tags and location in the indexed resource model.
- `All` policies are required for broader scopes such as resource groups.

This changed the implementation from “policies exist” to “policies demonstrably enforce the platform rules.”

A second operational lesson was the importance of keeping Terraform remote-state references aligned after backend migration. The workload root’s backend configuration was correct, but its remote-state data source still referenced the retired UK South backend. GitHub Actions CI exposed this issue before further deployment.

## 10. Recruiter-Ready Outcome Statement

Implemented and validated enterprise governance guardrails for an Azure landing zone using Terraform, Azure Policy, management group assignments, and GitHub Actions OIDC. Proved enforcement through real deny tests for non-approved regions, missing mandatory tags, and disallowed VM SKUs. Diagnosed and corrected a policy design gap where resource tags were not enforced on resource groups, added the correct `All` mode resource group tag policies, deployed the fix through controlled CI/CD, and retested successfully with CLI evidence.

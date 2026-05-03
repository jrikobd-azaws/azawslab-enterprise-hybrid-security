# Phase-by-Phase Implementation Guide - Release 2

**Version:** 4.0  
**Aligns with:** `README_PLAN.md`, `implementation-tracker.md`, and `naming-conventions.md`  
**Purpose:** Operator-focused execution guide for Release 2 with key configuration snapshots, execution order, validation gates, evidence expectations, and teardown reminders.  
**Primary Rule:** If this guide conflicts with `README_PLAN.md`, follow `README_PLAN.md` and then update this file.

---

## 1. How to Use This Guide

This file is the working execution guide for Release 2.

Use it to:
- understand each phase quickly
- confirm the intended configuration before deployment
- execute the work in the correct order
- validate outcomes and capture evidence
- remember teardown requirements for ephemeral resources

This file is practical and execution-focused.  
`README_PLAN.md` remains the architectural source of truth.

---

## 2. Global Assumptions

- **Deployability validation rule:** candidate VM regions and SKUs must be validated against actual subscription-level availability before final implementation alignment
- **Primary region:** `norwayeast`
- **Primary source of truth:** `README_PLAN.md`
- **Evidence root:** `docs/release2/evidence/`
- **Routing standard for hybrid phases:** **VyOS**, not RRAS
- **CLI-first validation:** preferred over portal-only screenshots
- **Private-only workload principle:** workload VMs do not receive public IPs unless explicitly required by design
- **FinOps rule:** expensive optional phases should be destroyed after validation unless needed by the next phase

### Implementation alignment note
Region and VM size were treated as a subscription-and-region validation task rather than a static assumption.  
Because Azure SKU availability and restrictions vary over time by subscription, region, and capacity, deployable options were validated first and the Terraform implementation was then aligned to the confirmed target:

- Region: `norwayeast`
- VM SKU: `Standard_B2als_v2`

---

## 3. Global Addressing and Topology Snapshot

### Key Configuration Snapshot
- **Azure Hub VNet:** `10.0.0.0/16`
- **Azure Workload Spoke:** `10.10.0.0/16`
- **Azure Optional Extra / AVD Spoke:** `10.2.0.0/16`
- **On-prem simulated network:** `192.168.1.0/24`
- **AWS branch VPC:** `172.16.0.0/16`

### Resource Group Intent
- **Connectivity RG:** `rg-connectivity-prod-norwayeast`
- **Workload RG:** `rg-dev-workload-norwayeast`
- **Identity RG:** `rg-identity-prod-norwayeast`
- **Terraform state RG:** `rg-dev-terraformstate-norwayeast`
- **Security RG:** `rg-dev-security-norwayeast`

### Identity / Namespace Snapshot
- **Entra tenant namespace:** `entra.azawslab.co.uk`
- **HQ AD domain:** `hq.azawslab.co.uk`
- **Branch namespace:** `br1.azawslab.co.uk`

### Text Diagram
```text
[Entra ID: entra.azawslab.co.uk]
              |
      [Azure Subscription]
              |
   -----------------------------------------
   |                   |                   |
   v                   v                   v
[Connectivity]      [Identity]        [Workload/Security]
 rg-connectivity    rg-identity       rg-dev-workload / rg-dev-security

Azure address space:
  Hub        = 10.0.0.0/16
  Workload   = 10.10.0.0/16
  Optional   = 10.2.0.0/16

External connected domains:
  On-prem HQ = 192.168.1.0/24
  AWS Branch = 172.16.0.0/16
```

---

## 4. Pre-Execution Checklist

Complete these before Phase P0:

- [ ] `README_PLAN.md` confirmed as current source of truth
- [ ] `implementation-tracker.md` aligned
- [ ] `naming-conventions.md` aligned
- [ ] stale RRAS references removed from Release 2 support docs
- [ ] GitHub environment `release-2` created
- [ ] Azure subscription context confirmed
- [ ] `entra.azawslab.co.uk` verified in Entra ID
- [ ] no CIDR overlap confirmed across Azure / on-prem / AWS
- [ ] evidence folders created under `docs/release2/evidence/`

---

## 5. Recommended Execution Order

### Core Phases
`P0 -> P1 -> P2a -> P2b -> P2c -> P3 -> P5 -> P7 -> P8 -> P9a -> P9b -> P9c`

### Optional / Advanced Phases
- `P4` Azure Lighthouse
- `P6` Azure Firewall
- `O1` FortiGate NVA dual-firewall pattern
- `O2` Azure Arc
- `O3a` FortiGate <-> VyOS BGP over IPSec
- `O3b` AWS Cisco branch with segmented BGP
- `O3c` global transit / transitive routing validation
- `O4` Entra Global Secure Access
- `O5` Azure Virtual Desktop + FSLogix

---

# PHASE P0: FOUNDATION & AUTOMATION BOOTSTRAP
=============================================

## Objective
Establish secretless authentication between GitHub Actions and Azure using OIDC, deploy the remote Terraform backend, and scaffold the repository structure.

## Key Configuration Snapshot
- **App registration / SPN:** `sp-terraform-gh`
- **GitHub environment:** `release-2`
- **Terraform backend RG:** `rg-dev-terraformstate-norwayeast`
- **Terraform state storage account:** `stdevtfstatene01`
- **Terraform state container:** `tfstate`
- **Region:** `norwayeast`

## Text Diagram
```text
[GitHub Repo / Actions]
        |
        | OIDC federated credential
        v
[Entra App / SPN: sp-terraform-gh]
        |
        | Contributor on subscription
        v
[Azure Subscription]
        |
        v
[RG: rg-dev-terraformstate-norwayeast]
        |
        v
[Storage: stdevtfstatene01]
        |
        v
[Container: tfstate]
```

## Steps

### Step P0.1 - Confirm Azure context
```bash
az account show --output table
az account list --output table
```

### Step P0.2 - Create app registration and service principal
```bash
az ad app create --display-name "sp-terraform-gh" --sign-in-audience AzureADMyOrg

APP_ID=$(az ad app list --display-name "sp-terraform-gh" --query "[0].appId" -o tsv)
OBJECT_ID=$(az ad app list --display-name "sp-terraform-gh" --query "[0].id" -o tsv)

az ad sp create --id "$APP_ID"

SUB_ID=$(az account show --query id -o tsv)
az role assignment create --assignee "$APP_ID" --role Contributor --scope "/subscriptions/$SUB_ID"
```

### Step P0.3 - Create federated credential
```bash
az ad app federated-credential create --id "$OBJECT_ID" --parameters '{
  "name": "github-actions-release2",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:your-username/your-repo:environment:release-2",
  "audiences": ["api://AzureADTokenExchange"]
}'
```

### Step P0.4 - Create Terraform backend
```bash
az group create --name rg-dev-terraformstate-norwayeast --location norwayeast

az storage account create \
  --name stdevtfstatene01 \
  --resource-group rg-dev-terraformstate-norwayeast \
  --location norwayeast \
  --sku Standard_LRS \
  --kind StorageV2

ACCOUNT_KEY=$(az storage account keys list \
  --account-name stdevtfstatene01 \
  --resource-group rg-dev-terraformstate-norwayeast \
  --query "[0].value" -o tsv)

az storage container create \
  --name tfstate \
  --account-name stdevtfstatene01 \
  --account-key "$ACCOUNT_KEY"
```

### Step P0.5 - Scaffold repo layout
```bash
mkdir -p terraform/modules
mkdir -p terraform/environments/dev
mkdir -p ansible/roles
mkdir -p ansible/inventory/dev
mkdir -p .github/workflows
mkdir -p docs/release2/evidence/{P0,P1,P2a,P2b,P2c,P3,P4,P5,P6,P7,P8,P9a,P9b,P9c,O1,O2,O3a,O3b,O3c,O4,O5}
```

## Minimum Validation
- [ ] OIDC test workflow succeeds
- [ ] service principal has Contributor at subscription scope
- [ ] backend `terraform init` succeeds

## Suggested Evidence
- `docs/release2/evidence/P0/oidc-test.txt`
- `docs/release2/evidence/P0/backend-init.txt`
- `docs/release2/evidence/P0/role-assignment.txt`

---

# PHASE P1: AZURE LANDING ZONE & GOVERNANCE FOUNDATION
======================================================

## Objective
Deploy the management group hierarchy and baseline policy guardrails.

## Key Configuration Snapshot
- **Management groups:**
  - `mg-platform-prod-global`
  - `mg-landingzones-prod-global`
  - `mg-sandbox-prod-global`
- **Subscription target parent:** `mg-landingzones-prod-global`
- **Policy themes:**
  - allowed locations = finalized implementation region
  - allowed VM SKUs = validated approved SKU set
  - mandatory tags

## Text Diagram
```text
[Tenant Root Group]
      |
      +-- [mg-platform-prod-global]
      |
      +-- [mg-landingzones-prod-global]
      |          |
      |          v
      |   [Azure Subscription]
      |
      +-- [mg-sandbox-prod-global]

Policy intent at mg-landingzones:
  - finalized allowed region
  - validated allowed VM SKU set
  - mandatory tags
```

## Steps

### Step P1.1 - Create management groups
```bash
az account management-group create --name mg-platform-prod-global --display-name "mg-platform-prod-global"
az account management-group create --name mg-landingzones-prod-global --display-name "mg-landingzones-prod-global"
az account management-group create --name mg-sandbox-prod-global --display-name "mg-sandbox-prod-global"
```

### Step P1.2 - Move subscription under landing zones
```bash
SUB_ID=$(az account show --query id -o tsv)

az account management-group subscription add \
  --name mg-landingzones-prod-global \
  --subscription "$SUB_ID"
```

### Step P1.3 - Verify hierarchy
```bash
az account management-group show --name mg-landingzones-prod-global --expand --output json
```

### Step P1.4 - Deploy custom policies
Implement in `terraform/environments/dev/policies.tf`.

Required controls:
- allowed locations = `norwayeast`
- allowed VM SKUs = validated approved SKU list including `Standard_B2als_v2`
- mandatory tags

## Minimum Validation
- [ ] management groups visible
- [ ] subscription nested correctly
- [ ] policy assignments active
- [ ] deny behavior confirmed with non-compliant test

## Suggested Evidence
- `docs/release2/evidence/P1/mg-hierarchy.txt`
- `docs/release2/evidence/P1/policy-assignments.txt`
- `docs/release2/evidence/P1/deny-test-region.txt`

---

# PHASE P2a: TERRAFORM - REUSABLE MODULES
=========================================

## Objective
Create reusable Terraform modules for secure, repeatable Azure deployment.

## Key Configuration Snapshot
- **Module families:**
  - `security`
  - `networking`
  - `compute`
  - `monitoring`
- **Security intent:**
  - Key Vault-backed secret handling
  - dynamic password generation
- **Compute intent:**
  - private-only NIC
  - no workload public IP
  - validated VM SKU = `Standard_B2als_v2`
- **Monitoring intent:**
  - shared Log Analytics workspace

## Text Diagram
```text
[terraform/governance]
        |
        +--> management-group policy assignments

[terraform/platform-shared/dev]
        |
        +--> [modules/security]
                  |
                  +--> Key Vault
                  +--> random_password
                  +--> secret flow

[terraform/workloads/dev]
        |
        +--> [modules/networking]
        |         |
        |         +--> workload VNet / subnet
        |
        +--> [modules/compute]
                  |
                  +--> private-only VM + NIC

[optional future root if monitoring is separated]
        |
        +--> [modules/monitoring]
                  |
                  +--> Log Analytics
```

## Suggested Structure
```text
terraform/
|-- governance/
|   |-- main.tf
|   `-- providers.tf
|-- platform-shared/
|   `-- dev/
|       |-- main.tf
|       |-- outputs.tf
|       `-- providers.tf
|-- workloads/
|   `-- dev/
|       |-- main.tf
|       `-- providers.tf
`-- modules/
    |-- compute/
    |-- monitoring/
    |-- networking/
    `-- security/
```

## Steps

### Step P2a.1 - Create module folders
```bash
mkdir -p terraform/modules/{security,networking,compute,monitoring}
```

### Step P2a.2 - Build security module
Include:
- Resource Group: `rg-dev-security-norwayeast`
- Key Vault: `kvdevazawsne01`
- `random_password`
- secret storage for VM admin password

### Step P2a.3 - Build networking module
Include:
- workload VNet = `vnet-dev-norwayeast-spoke-workload`
- workload subnet = `snet-workload`
- workload address space = `10.10.0.0/16`
- workload subnet prefix = `10.10.0.0/24`

### Step P2a.4 - Build compute module
Include:
- NIC without public IP
- workload VM = `vm-dev-client-01`
- validated VM SKU = `Standard_B2als_v2`
- secure admin secret flow
- standard storage type aligned to low-cost design where intended

### Step P2a.5 - Build monitoring module
Include:
- Log Analytics workspace
- shared monitoring dependencies as needed

### Step P2a.6 - Validate and deploy
```bash
cd terraform/environments/dev
terraform fmt
terraform init
terraform validate
terraform plan -out tfplan-p2a
terraform apply "tfplan-p2a"
```

### Step P2a.7 - Terraform state boundary refinement
Separate Terraform root/state ownership was implemented to align lifecycle boundaries while keeping the reusable module structure unchanged.

Active Terraform roots:
- `terraform/governance`
- `terraform/platform-shared/dev`
- `terraform/workloads/dev`

Ownership split:
- `terraform/governance` manages management-group policy assignments
- `terraform/platform-shared/dev` manages shared security resources such as Key Vault and secret flow
- `terraform/workloads/dev` manages workload networking and compute resources

Validation outcome:
- each Terraform root initializes successfully
- each Terraform root plans cleanly
- destroy risk is reduced because governance, shared security, and workload resources are no longer coupled in a single state

## Minimum Validation
- [ ] `terraform validate` succeeds
- [ ] `terraform plan` succeeds
- [ ] VM created successfully in `norwayeast`
- [ ] password handled as sensitive
- [ ] workload NIC has no public IP

## Suggested Evidence
- `docs/release2/evidence/P2a/tf-validate.txt`
- `docs/release2/evidence/P2a/tf-plan.txt`
- `docs/release2/evidence/P2a/vm-validation-norwayeast.txt`

---

# PHASE P2b: ANSIBLE CONFIGURATION MANAGEMENT
=============================================

## Objective
Apply post-deployment configuration using reusable Ansible roles.

## Execution Environment Note
For this project, P2b is executed from a separate Azure-connected management host in the same Azure subscription.

This management host is treated as an operations-plane resource, not as part of the workload tier. The workload VM remains private-only.

## Key Configuration Snapshot
- **Roles:**
  - `common`
  - `ad-join`
  - `webserver`
- **Execution model:**
  - Ansible runs from a separate Azure-connected management host
  - the management host is an operations-plane resource
  - the workload VM remains private-only
- **Subscription model:**
  - same Azure subscription
  - separation is by role, network path, and lifecycle
- **Validation standard:** lint + successful run + idempotent rerun
- **Lifecycle note:**
  - management host should be kept minimal
  - deallocate or destroy it after P2b validation unless needed by the next dependent phase

## Text Diagram
```[Azure Subscription]
        |
        +------------------------------------------------------------------+
        |                                |                                 |
        v                                v                                 v
[Governance Plane]              [Shared Security Plane]           [Management Plane - P2b]
policy assignments              rg-dev-security-norwayeast        rg-dev-management-norwayeast
                                kvdevazawsne01                    vm-dev-mgmt-01
                                                                  snet-management
                                                                  Ansible control node
                                                                          |
                                                                          | private management path
                                                                          | WinRM
                                                                          v
                                                          [Workload Plane]
                                                          rg-dev-workload-norwayeast
                                                          vnet-dev-norwayeast-spoke-workload
                                                          snet-workload
                                                          vm-dev-client-01
                                                          private-only
```

## Steps

### Step P2b.1 - Create role structure
```bash
mkdir -p ansible/roles/{common,ad-join,webserver}/{tasks,vars,handlers}
```

### Step P2b.2 - Create playbook structure
```bash
touch ansible/site.yml
mkdir -p ansible/inventory/dev
```

### Step P2b.3 - Build inventory
Use private IP addressing and the management access path provided by the Azure-connected management host.

Operational rule:
- the management host is not part of the workload tier
- the workload VM remains private-only
- Ansible execution for P2b should originate from the management host rather than from a general local laptop path

### Step P2b.4 - Run lint
```bash
cd ansible
ansible-lint site.yml
```

### Step P2b.5 - Execute playbook
```bash
cd ansible
ansible-playbook -i inventory/dev/hosts.yml site.yml
```

### Step P2b.6 - Re-run for idempotency
```bash
cd ansible
ansible-playbook -i inventory/dev/hosts.yml site.yml
```
### Step P2b.7 - Management host lifecycle control
Treat the P2b management host as a temporary operations-plane resource.

Requirements:
- keep the management host minimal
- do not present it as part of the business/application workload
- retain only as long as required for P2b validation or the next dependent phase
- deallocate or destroy it promptly when no longer required

## Minimum Validation
- [ ] `ansible-lint` passes
- [ ] first run succeeds
- [ ] second run is idempotent
- [ ] domain join verified where applicable
- [ ] IIS / application deployment verified where applicable

## Suggested Evidence
- `docs/release2/evidence/P2b/ansible-lint.txt`
- `docs/release2/evidence/P2b/ansible-run-01.txt`
- `docs/release2/evidence/P2b/ansible-run-02-idempotent.txt`
- `docs/release2/evidence/P2b/domain-join-check.txt`

---

# PHASE P2c: CI/CD PIPELINE (GITHUB ACTIONS + OIDC)
===================================================

## Objective
Create secretless GitHub-based CI/CD with PR validation and controlled apply.

## Key Configuration Snapshot
- **Workflows:**
  - `oidc-test.yml`
  - `tf-ci.yml`
  - `tf-cd.yml`
- **GitHub environment:** `release-2`
- **Core checks:**
  - OIDC login
  - Terraform fmt / validate / plan
  - controlled apply on merge

## Text Diagram
```text
[feature branch]
      |
      v
[Pull Request]
      |
      +--> CI workflow
      |      |
      |      +--> OIDC login
      |      +--> terraform fmt/validate/plan
      |
      v
[Review / Approval]
      |
      v
[Merge to protected branch]
      |
      v
[CD workflow]
      |
      +--> OIDC login
      +--> terraform apply
```

## Steps

### Step P2c.1 - Create OIDC test workflow
Create `.github/workflows/oidc-test.yml`.

### Step P2c.2 - Create Terraform CI workflow
Required checks:
- checkout
- Azure login via OIDC
- setup Terraform
- `terraform fmt -check`
- `terraform init`
- `terraform validate`
- `terraform plan`

### Step P2c.3 - Create Terraform CD workflow
Required flow:
- push/merge to controlled branch
- Azure login via OIDC
- `terraform init`
- `terraform apply -auto-approve`

### Step P2c.4 - Configure branch protection
Require:
- pull request
- required checks
- reviewer approval

## Minimum Validation
- [ ] PR triggers plan workflow
- [ ] plan output visible
- [ ] merge triggers apply
- [ ] workflows succeed

## Suggested Evidence
- `docs/release2/evidence/P2c/oidc-workflow-run.txt`
- `docs/release2/evidence/P2c/terraform-plan-pr-comment.txt`
- `docs/release2/evidence/P2c/terraform-apply-run.txt`
- `docs/release2/evidence/P2c/branch-protection-notes.md`

---

# PHASE P3: ENTERPRISE GOVERNANCE & GUARDRAILS
==============================================

## Objective
Enforce regional compliance, cost control, tagging, and least-privilege access.

## Key Configuration Snapshot
- **Allowed region:** `norwayeast`
- **Allowed VM SKU set:** validated approved list including `Standard_B2als_v2`
- **Mandatory tags:** at minimum `Environment`, `Project`, `Owner`, `CostCenter`
- **RBAC focus:** least privilege for automation and operator roles

## Text Diagram
```text
[Management Group Policy Layer]
             |
             +--> Allowed region = norwayeast
             +--> Allowed SKUs   = validated approved set
             +--> Mandatory tags
             +--> RBAC review
```

## Steps
- confirm custom policies deployed
- confirm assignments at correct scope
- test deny behavior
- review RBAC assignments

## Suggested Validation Commands
```bash
az policy assignment list --scope "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global" --output table
az role assignment list --scope "/subscriptions/$(az account show --query id -o tsv)" --output table
```

## Minimum Validation
- [ ] non-approved region deployment denied
- [ ] disallowed SKU denied
- [ ] missing-tag deployment denied
- [ ] RBAC assignments verified

## Suggested Evidence
- `docs/release2/evidence/P3/policy-state.txt`
- `docs/release2/evidence/P3/deny-test-region.txt`
- `docs/release2/evidence/P3/deny-test-sku.txt`
- `docs/release2/evidence/P3/deny-test-tags.txt`
- `docs/release2/evidence/P3/rbac-assignments.txt`

---

# PHASE P4: AZURE LIGHTHOUSE
============================

## Objective
Demonstrate delegated cross-tenant administration.

## Key Configuration Snapshot
- **Capability:** delegated access from a managing tenant
- **Artifacts:** registration definition + registration assignment

## Text Diagram
```text
[Managing Tenant]
       |
       | delegated access
       v
[Customer / Target Subscription]
       |
       v
[Visible delegated resources]
```

## Steps
- deploy registration definition
- deploy registration assignment
- verify delegated access

## Minimum Validation
- [ ] delegated resources visible
- [ ] cross-tenant read action succeeds

## Suggested Evidence
- `docs/release2/evidence/P4/lighthouse-registration.txt`
- `docs/release2/evidence/P4/cross-tenant-visibility.txt`

---

# PHASE P5: HUB-SPOKE NETWORKING
================================

## Objective
Deploy the core Azure network fabric used by the rest of the platform.

## Key Configuration Snapshot
- **Hub VNet:** `vnet-dev-norwayeast-hub`
- **Hub CIDR:** `10.0.0.0/16`
- **Workload spoke:** `vnet-dev-norwayeast-spoke-workload`
- **Workload CIDR:** `10.10.0.0/16`
- **Optional additional spoke:** `10.2.0.0/16`
- **Route table:** `rt-udr-to-firewall-norwayeast`

## Text Diagram
```text
               [Hub VNet]
              10.0.0.0/16
                  / \
                 /   \
                v     v
 [Workload Spoke]     [Optional Spoke]
   10.10.0.0/16          10.2.0.0/16
```

## Steps
- deploy hub VNet
- deploy spoke VNet(s)
- create subnets
- configure peerings
- apply NSGs and UDRs where needed

## Suggested Validation Commands
```bash
az network vnet list -o table
az network vnet peering list --resource-group rg-connectivity-prod-norwayeast --vnet-name vnet-dev-norwayeast-hub -o table
```

## Minimum Validation
- [ ] VNets deployed
- [ ] peerings connected
- [ ] route tables associated correctly
- [ ] private connectivity works

## Suggested Evidence
- `docs/release2/evidence/P5/vnet-list.txt`
- `docs/release2/evidence/P5/vnet-peering.txt`
- `docs/release2/evidence/P5/route-table-validation.txt`

---

# PHASE P6: AZURE FIREWALL
==========================

## Objective
Validate internet egress inspection and forced tunneling with Azure Firewall.

## Key Configuration Snapshot
- **Firewall name:** `afw-dev-norwayeast-01`
- **Firewall policy:** `afwp-dev-norwayeast`
- **Public IP:** `pip-azfw-norwayeast-01`
- **Route table:** `rt-udr-to-firewall-norwayeast`
- **Traffic intent:** `0.0.0.0/0` routed to Azure Firewall
- **Budget note:** ephemeral unless needed by later optional phases

## Text Diagram
```text
[Workload Spoke]
      |
      | default route 0.0.0.0/0
      v
[Azure Firewall]
      |
      v
[Internet]
```

## Steps
- deploy Azure Firewall
- deploy Firewall Policy
- attach UDR for default route
- create allow and deny rules
- validate traffic path

## Minimum Validation
- [ ] outbound path goes through firewall
- [ ] deny rule blocks expected test
- [ ] logs show inspected traffic

## Suggested Evidence
- `docs/release2/evidence/P6/firewall-deploy.txt`
- `docs/release2/evidence/P6/udr-validation.txt`
- `docs/release2/evidence/P6/blocked-request-test.txt`
- `docs/release2/evidence/P6/firewall-log-query.txt`

## Teardown Reminder
Destroy Azure Firewall after validation unless needed for O1.

---

# PHASE P7: DEFENDER FOR CLOUD
==============================

## Objective
Enable cloud security posture management and recommendations.

## Key Configuration Snapshot
- **Main outputs:** enabled plans, secure score, recommendations
- **Scope:** target subscription / workloads in Release 2

## Text Diagram
```text
[Azure Resources]
      |
      v
[Defender for Cloud]
      |
      +--> plans enabled
      +--> recommendations
      +--> secure score
```

## Steps
- enable required Defender plans
- review recommendations
- capture secure score

## Minimum Validation
- [ ] plans enabled
- [ ] recommendations visible
- [ ] secure score captured

## Suggested Evidence
- `docs/release2/evidence/P7/defender-plan-status.txt`
- `docs/release2/evidence/P7/secure-score.txt`
- `docs/release2/evidence/P7/recommendations-summary.md`

---

# PHASE P8: MICROSOFT SENTINEL
==============================

## Objective
Enable SIEM capabilities on the shared monitoring workspace.

## Key Configuration Snapshot
- **Dependency:** Log Analytics workspace
- **Core outputs:** connectors, analytics rules, incidents

## Text Diagram
```text
[Azure / Security Data Sources]
             |
             v
   [Log Analytics Workspace]
             |
             v
   [Microsoft Sentinel]
             |
             +--> connectors
             +--> analytics
             +--> incidents
```

## Steps
- enable Sentinel on workspace
- configure data connectors
- enable or deploy analytics rules
- validate incident generation path

## Minimum Validation
- [ ] connectors healthy
- [ ] analytics rule active
- [ ] incident generated or observed

## Suggested Evidence
- `docs/release2/evidence/P8/sentinel-enable.txt`
- `docs/release2/evidence/P8/connector-status.txt`
- `docs/release2/evidence/P8/analytics-rule-status.txt`
- `docs/release2/evidence/P8/incident-validation.txt`

---

# PHASE P9a: AZURE MONITOR ALERTS
=================================

## Objective
Create platform alerts and verify response flow.

## Key Configuration Snapshot
- **Core artifacts:** action group + alert rule
- **Validation target:** successful firing and notification path

## Text Diagram
```text
[Azure Resource Metric / Signal]
            |
            v
       [Alert Rule]
            |
            v
      [Action Group]
            |
            v
[Notification / Response Path]
```

## Steps
- create action group
- create alert rule
- attach target resource
- generate test signal where possible

## Minimum Validation
- [ ] alert rule enabled
- [ ] action group linked
- [ ] alert fired successfully

## Suggested Evidence
- `docs/release2/evidence/P9a/action-group.txt`
- `docs/release2/evidence/P9a/alert-rule.txt`
- `docs/release2/evidence/P9a/alert-validation.txt`

---

# PHASE P9b: BACKUP / RECOVERY SERVICES VAULT
=============================================

## Objective
Validate backup governance, protection coverage, and recovery controls.

## Key Configuration Snapshot
- **Core vault:** Recovery Services Vault
- **Protection elements:** backup policy, protected item
- **Advanced option:** Resource Guard / MUA

## Text Diagram
```text
[Protected Azure Resource]
          |
          v
[Backup Policy]
          |
          v
[Recovery Services Vault]
          |
          +--> retention / immutability
          +--> protection state
```

## Steps
- deploy Recovery Services Vault
- configure backup policy
- register protected item
- review protection settings
- configure Resource Guard / MUA if included

## Minimum Validation
- [ ] protected item visible
- [ ] policy assigned
- [ ] backup state confirmed

## Suggested Evidence
- `docs/release2/evidence/P9b/rsv-deploy.txt`
- `docs/release2/evidence/P9b/backup-policy.txt`
- `docs/release2/evidence/P9b/protected-item-status.txt`

---

# PHASE P9c: FINAL VALIDATION & PORTFOLIO EVIDENCE PACK
=======================================================

## Objective
Close the build loop, verify documentation consistency, and prepare portfolio evidence.

## Key Configuration Snapshot
- **Final outputs:** evidence completeness, cost review, clean internal references
- **Operator goal:** leave the project understandable and reusable

## Text Diagram
```text
[Completed Phases]
       |
       v
[Validation Review]
       |
       +--> evidence present
       +--> costly resources reviewed
       +--> docs links checked
       |
       v
[Portfolio-ready Release 2]
```

## Steps
- review all mandatory phases
- confirm evidence files exist
- remove stale notes
- verify teardown for ephemeral resources
- verify docs navigation and filenames
- prepare concise recruiter-facing summary

## Onboarding / Re-run Notes
1. Read `README_PLAN.md`
2. Review `implementation-tracker.md`
3. Use this file for execution order
4. Use `naming-conventions.md` during resource creation
5. Store all outputs under `docs/release2/evidence/`

## Minimum Validation
- [ ] all mandatory evidence present
- [ ] no unintended costly resources remain
- [ ] internal file references resolve correctly

## Suggested Evidence
- `docs/release2/evidence/P9c/phase-completion-summary.md`
- `docs/release2/evidence/P9c/resource-final-state.txt`
- `docs/release2/evidence/P9c/cost-review.txt`

---

# PHASE O1: FORTIGATE NVA DUAL-FIREWALL PATTERN
===============================================

## Objective
Add FortiGate for East-West and hybrid traffic while Azure Firewall handles internet egress.

## Key Configuration Snapshot
- **Azure Firewall:** internet egress
- **FortiGate:** East-West + hybrid routing / inspection
- **Traffic steering:**
  - `0.0.0.0/0` -> Azure Firewall
  - internal / hybrid prefixes -> FortiGate
- **FortiGate VM:** `vm-dev-fortigate-01`
- **FortiGate public IP:** `pip-fortigate-norwayeast-01`
- **FortiGate route table:** `rt-udr-to-fortigate-norwayeast`

## Text Diagram
```text
                 [Azure Firewall]
                      ^
                      | 0.0.0.0/0
[Workload Spokes] ----+
                      |
                      v internal / hybrid
                 [FortiGate NVA]
```

## Steps
- deploy FortiGate
- configure hybrid / East-West UDRs
- confirm traffic steering intent
- validate traffic path and logs

## Minimum Validation
- [ ] UDR steering works
- [ ] East-West path validated
- [ ] required logs captured

## Suggested Evidence
- `docs/release2/evidence/O1/udr-steering.txt`
- `docs/release2/evidence/O1/traffic-validation.txt`

## Teardown Reminder
Destroy FortiGate after validation if not needed for O3a.

---

# PHASE O2: AZURE ARC
=====================

## Objective
Project non-Azure machines into Azure management.

## Key Configuration Snapshot
- **Target:** on-prem or external machine
- **Outcome:** visible and manageable through Azure Arc

## Text Diagram
```text
[Non-Azure Machine]
        |
        | Arc agent
        v
[Azure Arc]
        |
        +--> visibility
        +--> policy/tag scope
        +--> management metadata
```

## Steps
- install Arc agent
- connect machine to Azure
- verify visibility and metadata

## Minimum Validation
- [ ] machine appears connected
- [ ] management visibility confirmed

## Suggested Evidence
- `docs/release2/evidence/O2/arc-connect.txt`
- `docs/release2/evidence/O2/arc-machine-status.txt`

---

# PHASE O3a: FORTIGATE <-> VyOS BGP OVER IPSEC
==============================================

## Objective
Establish hybrid connectivity between Azure and the on-prem simulated environment using FortiGate on Azure and VyOS on Hyper-V with BGP over IPSec.

## Key Configuration Snapshot
- **Azure edge:** FortiGate NVA
- **On-prem edge:** VyOS
- **Azure / FortiGate ASN:** `65515`
- **On-prem VyOS ASN:** `65001`
- **On-prem advertised prefix:** `192.168.1.0/24`

## Text Diagram
```text
             [Azure FortiGate NVA]
                  (ASN 65515)
                        ||
                   IPSec + BGP
                        ||
                 [VyOS On-Prem Edge]
                    (ASN 65001)
                        |
                        v
                [192.168.1.0/24 HQ Lab]
```

## Steps
- prepare VyOS
- configure IPSec
- configure BGP
- validate routing tables and tunnel state

## Minimum Validation
- [ ] IPSec tunnel established
- [ ] BGP session up
- [ ] Azure learns `192.168.1.0/24`
- [ ] VyOS learns intended Azure prefixes
- [ ] end-to-end reachability succeeds

## Suggested Evidence
- `docs/release2/evidence/O3a/ipsec-status.txt`
- `docs/release2/evidence/O3a/bgp-summary-vyos.txt`
- `docs/release2/evidence/O3a/route-table-validation.txt`
- `docs/release2/evidence/O3a/end-to-end-connectivity.txt`

## Teardown Reminder
Destroy cloud-side ephemeral components after validation if not required for O3c.

---

# PHASE O3b: AWS CISCO BRANCH WITH SEGMENTED BGP
================================================

## Objective
Extend the hybrid design into AWS using a Cisco branch NVA and segmented route propagation.

## Key Configuration Snapshot
- **Transit side:** Azure FortiGate
- **Branch side:** Cisco NVA in AWS
- **AWS branch ASN:** `65002`
- **Example branch prefixes:**
  - `172.16.1.0/24`
  - `172.16.2.0/24`

## Text Diagram
```text
          [Azure FortiGate NVA]
               (Transit Hub)
                     ||
                IPSec + BGP
                     ||
             [AWS Cisco Branch NVA]
                 (ASN 65002)
                    /   \
                   /     \
                  v       v
         172.16.1.0/24  172.16.2.0/24
```

## Steps
- build AWS VPC
- deploy Cisco NVA
- establish VPN/BGP path
- validate route segmentation

## Minimum Validation
- [ ] Cisco branch deployed
- [ ] BGP route propagation works
- [ ] intended segmentation verified

## Suggested Evidence
- `docs/release2/evidence/O3b/aws-vpc-build.txt`
- `docs/release2/evidence/O3b/cisco-bgp-status.txt`
- `docs/release2/evidence/O3b/branch-route-validation.txt`

## Teardown Reminder
Destroy AWS branch resources after validation.

---

# PHASE O3c: TRANSITIVE ROUTING (GLOBAL HUB)
============================================

## Objective
Validate end-to-end transit routing across Azure, on-prem, and AWS with Azure FortiGate acting as the central transit hub.

## Key Configuration Snapshot
- **Transit hub:** Azure FortiGate NVA
- **Transit hub ASN:** `65515`
- **On-prem HQ ASN:** `65001`
- **AWS branch ASN:** `65002`
- **On-prem HQ prefix:** `192.168.1.0/24`
- **AWS branch prefixes:**
  - `172.16.1.0/24`
  - `172.16.2.0/24`

## Text Diagram
```text
                    [Azure FortiGate NVA] (ASN 65515)
                           /        \
                          /          \
                         v            v
                 [On-Prem HQ]    [AWS Branch]
                  (ASN 65001)     (ASN 65002)
```

## Steps
- confirm all BGP adjacencies are healthy
- verify propagated routes on every side
- test AWS-to-HQ and HQ-to-AWS pathing
- record packet path notes

## Minimum Validation
- [ ] HQ learns AWS branch routes
- [ ] AWS learns HQ route
- [ ] traffic traverses FortiGate transit path
- [ ] traceroute / path test confirms expected middle hop

## Suggested Evidence
- `docs/release2/evidence/O3c/transit-route-summary.txt`
- `docs/release2/evidence/O3c/path-validation.txt`
- `docs/release2/evidence/O3c/packet-path-notes.md`

## Teardown Reminder
Destroy transient routing lab components when validation is complete.

---

# PHASE O4: ENTRA GLOBAL SECURE ACCESS
======================================

## Objective
Demonstrate Zero Trust private access as a modern alternative to legacy VPN dependence.

## Key Configuration Snapshot
- **Capability:** private access / SSE-style connectivity
- **Narrative goal:** show modern replacement path for legacy VPN-centric access

## Text Diagram
```text
[User / Remote Context]
         |
         v
[Entra Global Secure Access]
         |
         v
[Private App / Private Resource]
```

## Steps
- configure remote network
- deploy connector/dependencies where required
- define private access policy
- validate reachability

## Minimum Validation
- [ ] remote network configured
- [ ] private access path works
- [ ] replacement narrative vs legacy VPN documented

## Suggested Evidence
- `docs/release2/evidence/O4/remote-network-config.txt`
- `docs/release2/evidence/O4/private-access-validation.txt`

---

# PHASE O5: AZURE VIRTUAL DESKTOP + FSLOGIX
===========================================

## Objective
Deploy Azure Virtual Desktop with FSLogix profile containers and validate user session flow.

## Key Configuration Snapshot
- **Core components:**
  - host pool
  - workspace
  - application group
  - FSLogix-backed profile storage
- **Workspace:** `ws-dev-norwayeast`
- **Host pool:** `hp-dev-pooled`
- **App group:** `dag-dev-desktop`
- **FSLogix storage:** `stdevfslogix001`
- **FSLogix share:** `share-dev-fslogix`

## Text Diagram
```text
[User]
   |
   v
[AVD Workspace]
   |
   v
[Host Pool / Session Hosts]
   |
   v
[FSLogix Profile Storage]
```

## Steps
- deploy host pool
- deploy workspace
- deploy application group
- configure FSLogix storage
- assign access
- validate session behavior

## Minimum Validation
- [ ] host pool ready
- [ ] workspace assigned
- [ ] FSLogix path works
- [ ] user session validated

## Suggested Evidence
- `docs/release2/evidence/O5/host-pool-status.txt`
- `docs/release2/evidence/O5/fslogix-validation.txt`
- `docs/release2/evidence/O5/session-validation.txt`

## Teardown Reminder
Destroy session hosts after validation if cost-sensitive.

---

## 6. Evidence Folder Template

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

## 7. Final Operator Reminders

- Keep this file practical and execution-focused
- Keep `README_PLAN.md` as the architectural source of truth
- Do not reintroduce RRAS into Release 2 hybrid routing docs
- Keep configuration snapshots up to date if ASNs, prefixes, or resource names change
- Capture text evidence first, screenshots second
- Tear down expensive optional resources quickly
- Update `implementation-tracker.md` after each completed phase








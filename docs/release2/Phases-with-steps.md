# Phase-by-Phase Implementation Guide (Release 2)

**Version:** 1.0  
**Aligns with:** `README_PLAN_Revised.md` and `naming-conventions.md`  
**Prerequisites:** Azure Pay-As-You-Go subscription (upgraded from free trial), GitHub account, `entra.azawslab.co.uk` domain verified.

---

## Legend for Text Diagrams

| Symbol / Format | Meaning |
|----------------|---------|
| `[Resource Name]` | Azure resource or external system (VM, VNet, Key Vault, etc.) |
| `--(action)-->` | Dependency or trigger (e.g., OIDC token, role assignment) |
| `[Service Principal]` | Entra ID application / service principal |
| `(role)` | RBAC role assignment |
| `{branch}` | GitHub branch or environment |
| `======` | Separation between logical steps within a phase |

---

# Phase 0: Foundation & Automation Bootstrap

## Objective
Establish OIDC federation between GitHub Actions and Azure, deploy remote Terraform backend with state locking, and bootstrap the repository structure.

## Step-by-Step Actions

### Step 0.1: Upgrade subscription & verify domain
```bash
# Ensure subscription is Pay-As-You-Go
az account show --output table

# Verify verified domain in Entra ID
az account list --query "[?isDefault]" --output table
# Domain should show entra.azawslab.co.uk
```

### Step 0.2: Create service principal with OIDC federated credential
```bash
# Create app registration
az ad app create --display-name "sp-terraform-gh" --sign-in-audience AzureADMyOrg

# Get app ID and object ID
APP_ID=$(az ad app list --display-name "sp-terraform-gh" --query "[0].appId" -o tsv)
OBJECT_ID=$(az ad app list --display-name "sp-terraform-gh" --query "[0].id" -o tsv)

# Create service principal
az ad sp create --id $APP_ID

# Assign Contributor role at subscription level
SUB_ID=$(az account show --query id -o tsv)
az role assignment create --assignee $APP_ID --role Contributor --scope /subscriptions/$SUB_ID

# Create federated credential for GitHub (repo: your-username/your-repo, environment: release-2)
az ad app federated-credential create --id $OBJECT_ID --parameters '{
    "name": "github-actions-release2",
    "issuer": "[https://token.actions.githubusercontent.com](https://token.actions.githubusercontent.com)",
    "subject": "repo:your-username/your-repo:environment:release-2",
    "audiences": ["api://AzureADTokenExchange"]
}'
```

### Step 0.3: Deploy Terraform backend storage
```bash
# Create resource group
az group create --name rg-dev-terraformstate-uksouth --location uksouth

# Create storage account (globally unique name)
az storage account create \
    --name stdevterraform001 \
    --resource-group rg-dev-terraformstate-uksouth \
    --location uksouth \
    --sku Standard_LRS \
    --kind StorageV2

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --account-name stdevterraform001 --query "[0].value" -o tsv)

# Create container
az storage container create --name tfstate --account-name stdevterraform001 --account-key $ACCOUNT_KEY
```

### Step 0.4: Repository scaffolding
```bash
mkdir -p terraform/modules terraform/environments/dev
mkdir -p ansible/roles ansible/inventory/dev
mkdir -p .github/workflows
mkdir -p docs/release2/evidence/{P0,P1,P2a,P2b,P2c}
```

## Validation Checklist
- [ ] OIDC handshake test: Create `.github/workflows/oidc-test.yml` and see successful run.
- [ ] `az role assignment list --assignee $APP_ID` shows Contributor.
- [ ] `terraform init` succeeds with backend config.

## Text Diagram – Phase 0 Resources
```text
PHASE 0: FOUNDATION & OIDC BOOTSTRAP
=====================================

[GitHub Repo: your-username/your-repo]
         │
         │ {branch: release-2}
         │ (OIDC federated credential)
         ▼
[Entra ID App: sp-terraform-gh]
         │
         │ (Contributor role)
         ▼
[Subscription: sub-azaws-enterprise-prod]
         │
         │ (az group create)
         ▼
[Resource Group: rg-dev-terraformstate-uksouth]
         │
         │ (az storage account create)
         ▼
[Storage Account: stdevterraform001]
         │
         │ (container)
         ▼
[Container: tfstate]───(Blob lease – state locking)

LEGEND:
======>
[Name]        Azure resource or external system
(role)        RBAC assignment
{branch}      GitHub branch or environment
```

---

# Phase 1: Azure Landing Zone & Governance Foundation

## Objective
Deploy CAF-aligned management groups and enforce policy guardrails (allowed regions, VM SKUs, mandatory tags) at the root management group.

## Step-by-Step Actions

### Step 1.1: Create management groups
```bash
az account management-group create --name mg-platform-prod-global --display-name "mg-platform-prod-global"
az account management-group create --name mg-landingzones-prod-global --display-name "mg-landingzones-prod-global"
az account management-group create --name mg-sandbox-prod-global --display-name "mg-sandbox-prod-global"

# Show hierarchy
az account management-group show --name mg-platform-prod-global --expand --output table
```

### Step 1.2: Move subscription under mg-landingzones
```bash
SUB_ID=$(az account show --query id -o tsv)
az account management-group subscription add --name mg-landingzones-prod-global --subscription $SUB_ID
```

### Step 1.3: Deploy Azure Policies (using Terraform)
Create `terraform/environments/dev/policies.tf`:
```hcl
# Example: Deny non-UK South regions
resource "azurerm_policy_definition" "allowed_locations" {
  name         = "policy-allowed-locations"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Allowed locations for resources"

  metadata = <<METADATA { "category": "General" } METADATA policy_rule="<<POLICY_RULE" "if": "not": "field": "location", "in": ["uksouth"] }, "then": "effect": "deny" POLICY_RULE resource "azurerm_management_group_policy_assignment" "allowed_locations" name="polassign-allowed-locations-mg" management_group_id="mg-landingzones-prod-global" policy_definition_id="azurerm_policy_definition.allowed_locations.id" description="Deny any resource not in UK South" ``` Repeat for allowed VM SKUs (B-series only) and mandatory tags. ### Step 1.4: Apply policies ```bash terraform plan apply -auto-approve ## Validation Checklist - [ ] `az policy assignment list --scope "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"` shows three assignments. Attempt to create a in East US fails with `"denied by policy"`. Standard_D2s_v3 (not B-series). Text Diagram – Phase 1 Resources ```text PHASE 1: LANDING ZONE & GOVERNANCE="==================================" [Root Management Group] (tenant root) │ ├── [mg-platform-prod-global] (empty logical placeholder) [mg-landingzones-prod-global] [Subscription: sub-azaws-enterprise-prod] Policy Assignment: polassign-allowed-locations-mg polassign-allowed-skus-mg └── polassign-mandatory-tags-mg [mg-sandbox-prod-global] (empty) Definitions (custom): policy-allowed-locations (deny if location not uksouth) policy-allowed-vm-skus SKU B-series) policy-mandatory-tags missing Environment/Project/Owner) LEGEND:="=====">
[Name]        Management group, subscription, or policy
```

---

# Phase 2a: Terraform – Reusable Modules

## Objective
Build modular IaC with dynamic secrets from Key Vault, private-only networking, and resource lifecycle protection.

## Step-by-Step Actions

### Step 2a.1: Create module directory structure
```bash
cd terraform/modules
mkdir -p security networking compute monitoring
```

### Step 2a.2: Write `security` module (Key Vault + random password)
`terraform/modules/security/main.tf`:
```hcl
resource "random_password" "admin" {
  length  = 16
  special = true
  override_special = "!#$%&*"
}

resource "azurerm_key_vault" "kv" {
  name                = "kv-dev-platform-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = true
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "vm-admin-password"
  value        = random_password.admin.result
  key_vault_id = azurerm_key_vault.kv.id
}
```

### Step 2a.3: Write `compute` module (no public IP)
`terraform/modules/compute/main.tf`:

```hcl
resource "azurerm_network_interface" "vm" {
  name                = "nic-${var.vm_name}-01"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    # No public_ip_address_id – forces private only
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = random_password.admin.result  # from security module
  network_interface_ids = [azurerm_network_interface.vm.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}
```

### Step 2a.4: Root configuration (environments/dev/main.tf) calls modules
```hcl
module "security" {
  source = "../../modules/security"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

module "compute" {
  source = "../../modules/compute"
  vm_name           = "vm-dev-client-01"
  resource_group_name = azurerm_resource_group.rg.name
  location          = var.location
  subnet_id         = module.networking.spoke_subnet_id
  admin_password    = module.security.admin_password
}
```

## Validation Checklist
- [ ] `terraform plan` shows admin_password as `(sensitive value)`.
- [ ] VM NIC has no public IP (check `az vm show --name vm-dev-client-01 --expand networkProfile`).
- [ ] Key Vault secret is created and accessible.

## Text Diagram – Phase 2a Resources
```text
PHASE 2a: TERRAFORM MODULES (DYNAMIC SECRETS)
==============================================

[Root Config: environments/dev/main.tf]
         │
         ├── (calls)──> [Module: security]
         │                  │
         │                  ├── [random_password.admin] (generated)
         │                  │         │
         │                  │         ▼
         │                  ├── [Key Vault: kv-dev-platform-001]
         │                  │         │
         │                  │         └── Secret: vm-admin-password
         │                  │
         │                  └── (returns sensitive value)
         │
         ├── (calls)──> [Module: networking]
         │                  └── [VNet: vnet-dev-uksouth-hub]
         │                        └── [Subnet: snet-workload]
         │
         └── (calls)──> [Module: compute]
                             │
                             ├── [NIC: nic-vm-dev-client-01] (no public IP)
                             │         │
                             │         └── (attached to)──> [Subnet: snet-workload]
                             │
                             └── [VM: vm-dev-client-01]
                                   │
                                   └── admin_password = (from Key Vault secret)

LEGEND:
======>
[Module: name]  Logical Terraform module
```

---

# Phase 2b: Ansible Configuration Management

## Objective
Use Ansible roles to domain-join Windows VMs, apply security baselines, and deploy IIS – all via private network through Bastion/jumpbox.

## Step-by-Step Actions

### Step 2b.1: Create Ansible role directories
```bash
cd ansible/roles
mkdir -p common/ad-join/webserver
for role in common ad-join webserver; do
    mkdir -p $role/tasks $role/vars $role/handlers
done
```

### Step 2b.2: Write role `common/tasks/main.yml`
```yaml
- name: Disable IE Enhanced Security
  win_regedit:
    path: HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}
    name: IsInstalled
    data: 0
    type: dword

- name: Set Windows Firewall to allow WinRM from management subnet
  community.windows.win_firewall_rule:
    name: WinRM from Management
    direction: in
    protocol: TCP
    localport: 5986
    remoteip: 10.0.0.0/24
    action: allow
    enabled: yes
```

### Step 2b.3: Write role `ad-join/tasks/main.yml`
```yaml
- name: Join domain hq.azawslab.co.uk
  ansible.windows.win_domain_membership:
    dns_domain_name: hq.azawslab.co.uk
    hostname: "{{ ansible_hostname }}"
    domain_admin_user: "{{ domain_admin_user }}"
    domain_admin_password: "{{ domain_admin_password }}"
    state: domain
  register: domain_join

- name: Reboot if domain joined
  ansible.windows.win_reboot:
    reboot_timeout: 600
  when: domain_join.reboot_required
```

### Step 2b.4: Write role `webserver/tasks/main.yml`
```yaml
- name: Install IIS
  ansible.windows.win_feature:
    name: Web-Server
    state: present

- name: Create test index.html
  ansible.windows.win_copy:
    content: "<h1>Deployed by Ansible</h1>"
    dest: C:\inetpub\wwwroot\index.html
```

### Step 2b.5: Create master playbook `ansible/site.yml`
```yaml
- hosts: windows_workloads
  roles:
    - common
    - ad-join
    - webserver
```

### Step 2b.6: Run Ansible from jumpbox (or self-hosted runner)
```bash
# SSH to jumpbox first, then:
ansible-playbook -i inventory/dev/hosts.yml site.yml --vault-password-file .vault_pass
```

## Validation Checklist
- [ ] `ansible-lint site.yml` passes with no warnings.
- [ ] Playbook run shows `changed=0` on second run (idempotency).
- [ ] VM appears in AD (`Get-ADComputer vm-dev-client-01`).
- [ ] IIS homepage accessible from within spoke network.

## Text Diagram – Phase 2b Resources
```text
PHASE 2b: ANSIBLE CONFIGURATION
===============================

[GitHub Actions / CLI]  (runner)
         │
         │ (SSH / WinRM over proxy)
         ▼
[Azure Bastion / Jumpbox: vm-dev-bastion-01]   (public IP only for jumpbox)
         │
         │ (ProxyJump – private IP)
         ▼
[Spoke VNet: vnet-dev-uksouth-spoke-workload]
         │
         ├── [Subnet: snet-workload]
         │         │
         │         ▼
         │   [VM: vm-dev-client-01] (private IP only)
         │         │
         │         ├── (Role: common)     → security hardening, firewall rules
         │         ├── (Role: ad-join)    → joins domain hq.azawslab.co.uk
         │         └── (Role: webserver)  → IIS installation
         │
         └── [Subnet: snet-mgmt] (optional for Ansible control)

Ansible Control Machine (can be same jumpbox):
  - Inventory: ansible/inventory/dev/hosts.yml
  - Vault: encrypted domain_admin_password

LEGEND:
======>
[VM: name]        Virtual machine
(Role: name)      Ansible role applied
```

---

# Phase 2c: CI/CD Pipeline (GitHub Actions + OIDC)

## Objective
Establish secretless CI/CD with branch protection, automated `terraform plan` on PRs, and `terraform apply` on merge to `release-2`.

## Step-by-Step Actions

### Step 2c.1: Create OIDC test workflow
`.github/workflows/oidc-test.yml`:
```yaml
name: OIDC Test
on:
  push:
    branches: [ release-2 ]
  pull_request:
    branches: [ release-2 ]

permissions:
  id-token: write
  contents: read

jobs:
  oidc:
    runs-on: ubuntu-latest
    steps:
      - name: Azure login via OIDC
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Show account
        run: az account show
```

Add secrets in GitHub repo: `AZURE_CLIENT_ID` (app ID of `sp-terraform-gh`), `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`.

### Step 2c.2: Create Terraform CI workflow
`.github/workflows/tf-ci.yml`:

```yaml
name: Terraform CI
on:
  pull_request:
    branches: [ release-2 ]
    paths:
      - 'terraform/**'

permissions:
  id-token: write
  contents: read
  pull-requests: write

jobs:
  plan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      - uses: hashicorp/setup-terraform@v3
      - name: Terraform fmt & validate
        run: |
          cd terraform/environments/dev
          terraform fmt -check
          terraform init
          terraform validate
      - name: Terraform plan
        id: plan
        run: |
          cd terraform/environments/dev
          terraform plan -no-color -out plan.tfplan
      - name: Comment PR
        uses: actions/github-script@v7
        with:
          script: |
            const plan = `${{ steps.plan.outputs.stdout }}`;
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## Terraform Plan\n\`\`\`\n${plan}\n\`\`\``
            })
```

### Step 2c.3: Create Terraform CD workflow
`.github/workflows/tf-cd.yml`:
```yaml
name: Terraform CD
on:
  push:
    branches: [ release-2 ]
    paths:
      - 'terraform/**'

permissions:
  id-token: write
  contents: read

jobs:
  apply:
    runs-on: ubuntu-latest
    environment: release-2
    steps:
      - uses: actions/checkout@v4
      - uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      - uses: hashicorp/setup-terraform@v3
      - name: Terraform apply
        run: |
          cd terraform/environments/dev
          terraform init
          terraform apply -auto-approve
```

### Step 2c.4: Configure branch protection
In GitHub repo: Settings → Branches → Add rule for `release-2`:
- Require pull request reviews (1 approver)
- Require status checks (select `Terraform CI` and `OIDC Test`)

## Validation Checklist
- [ ] Create a PR from `feature/*` to `release-2`: GitHub Action runs, comments plan.
- [ ] Merge PR: CD workflow runs, applies changes.
- [ ] `az vm list` shows new resources created automatically.

## Text Diagram – Phase 2c Resources

```text
PHASE 2c: CI/CD PIPELINE (SECRETLESS)
======================================

[Developer Branch: feature/xyz]
         │
         │ (git push)
         ▼
[GitHub Pull Request] (target: release-2)
         │
         ├── Trigger: .github/workflows/tf-ci.yml
         │         │
         │         ├── (OIDC)──> [Azure Login – no secrets]
         │         │
         │         ├── terraform fmt & validate
         │         │
         │         └── terraform plan
         │                 │
         │                 └── (comment plan on PR)
         │
         ├── (Manual review & approval) ──┐
         │                                │
         └── (Merge to release-2) <───────┘
                     │
                     ▼
         [GitHub Environment: release-2]
                     │
                     │ (Trigger: tf-cd.yml)
                     ▼
         [OIDC token exchange] ──> [Azure Subscription]
                     │
                     └── terraform apply -auto-approve
                              │
                              └──> Creates resources (VMs, KV, etc.)

Branch Protection (release-2):
  - Requires PR
  - Requires status checks (CI, OIDC test)
  - At least 1 reviewer

LEGEND:
======>
[GitHub ...]      GitHub construct
(OIDC)            Identity federation – no static secrets
```

---

# Phase 3: Enterprise Governance & Guardrails

## Objective
Enforce data sovereignty (UK South only), cost control (B‑series VM SKUs only), mandatory tagging, and least‑privilege RBAC via Azure Policy and role assignments.

## Step-by-Step Actions

### Step 3.1: Confirm existing policies from Phase 1 (if not already done)
Ensure three custom policy definitions exist:
- `policy-allowed-locations` (deny if location not `uksouth`)
- `policy-allowed-vm-skus` (deny if VM SKU not B-series)
- `policy-mandatory-tags` (deny if missing `Environment`, `Project`, or `Owner` tags)

**Deploy missing policies using Terraform** (example for VM SKU):
```hcl
resource "azurerm_policy_definition" "allowed_vm_skus" {
  name         = "policy-allowed-vm-skus"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed VM SKUs (B-series only)"

  metadata = <<METADATA { "category": "Compute" } METADATA policy_rule="<<POLICY_RULE" "if": "allOf": [ "field": "type", "equals": "Microsoft.Compute/virtualMachines" }, "not": "Microsoft.Compute/virtualMachines/sku.name", "in": ["Standard_B1s", "Standard_B2s", "Standard_B2ms", "Standard_B4ms", "Standard_B8ms"] ] "then": "effect": "deny" POLICY_RULE resource "azurerm_management_group_policy_assignment" "allowed_vm_skus" name="policy-mandatory-tags" management_group_id="mg-landingzones-prod-global" policy_definition_id="azurerm_policy_definition.allowed_vm_skus.id" ``` ### Step 3.2: Assign mandatory tags policy (custom) ```hcl "azurerm_policy_definition" "mandatory_tags" policy_type="Custom" mode="Indexed" display_name="Require mandatory tags" metadata="<<METADATA" "Tags" "anyOf": "tags['Environment']", "exists": "false" "tags['Project']", "tags['Owner']", 3.3: Verify least‑privilege RBAC for `sp-terraform-gh` ```bash # Check current role assignments az assignment list --assignee $APP_ID --output table Ensure only Contributor at subscription level – no Owner or User Access Administrator If too broad, restrict to specific group: create --role --scope /subscriptions/$SUB_ID/resourceGroups/rg-dev-* 3.4: Validate enforcement Attempt VM in East US (should fail) vm --resource-group rg-dev-networking-uksouth --name vm-test-fail --image Win2022Datacenter --location eastus --admin-username azureuser --admin-password Test123! --no-wait Expected error: "Resource 'vm-test-fail' was disallowed by policy." with non-B SKU vm-test-sku uksouth --size Standard_D2s_v3 denied policy-allowed-vm-skus without storage account stfailtagtest --sku Standard_LRS missing required ## Validation Checklist - All three show as "Compliant" (or non‑compliant resources are creation). `az state --filter "resourceType eq 'Microsoft.Compute/virtualMachines'"` shows violations. has on restricted groups. Text Diagram Phase 3 Resources ```text PHASE 3: GOVERNANCE & GUARDRAILS="===============================" [mg-landingzones-prod-global] │ ├── Policy Assignment: polassign-allowed-locations-mg └── (deny if location !="uksouth)" polassign-allowed-skus-mg not B-series list) polassign-mandatory-tags-mg Environment/Project/Owner tags) [Subscription: sub-azaws-enterprise-prod] RBAC: sp-terraform-gh --(Contributor)--> (Resource Group: rg-dev-*)
         │
         └── (Any resource creation attempts)──> evaluated against MG policies

Attempted violations:
  - VM in East US → Deny
  - VM Standard_D2s_v3 → Deny
  - Storage account without tags → Deny

LEGEND:
======>
[Policy Assignment]   Azure Policy applied at management group
--(role)-->           RBAC permission
```

---

# Phase 4: Azure Lighthouse (MSP Delegated Administration)

## Objective
Project a customer subscription into the primary management tenant (`entra.azawslab.co.uk`) using Azure Lighthouse, enabling cross‑tenant management without guest accounts.

## Step-by-Step Actions

### Step 4.1: Prepare ARM template for Lighthouse delegation
Create `lighthouse-customer-delegation.json`:
```json
{
  "$schema": "[https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#](https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#)",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "mspOfferName": {
      "type": "string",
      "defaultValue": "Azawslab MSP Management"
    },
    "mspOfferDescription": {
      "type": "string",
      "defaultValue": "Azure Lighthouse delegation for Azawslab Release 2"
    },
    "managedByTenantId": {
      "type": "string",
      "metadata": {
        "description": "Tenant ID of the managing tenant (entra.azawslab.co.uk)"
      }
    },
    "authorizations": {
      "type": "array",
      "defaultValue": [
        {
          "principalId": "00000000-0000-0000-0000-000000000000",
          "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c",
          "principalIdDisplayName": "azw-Platform-Admins"
        }
      ]
    }
  },
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.ManagedServices/registrationDefinitions",
      "apiVersion": "2020-02-01-preview",
      "name": "[guid(parameters('mspOfferName'))]",
      "properties": {
        "registrationDefinitionName": "[parameters('mspOfferName')]",
        "description": "[parameters('mspOfferDescription')]",
        "managedByTenantId": "[parameters('managedByTenantId')]",
        "authorizations": "[parameters('authorizations')]"
      }
    }
  ]
}
```

### Step 4.2: Deploy ARM template in **customer tenant** (second Entra ID / subscription)
```bash
# Log into customer tenant first
az login --tenant <customer-tenant-id>

# Deploy template at subscription scope
az deployment sub create \
  --location uksouth \
  --template-file lighthouse-customer-delegation.json \
  --parameters managedByTenantId="<your-primary-tenant-id>"
```

### Step 4.3: Verify delegation from primary tenant
```bash
# Switch back to primary tenant (entra.azawslab.co.uk)
az login --tenant entra.azawslab.co.uk

# List customer subscriptions accessible via Lighthouse
az account list --query "[?managedByTenants]" --output table

# Query resources in customer subscription without switching context
CUSTOMER_SUB_ID="<customer-subscription-id>"
az vm list --subscription $CUSTOMER_SUB_ID --output table
```

## Validation Checklist
- [ ] `az account list` shows customer subscription with `managedByTenants` populated.
- [ ] Primary `azw-Platform-Admins` group can list VMs in customer tenant without guest invitation.
- [ ] Portal → Azure Lighthouse → My customers shows the delegated offer.

## Text Diagram – Phase 4 Resources

```text
PHASE 4: AZURE LIGHTHOUSE (MSP DELEGATION)
===========================================

[Primary Tenant: entra.azawslab.co.uk]          [Customer Tenant: <customer>.onmicrosoft.com]
         │                                                             │
         │  (Azure Lighthouse – ARM template)                          │
         │  managedByTenantId = primary-tenant-id                      │
         └─────────────────────────────────────────────────────►
                                                                       │
                                                                       ▼
                                                             [Customer Subscription]
                                                             (delegated to primary)
                                                                       │
         ┌─────────────────────────────────────────────────────┘
         │
         ▼
[Group: azw-Platform-Admins] (primary tenant)
         │
         └── (Contributor role on customer subscription)
                   │
                   └──> Can run: az vm list --subscription <customer-sub-id>

No guest accounts created – pure cross‑tenant trust

LEGEND:
======>
[Primary Tenant]      Managing tenant (your Entra ID)
[Customer Tenant]     External tenant delegating access
```

---

# Phase 5: Hub‑Spoke Networking Foundation

## Objective
Deploy Hub VNet, Spoke VNet, bidirectional peering, and forced tunneling via User Defined Routes (UDRs) to prepare for Azure Firewall inspection.

## Step-by-Step Actions

### Step 5.1: Create Hub VNet with required subnets
Using Terraform module `networking`:
```hcl
# terraform/modules/networking/main.tf (partial)
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-dev-uksouth-hub"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "azurefirewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/27"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.3.0/27"]
}

resource "azurerm_subnet" "mgmt" {
  name                 = "snet-mgmt"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.4.0/24"]
}
```

### Step 5.2: Create Spoke VNet (workload)
```hcl
resource "azurerm_virtual_network" "spoke_workload" {
  name                = "vnet-dev-uksouth-spoke-workload"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "workload" {
  name                 = "snet-workload"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_workload.name
  address_prefixes     = ["10.1.0.0/24"]
}
```

### Step 5.3: Establish bidirectional VNet peering
```hcl
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke-workload"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_workload.id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true   # Required for UDR to firewall
  allow_gateway_transit     = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-workload-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke_workload.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
}
```

### Step 5.4: Create UDR for forced tunneling (to Azure Firewall – placeholder IP)
```hcl
resource "azurerm_route_table" "udr_to_firewall" {
  name                = "rt-udr-to-firewall-uksouth"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "default_to_firewall" {
  name                   = "default-route"
  route_table_name       = azurerm_route_table.udr_to_firewall.name
  resource_group_name    = var.resource_group_name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.1.4"   # Placeholder – actual Azure Firewall IP will be known after deployment
}

resource "azurerm_subnet_route_table_association" "workload" {
  subnet_id      = azurerm_subnet.workload.id
  route_table_id = azurerm_route_table.udr_to_firewall.id
}
```

### Step 5.5: Deploy Azure Bastion (optional but recommended)
```bash
az network bastion create \
  --name bastion-dev-uksouth \
  --resource-group rg-connectivity-prod-uksouth \
  --vnet-name vnet-dev-uksouth-hub \
  --location uksouth \
  --sku Standard
```

## Validation Checklist
- [ ] `az network vnet peering list --vnet-name vnet-dev-uksouth-hub --resource-group rg-connectivity-prod-uksouth` shows both peerings.
- [ ] From spoke VM (after Phase 2a), ping hub management subnet (10.0.4.4) – should succeed.
- [ ] Effective routes on spoke VM NIC show `0.0.0.0/0` pointing to firewall IP placeholder (actual IP will be set in Phase 6).

## Text Diagram – Phase 5 Resources
```text
PHASE 5: HUB‑SPOKE NETWORKING
==============================

[Hub VNet: vnet-dev-uksouth-hub (10.0.0.0/16)]
         │
         ├── [Subnet: AzureFirewallSubnet (10.0.1.0/26)] ← placeholder for AFW
         ├── [Subnet: AzureBastionSubnet (10.0.2.0/27)] ← Bastion service
         ├── [Subnet: GatewaySubnet (10.0.3.0/27)]      ← future VPN
         └── [Subnet: snet-mgmt (10.0.4.0/24)]          ← management jumpbox

         │ (VNet peering: allow_forwarded_traffic)
         ▼
[Spoke VNet: vnet-dev-uksouth-spoke-workload (10.1.0.0/16)]
         │
         ├── [Subnet: snet-workload (10.1.0.0/24)]
         │         │
         │         └── associated with [Route Table: rt-udr-to-firewall-uksouth]
         │                   └── route: 0.0.0.0/0 → VirtualAppliance (10.0.1.4)
         │
         └── VM: vm-dev-client-01 (private IP 10.1.0.4)

[Azure Bastion: bastion-dev-uksouth] → provides RDP/SSH to private VMs

LEGEND:
======>
[VNet]            Virtual Network
[Route Table]     UDR for forced tunneling
```

---

# Phase 6: Azure Firewall & Central Inspection

## Objective
Deploy Azure Firewall into the Hub VNet, configure network and application rules (allow DNS, allow Microsoft APIs), enable diagnostic logs, and update UDR with the firewall’s private IP.

## Step-by-Step Actions

### Step 6.1: Deploy Azure Firewall (ephemeral – destroy after validation)
```hcl
# terraform/modules/firewall/main.tf
resource "azurerm_public_ip" "afw" {
  name                = "pip-afw-uksouth-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "afw" {
  name                = "afw-dev-uksouth-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.azure_firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.afw.id
  }

  tags = {
    Environment = "Development"
    Ephemeral   = "true"   # Mark for destruction after validation
  }
}
```

### Step 6.2: Create firewall policy and rule collections
```hcl
resource "azurerm_firewall_policy" "afwp" {
  name                = "afwp-dev-uksouth"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_firewall_policy_rule_collection_group" "network_rules" {
  name               = "network-rules"
  firewall_policy_id = azurerm_firewall_policy.afwp.id
  priority           = 500

  network_rule_collection {
    name     = "allow-dns"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "allow-dns-udp"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/8", "10.1.0.0/16"]
      destination_addresses = ["8.8.8.8", "1.1.1.1"]
      destination_ports     = ["53"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "application_rules" {
  name               = "app-rules"
  firewall_policy_id = azurerm_firewall_policy.afwp.id
  priority           = 600

  application_rule_collection {
    name     = "allow-microsoft"
    priority = 100
    action   = "Allow"
    rule {
      name = "allow-azure-apis"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["10.0.0.0/8", "10.1.0.0/16"]
      destination_fqdns = [
        "*.microsoft.com",
        "*.azure.com",
        "*.windows.net"
      ]
    }
  }
}
```

### Step 6.3: Update UDR with actual firewall private IP
After firewall deployment, retrieve its private IP:
```bash
FW_IP=$(az network firewall show --name afw-dev-uksouth-01 --resource-group rg-connectivity-prod-uksouth --query "ipConfigurations[0].privateIpAddress" -o tsv)
# Update route table (via Terraform or CLI)
az network route table route update \
  --name default-route \
  --route-table-name rt-udr-to-firewall-uksouth \
  --resource-group rg-connectivity-prod-uksouth \
  --next-hop-ip-address $FW_IP
```

### Step 6.4: Enable diagnostics to Log Analytics
```hcl
resource "azurerm_monitor_diagnostic_setting" "afw_diag" {
  name                       = "afw-diag"
  target_resource_id         = azurerm_firewall.afw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }
  enabled_log {
    category = "AzureFirewallNetworkRule"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
```

### Step 6.5: Test firewall blocking and logging
From spoke VM (`vm-dev-client-01`):
```powershell
# Should succeed (allowed by application rule)
curl [https://management.azure.com](https://management.azure.com)

# Should be blocked (not a Microsoft domain)
curl [http://example.com](http://example.com)
# Expected: timeout or connection refused

# Check KQL in Log Analytics
AzureDiagnostics
| where Category == "AzureFirewallApplicationRule"
| where msg_s contains "example.com"
| project TimeGenerated, msg_s
```

## Validation Checklist
- [ ] `az network firewall show` shows provisioning state `Succeeded`.
- [ ] Spoke VM can resolve DNS (`nslookup microsoft.com`).
- [ ] `curl http://example.com` fails (blocked by firewall).
- [ ] Log Analytics contains blocked traffic entries.
- [ ] **FinOps:** After capturing evidence, run `terraform destroy -target=azurerm_firewall.afw` to avoid ongoing charges (~$1.20/hour).

## Text Diagram – Phase 6 Resources
```text
PHASE 6: AZURE FIREWALL & CENTRAL INSPECTION
=============================================

[Hub VNet: vnet-dev-uksouth-hub]
         │
         ├── [Subnet: AzureFirewallSubnet] (10.0.1.0/26)
         │         │
         │         ▼
         │   [Azure Firewall: afw-dev-uksouth-01] (private IP 10.0.1.4)
         │         │
         │         ├── Firewall Policy: afwp-dev-uksouth
         │         │         ├── Network rule: allow DNS (UDP/53 to 8.8.8.8)
         │         │         └── Application rule: allow HTTPS to *.microsoft.com
         │         │
         │         └── Diagnostics → [Log Analytics: la-dev-platform]
         │
         └── [Subnet: snet-workload] (10.1.0.0/24) with UDR route:
                   0.0.0.0/0 → NextHop: 10.0.1.4 (firewall)

[Spoke VM: vm-dev-client-01] (10.1.0.4)
         │
         ├── nslookup microsoft.com → success
         ├── curl [https://management.azure.com](https://management.azure.com) → success (allowed)
         └── curl [http://example.com](http://example.com) → blocked (logged in LA)

KQL query for blocked traffic:
AzureDiagnostics | where Category == "AzureFirewallApplicationRule" | where msg_s contains "deny"

LEGEND:
======>
[Azure Firewall]      Managed inspection point
→ allowed traffic     Green (success)
→ blocked traffic     Red (deny)
```

---

## FinOps Teardown for Phase 6 (Ephemeral Resource)

After completing validation and capturing evidence (screenshots + terminal outputs into `docs/release2/evidence/P6/`), destroy Azure Firewall to avoid charges:
```bash
terraform destroy -target=azurerm_firewall.afw -auto-approve
terraform destroy -target=azurerm_firewall_policy.afwp -auto-approve
# Keep UDR and other networking components
```

---


# Phase-by-Phase Implementation Guide (Release 2)

**Version:** 1.0  
**Aligns with:** `README_PLAN.md` and `naming-conventions.md`  
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

# Phase 7: Cloud Security Posture Management (CSPM) – Defender for Cloud

## Objective
Enable Microsoft Defender for Cloud (free CSPM) at subscription level, track Secure Score, and optionally enable premium Defender plans ephemerally to demonstrate CWPP.

## Step-by-Step Actions

### Step 7.1: Enable Defender for Cloud on subscription (free CSPM)
Using Terraform:
```hcl
# terraform/environments/dev/defender.tf
resource "azurerm_security_center_subscription_pricing" "cspm_free" {
  tier          = "Free"
  resource_type = "VirtualMachines"
  # Free tier covers CSPM basics (Secure Score, recommendations)
}

# Optional: Enable a premium plan (e.g., Servers) ephemerally
resource "azurerm_security_center_subscription_pricing" "servers_premium" {
  tier          = "Standard"
  resource_type = "VirtualMachines"

  lifecycle {
    # Destroy after validation to save cost (~$15/month per VM)
    prevent_destroy = false
  }
}
```

### Step 7.2: Review Secure Score and recommendations
```bash
# Get current Secure Score
az security secure-score list --query "[?displayName=='Default'].current" -o tsv

# List top recommendations
az security assessment list --query "[?status.code=='Unhealthy'].displayName" -o table

# Remediate a high-priority recommendation (example: enable system updates)
# Follow portal or CLI remediation steps
az vm extension set --resource-group rg-dev-networking-uksouth --vm-name vm-dev-client-01 --name IaaSAntimalware --publisher Microsoft.Azure.Security --settings '{"AntimalwareEnabled": true}'
```

### Step 7.3: Document before/after Secure Score
```bash
# Before remediation
az security secure-score list > docs/release2/evidence/P7/secure-score-before.txt

# After remediation
az security secure-score list > docs/release2/evidence/P7/secure-score-after.txt
```

## Validation Checklist
- [ ] `az security secure-score list` shows a numeric score (e.g., 85%).
- [ ] At least one recommendation has been remediated and shows "Healthy".
- [ ] Premium Defender plans (if enabled) appear in `az security pricing list`.

## Text Diagram – Phase 7 Resources
```
PHASE 7: DEFENDER FOR CLOUD (CSPM)
===================================

[Subscription: sub-azaws-enterprise-prod]
         │
         ├── Defender for Cloud (Free CSPM)
         │         ├── Continuous assessment
         │         ├── Secure Score (baseline)
         │         └── Recommendations (e.g., enable antimalware, system updates)
         │
         ├── (Optional – ephemeral) Premium plan for VirtualMachines
         │         └── CWPP – deeper workload protection
         │
         └── Resources evaluated:
               ├── VM: vm-dev-client-01
               ├── Key Vault: kv-dev-platform-001
               └── Networking components

[Remediation action] → Update VM extension or configuration
         │
         ▼
[Improved Secure Score] → Captured evidence (before/after)

LEGEND:
======>
[Defender for Cloud]  Security posture management
(ephemeral)           Destroyed after validation to save cost
```

### FinOps Note for P7
Premium Defender plans (e.g., `Servers`) cost ~$15/month per VM. Enable only during validation, then:

```bash
terraform destroy -target=azurerm_security_center_subscription_pricing.servers_premium -auto-approve
```

---

# Phase 8: Microsoft Sentinel (Cloud-Native SIEM)

## Objective
Onboard Sentinel to the Log Analytics workspace, enable Azure Activity data connector, and deploy a custom KQL analytic rule to detect multiple failed sign-ins.

## Step-by-Step Actions

### Step 8.1: Enable Sentinel on Log Analytics workspace
```hcl
# terraform/environments/dev/sentinel.tf
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.la.id
  # No additional config – just enables Sentinel
}
```

### Step 8.2: Enable Azure Activity data connector
```hcl
# Terraform does not have native resource for data connectors yet.
# Use azapi resource or CLI.
resource "azapi_resource" "activity_connector" {
  type      = "Microsoft.OperationsManagement/solutions@2015-11-01-preview"
  name      = "AzureActivity"
  parent_id = azurerm_log_analytics_workspace.la.id
  location  = azurerm_log_analytics_workspace.la.location

  plan {
    name      = "AzureActivity"
    product   = "OMSGallery/AzureActivity"
    publisher = "Microsoft"
  }
}
```

### Step 8.3: Create custom analytic rule (KQL)
Using Azure CLI or REST API (Terraform via `azapi_resource`):
```json
// docs/release2/evidence/P8/rule-multiple-failed-signins.json
{
  "properties": {
    "displayName": "rule-multiple-failed-signins",
    "description": "Detects more than 5 failed sign-ins within 5 minutes",
    "severity": "Medium",
    "enabled": true,
    "query": "SigninLogs\n| where ResultType == 50057 or ResultType == 50055\n| summarize FailedAttempts = count() by UserPrincipalName, IPAddress, bin(TimeGenerated, 5m)\n| where FailedAttempts > 5",
    "queryFrequency": "PT5M",
    "queryPeriod": "PT5M",
    "triggerOperator": "GreaterThan",
    "triggerThreshold": 0,
    "suppressionDuration": "PT5M",
    "suppressionEnabled": false,
    "eventGroupingSettings": {
      "aggregationKind": "SingleAlert"
    }
  }
}
```

Deploy via CLI:
```bash
az sentinel alert-rule create --resource-group rg-dev-platform-uksouth --workspace-name la-dev-platform --rule-name "rule-multiple-failed-signins" --rule-template-id "" --kind Scheduled --query @documents/release2/evidence/P8/rule-multiple-failed-signins.json
```

### Step 8.4: Simulate security incident (brute-force)
```bash
# Install Azure CLI or use PowerShell to simulate failed logins
for i in {1..6}; do
  az login --username test-user@entra.azawslab.co.uk --password wrongpassword --only-show-errors
  sleep 10
done
```

### Step 8.5: Verify incident in Sentinel
```kql
// Run in Log Analytics
SigninLogs
| where ResultType == 50057
| summarize count() by UserPrincipalName, bin(TimeGenerated, 1h)

// Check Sentinel incident (via CLI)
az sentinel incident list --resource-group rg-dev-platform-uksouth --workspace-name la-dev-platform --orderby "properties.createdTimeUtc desc"
```

## Validation Checklist
- [ ] `az sentinel alert-rule list` shows `rule-multiple-failed-signins`.
- [ ] After simulating failed logins, Sentinel generates an incident (seen in portal or CLI).
- [ ] KQL query returns the failed attempts.

## Text Diagram – Phase 8 Resources
```
PHASE 8: MICROSOFT SENTINEL (SIEM)
===================================

[Log Analytics Workspace: la-dev-platform]
         │
         ├── (Onboarded to) → [Microsoft Sentinel]
         │                            │
         │                            ├── Data Connector: Azure Activity (connector-azure-activity)
         │                            │
         │                            ├── Analytic Rule: rule-multiple-failed-signins (KQL)
         │                            │         └── Query: >5 failed sign-ins in 5 minutes
         │                            │
         │                            └── Incidents generated
         │
         ├── Ingested logs:
         │         ├── SigninLogs (from Entra ID via diagnostic settings)
         │         └── AzureActivity (from subscription)
         │
         └── Simulate brute-force → Incident triggered

[Email / SOC notification] ← (Action group can be attached later)

LEGEND:
======>
[Microsoft Sentinel]  Cloud SIEM
[Analytic Rule]       KQL detection logic
```

---

# Phase 9a: Azure Monitor & Alerts (Observability)

## Objective
Deploy Action Group (email alerts) and Metric Alert (CPU > 85% on Spoke VM) using Terraform, then stress test to verify alert delivery.

## Step-by-Step Actions

### Step 9a.1: Create Action Group
```hcl
# terraform/environments/dev/monitoring.tf
resource "azurerm_monitor_action_group" "email" {
  name                = "ag-dev-email"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "email-ag"

  email_receiver {
    name          = "admin-email"
    email_address = "your-email@example.com"  # Replace with your email
  }
}
```

### Step 9a.2: Create Metric Alert for CPU > 85%
```hcl
resource "azurerm_monitor_metric_alert" "high_cpu" {
  name                = "alert-high-cpu-vm-dev-client"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_windows_virtual_machine.vm.id]
  description         = "Alert when VM CPU exceeds 85% for 5 minutes"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85

    dimension {
      name     = "VMName"
      operator = "Include"
      values   = ["vm-dev-client-01"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}
```

### Step 9a.3: Stress test CPU (from within VM)
```powershell
# Run on vm-dev-client-01 via Bastion / PowerShell
# Simulate high CPU for 10 minutes
Write-Host "Starting CPU stress test..."
for ($i=0; $i -lt 10; $i++) {
    Start-Job -ScriptBlock { while($true) { $a = 1..1000000 | ForEach-Object { $_ * $_ } } }
}
```

### Step 9a.4: Verify alert firing
```bash
# Check alert status via CLI
az monitor metric alert show --name alert-high-cpu-vm-dev-client --resource-group rg-dev-networking-uksouth --query "properties.criteria"
# Wait 5-10 minutes, then check email for alert notification
```

## Validation Checklist
- [ ] Action group created: `az monitor action-group show --name ag-dev-email --resource-group rg-dev-networking-uksouth`
- [ ] Metric alert rule exists: `az monitor metric alert list --resource-group rg-dev-networking-uksouth --output table`
- [ ] CPU stress test triggers email alert (check inbox – may go to spam).

## Text Diagram – Phase 9a Resources

```
PHASE 9a: AZURE MONITOR & ALERTS
=================================

[Spoke VM: vm-dev-client-01]
         │
         │ (Metrics: Percentage CPU)
         ▼
[Azure Monitor Metrics Store]
         │
         │ (Evaluation every 5 minutes)
         ▼
[Metric Alert: alert-high-cpu-vm-dev-client]
         │
         │ threshold = CPU > 85% for 5 min
         ▼
[Action Group: ag-dev-email]
         │
         └── (Email receiver: your-email@example.com)
                   │
                   ▼
         [Admin email inbox] – "Alert triggered: high CPU"

Stress test simulation:
  - Run CPU-intensive loop on VM
  - Monitor alert firing in portal/CLI
  - Verify email delivery

LEGEND:
======>
[Metric Alert]        Monitoring rule
[Action Group]        Notification targets
```

---

# Phase 9b: Disaster Recovery (Backup & ASR) – Resilience-as-Code

## Objective
Deploy Recovery Services Vault with immutability, configure backup policy, associate VM, and enforce Multi-User Authorization (MUA) via Azure Resource Guard. Optionally demonstrate ASR test failover.

## Step-by-Step Actions

### Step 9b.1: Create Resource Guard (MUA)
```hcl
# terraform/environments/dev/disaster_recovery.tf
resource "azurerm_resource_guard" "backup" {
  name                = "rg-dev-resourceguard"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
```

### Step 9b.2: Create Recovery Services Vault with immutability
```hcl
resource "azurerm_recovery_services_vault" "backup" {
  name                = "rsv-dev-backup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  soft_delete_enabled = true
  # Immutability requires explicit setting (via azurerm provider >= 3.0)
}

resource "azurerm_backup_policy_vm" "daily" {
  name                = "backup-policy-daily"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup.name

  timezone = "GMT Standard Time"

  backup {
    frequency = "Daily"
    time      = "22:00"
  }

  retention_daily {
    count = 30
  }
}

# Associate VM to backup policy
resource "azurerm_backup_protected_vm" "vm" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup.name
  source_vm_id        = azurerm_windows_virtual_machine.vm.id
  backup_policy_id    = azurerm_backup_policy_vm.daily.id
}
```

### Step 9b.3: Link Resource Guard to Vault (MUA)
```bash
# Azure CLI to add critical operation protection
az resource guard update --resource-group rg-dev-networking-uksouth --name rg-dev-resourceguard --add "properties.vaultCriticalOperationExclusionList" "Microsoft.RecoveryServices/vaults/backupItems/delete"
```

### Step 9b.4: Test MUA – attempt to delete backup (should be blocked)
```bash
# Try to delete backup item using primary admin account
az backup item delete --name vm-dev-client-01 --vault-name rsv-dev-backup --resource-group rg-dev-networking-uksouth --container-name <container> --backup-management-type AzureIaasVM
# Expected error: access denied due to Resource Guard MUA policy
```

### Step 9b.5: (Optional) Configure ASR test failover
```hcl
resource "azurerm_recovery_services_vault" "asr" {
  name                = "rsv-dev-asr"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

resource "azurerm_site_recovery_replication_policy" "asr" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.asr.name

  recovery_point_retention_in_minutes = 1440
  application_consistent_snapshot_frequency_in_minutes = 60
}

# Additional test failover steps omitted for brevity
```

## Validation Checklist
- [ ] Recovery Services Vault shows "Immutability: Enabled" and "Soft delete: On".
- [ ] Attempt to delete backup fails with MUA error.
- [ ] VM appears in Backup Center with healthy status.

## Text Diagram – Phase 9b Resources
```
PHASE 9b: DISASTER RECOVERY (BCDR)
===================================

[Azure Resource Guard: rg-dev-resourceguard]  (isolated security context)
         │
         │ (MUA enforcement)
         ▼
[Recovery Services Vault: rsv-dev-backup]
         │
         ├── Immutability: ON (cannot disable)
         ├── Soft delete: 14 days
         ├── Backup policy: daily at 22:00, retain 30 days
         │
         └── Protected item: vm-dev-client-01

[Spoke VM: vm-dev-client-01] → (automated backup)

Attempted deletion (primary admin):
  - az backup item delete → blocked by Resource Guard
  - Requires secondary approval (simulated)

Optional ASR:
[Recovery Services Vault (ASR): rsv-dev-asr]
  - Replication policy: 60 min app-consistent snapshots
  - Test failover validated

LEGEND:
======>
[Recovery Services Vault]  Backup & DR hub
[MUA]                      Multi-User Authorization
```

### FinOps Note for P9b
Recovery Services Vault has low cost (~$0.10/day for backup storage). Keep it. ASR replication adds cost; destroy if not needed:
```bash
terraform destroy -target=azurerm_recovery_services_vault.asr -auto-approve
```

---

# Phase 9c: Platform Handover & FinOps Teardown

## Objective
Deliver developer documentation (onboarding, contributing guidelines) and execute complete infrastructure teardown to achieve $0 run rate.

## Step-by-Step Actions

### Step 9c.1: Write `onboarding.md`
Create `docs/onboarding.md`:
```markdown
# Onboarding – Azawslab Release 2

## Prerequisites
- Azure subscription (Pay-As-You-Go)
- GitHub account
- Entra ID tenant with verified domain entra.azawslab.co.uk

## One-time setup
1. Clone repo: `git clone [https://github.com/your-username/your-repo](https://github.com/your-username/your-repo)`
2. Run Phase 0 OIDC scripts (see `README_PLAN.md`)
3. Configure GitHub secrets: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`

## Deploy environment
- Create PR to `release-2` → CI runs `terraform plan`
- Merge → CD applies infrastructure
- Validate via `az vm list` and `terraform output`

## Daily operations
- Access VMs via Azure Bastion (no public IPs)
- Monitor alerts via Action Group email
- Update policies via Terraform modules

## Teardown
`terraform destroy` (or use GitHub Actions workflow)
```

### Step 9c.2: Write `CONTRIBUTING.md`
```markdown
# Contributing to Azawslab Release 2

## Branch strategy
- `release-2`: production-like, requires PR + CI checks
- `feature/*`: development branches

## Naming conventions
See `naming-conventions.md` – all resources must follow patterns.

## Pull request process
1. Create branch from `release-2`
2. Run `terraform fmt` and `terraform validate` locally
3. Push → GitHub Actions runs `terraform plan` and comments on PR
4. Request review from `azw-Platform-Admins`
5. After approval, merge → CD deploys

## Testing
- Ansible playbooks: `ansible-lint site.yml`
- Terraform: `terraform test` (if modules have tests)

## Evidence capture
Store outputs in `docs/release2/evidence/<phase>/` as `.txt` or `.png`.
```

### Step 9c.3: Execute final teardown
```bash
# From terraform/environments/dev/
terraform state list   # Verify all resources are tracked

# Destroy everything (including RG)
terraform destroy -auto-approve

# Manually check for orphaned resources
az resource list --tag Project=Azawslab-Release2 --output table
# Should be empty

# Delete the Terraform state storage account (optional, but good for clean-up)
az group delete --name rg-dev-terraformstate-uksouth --yes --no-wait
```

### Step 9c.4: Document teardown evidence
```bash
terraform destroy > docs/release2/evidence/P9c/terraform-destroy-output.txt
echo "Clean Azure environment" >> docs/release2/evidence/P9c/teardown-notes.md
```

## Validation Checklist
- [ ] `docs/onboarding.md` and `CONTRIBUTING.md` are committed to `release-2`.
- [ ] Another engineer can clone and deploy within 60 minutes (simulate or describe).
- [ ] `terraform destroy` completes without errors.
- [ ] Azure Cost Analysis shows $0 projected compute charges.

## Text Diagram – Phase 9c Resources
```
PHASE 9c: PLATFORM HANDOVER & FINOPS TEARDOWN
==============================================

[GitHub Repository]
         │
         ├── docs/onboarding.md         → Step-by-step for new engineers
         ├── CONTRIBUTING.md            → PR process, naming, testing
         └── terraform/                 → IaC source of truth

[Engineer B] clones repo
         │
         │ (follows onboarding)
         ▼
[GitHub Actions + OIDC] → deploys full platform (P0–P9b)

After validation:
[terraform destroy] → deletes all ephemeral & persistent resources
         │
         ▼
[Clean Azure subscription] → $0 ongoing charges
         │
         └── Evidence: terraform-destroy-output.txt

FinOps check:
  - Azure Cost Analysis: no active resources
  - Management groups & policies remain (no cost)
  - State storage optionally deleted

LEGEND:
======>
[Engineer B]          Another team member
[terraform destroy]   Full cleanup
```

### FinOps Final Check
After teardown, verify:

```bash
# List any remaining resources (should be none)
az resource list --tag Project=Azawslab-Release2 --output table

# Check cost forecast
az consumption usage list --top 5 --output table
```

---


# Phase O1: Integrated Security Hub – Dual‑Firewall (Azure Firewall + FortiGate NVA)

## Objective
Deploy FortiGate NVA in a dedicated spoke, configure functional traffic separation: Azure Firewall handles internet egress (`0.0.0.0/0`), FortiGate handles East‑West and hybrid traffic (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`).

## Step-by-Step Actions

### Step O1.1: Deploy FortiGate NVA (ephemeral)
Using Terraform – deploy a Linux VM from FortiGate marketplace image:
```hcl
# terraform/modules/fortigate/main.tf
data "azurerm_platform_image" "fortigate" {
  publisher = "fortinet"
  offer     = "fortinet_fortigate-vm_v5"
  sku       = "fortinet_fg-vm_payg_2023"
}

resource "azurerm_public_ip" "fortigate" {
  name                = "pip-fortigate-uksouth-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "fortigate_mgmt" {
  name                = "nic-fortigate-mgmt-01"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "mgmt"
    subnet_id                     = var.mgmt_subnet_id   # snet-mgmt in hub
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.fortigate.id
  }
}

resource "azurerm_network_interface" "fortigate_trust" {
  name                = "nic-fortigate-trust-01"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "trust"
    subnet_id                     = var.trust_subnet_id   # snet-workload (spoke)
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.1.4"
  }
}

resource "azurerm_linux_virtual_machine" "fortigate" {
  name                = "vm-dev-fortigate-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = random_password.fortigate_admin.result
  network_interface_ids = [
    azurerm_network_interface.fortigate_mgmt.id,
    azurerm_network_interface.fortigate_trust.id
  ]

  source_image_id = data.azurerm_platform_image.fortigate.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    Ephemeral = "true"
  }
}
```

### Step O1.2: Configure UDRs for functional separation
Update route tables to send internal traffic (`10.0.0.0/8`) to FortiGate, internet traffic (`0.0.0.0/0`) to Azure Firewall.
```hcl
# Additional routes in existing route table
resource "azurerm_route" "internal_to_fortigate" {
  name                   = "internal-to-fortigate"
  route_table_name       = azurerm_route_table.udr_to_firewall.name
  resource_group_name    = var.resource_group_name
  address_prefix         = "10.0.0.0/8"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.1.1.4"   # FortiGate trust IP
}

# Keep existing default route (0.0.0.0/0) pointing to Azure Firewall (10.0.1.4)
```

### Step O1.3: Configure FortiGate firewall policies (via shell provisioner or Ansible)
Example CLI snippet to allow East‑West traffic:
```bash
# SSH into FortiGate (using mgmt public IP)
config firewall policy
    edit 1
        set name "allow-spoke-to-spoke"
        set srcintf "trust"
        set dstintf "trust"
        set srcaddr "10.0.0.0/8"
        set dstaddr "10.0.0.0/8"
        set action accept
        set schedule "always"
        set service "ALL"
    next
end
```

### Step O1.4: Validate traffic flow
From spoke VM (`vm-dev-client-01`):
```bash
# Internet traffic should go through Azure Firewall
curl -v [https://microsoft.com](https://microsoft.com)   # success (allowed by AzFW)
curl -v [http://example.com](http://example.com)      # blocked by AzFW (logged)

# East-West traffic to another spoke (or simulated) should go through FortiGate
ping 10.2.0.4   # should succeed, trace route shows FortiGate IP (10.1.1.4)
```

## Validation Checklist
- [ ] FortiGate VM is running (public IP accessible for management).
- [ ] UDRs show two next‑hop entries: `0.0.0.0/0` → Azure Firewall, `10.0.0.0/8` → FortiGate.
- [ ] `traceroute` from spoke VM to another internal IP shows FortiGate as hop.
- [ ] Firewall logs (Azure Firewall) show internet egress; FortiGate logs show East‑West.

## Text Diagram – Phase O1 Resources
```
PHASE O1: DUAL-FIREWALL (AZFW + FORTIGATE)
===========================================

[Hub VNet: vnet-dev-uksouth-hub] (10.0.0.0/16)
         │
         ├── [Azure Firewall: afw-dev-uksouth-01] (10.0.1.4)
         │         └── Handles: 0.0.0.0/0 (internet egress)
         │
         ├── [Subnet: snet-mgmt] (10.0.4.0/24)
         │
         └── [Route Table: rt-udr-to-firewall-uksouth] (attached to spoke subnets)
               ├── route default: 0.0.0.0/0 → 10.0.1.4 (AzFW)
               └── route internal: 10.0.0.0/8 → 10.1.1.4 (FortiGate)

[Spoke Workload VNet: vnet-dev-uksouth-spoke-workload] (10.1.0.0/16)
         │
         ├── [Subnet: snet-workload] (10.1.0.0/24)
         │         ├── VM: vm-dev-client-01 (10.1.0.4)
         │         └── FortiGate trust NIC: 10.1.1.4
         │
         └── [FortiGate NVA: vm-dev-fortigate-01] (ephemeral)
               ├── Mgmt NIC (public IP) – for configuration
               └── Trust NIC (10.1.1.4) – East-West inspection

Traffic flow:
  10.1.0.4 → 8.8.8.8 (internet)   → UDR default → AzFW (10.0.1.4) → internet
  10.1.0.4 → 10.2.0.4 (internal) → UDR internal → FortiGate (10.1.1.4) → peered VNet

LEGEND:
======>
[Azure Firewall]      Cloud-native internet egress
[FortiGate NVA]       Third-party BGP & East-West inspection
{ephemeral}           Destroy after validation
```

### FinOps Teardown for O1
```bash
terraform destroy -target=azurerm_linux_virtual_machine.fortigate -auto-approve
# Also delete associated public IP, NICs, and disk
terraform destroy -target=azurerm_public_ip.fortigate -auto-approve
```

---

# Phase O2: Hybrid Cloud Management – Azure Arc

## Objective
Install Azure Arc agent on an on‑premises (or Hyper‑V) virtual machine, project it into Azure Resource Manager, and enforce an Azure Policy (e.g., tag enforcement) on the Arc‑connected machine.

**Note:** This phase assumes you have a local Hyper‑V VM (Windows or Linux) with outbound internet access.

## Step-by-Step Actions

### Step O2.1: Generate Arc onboarding script
```bash
# From Azure CLI (logged into target subscription)
az connectedmachine onboarding --resource-group rg-dev-arc-uksouth --location uksouth --generate-script --output-file arc-onboard.ps1
```

### Step O2.2: Run the script on the on‑premises VM (as Administrator)
```powershell
# On the local VM (e.g., Windows Server 2019)
.\arc-onboard.ps1
```

### Step O2.3: Verify connected machine in Azure
```bash
az connectedmachine list --resource-group rg-dev-arc-uksouth --output table
# Expected output: shows your on-prem VM (e.g., "vm-onprem-dc1" or "hyperv-vm-01")
```

### Step O2.4: Apply a test Azure Policy to the Arc machine
Assign a policy that enforces a tag (e.g., "ArcManaged: true"):
```hcl
# Terraform resource for policy assignment at resource group scope
resource "azurerm_resource_group_policy_assignment" "arc_tags" {
  name                 = "polassign-arc-mandatory-tags"
  resource_group_id    = azurerm_resource_group.arc.id
  policy_definition_id = azurerm_policy_definition.mandatory_tags.id
  parameters = jsonencode({
    "tagName" = { value = "ArcManaged" }
    "tagValue" = { value = "true" }
  })
}
```

### Step O2.5: Validate policy compliance
```bash
# On the Arc VM, check if policy is enforced (tag missing should cause deny)
az tag create --resource-id $(az connectedmachine show --name <vm-name> --resource-group rg-dev-arc-uksouth --query id -o tsv) --tags ArcManaged=true
```

## Validation Checklist
- [ ] `az connectedmachine list` shows the on‑prem VM with status "Connected".
- [ ] Azure Policy assignment appears in compliance view.
- [ ] The VM can be managed via Azure CLI (e.g., `az connectedmachine show`).

## Text Diagram – Phase O2 Resources

```
PHASE O2: AZURE ARC (HYBRID PROJECTION)
========================================

[On-Premises / Hyper-V Lab]
         │
         ├── [Local VM: hyperv-vm-01] (Windows Server / Linux)
         │         │
         │         └── (Azure Arc agent installed) → outbound HTTPS to ARM
         │
         │
         ▼
[Azure Resource Manager]
         │
         └── [Resource Group: rg-dev-arc-uksouth]
               │
               └── [Connected Machine: hyperv-vm-01] (projected)
                     │
                     ├── Azure Policy: mandatory tags (ArcManaged=true)
                     └── Can be managed like native VM (extensions, policies, logs)

Logs flow to Log Analytics (optional) if agent configured.

LEGEND:
======>
[Connected Machine]   On-prem resource projected into Azure
[Azure Arc agent]     Bi-directional communication channel
```

---

# Phase-by-Phase Implementation Guide – Release 2

**Version:** 3.0  
**Aligns with:** `README_PLAN.md`, `implementation-tracker.md`, and `naming-conventions.md`  
**Purpose:** Operator-focused execution guide for Release 2 with compact diagrams, key configuration snapshots, validation gates, and evidence reminders.  
**Primary Rule:** If this guide conflicts with `README_PLAN.md`, follow `README_PLAN.md` and update this file.

---

## 1. How to Use This Guide

This file is the **working operator guide** for Release 2.

Use it when you need to:
- understand the phase quickly without jumping between files
- see the intended topology at a glance
- copy commands and execute in order
- confirm key configuration values before deployment
- validate outcomes and capture evidence
- remember teardown actions for ephemeral resources

This file is intentionally more practical than `README_PLAN.md` and more detailed than `implementation-tracker.md`.

---

## 2. Global Assumptions

- **Primary region:** `uksouth`
- **Primary source of truth:** `README_PLAN.md`
- **Evidence root:** `docs/release2/evidence/`
- **Routing standard for hybrid phases:** **VyOS**, not RRAS
- **CLI-first validation:** preferred over portal-only screenshots
- **Private-only workload principle:** workload VMs do not receive public IPs unless explicitly required by design
- **FinOps rule:** expensive optional phases should be destroyed after validation unless needed by the next phase

---

## 3. Global Addressing and Topology Snapshot

### Key Configuration Snapshot
- **Azure Hub VNet:** `10.0.0.0/16`
- **Azure Workload Spoke:** `10.1.0.0/16`
- **Azure Optional AVD / extra spoke:** `10.2.0.0/16`
- **On-prem simulated network:** `192.168.1.0/24`
- **AWS branch VPC:** `172.16.0.0/16`

### Resource Group Intent
- **Connectivity RG:** `rg-connectivity-prod-uksouth`
- **Corp / workload RG:** `rg-corp-prod-uksouth`
- **Identity RG:** `rg-identity-prod-uksouth`
- **Terraform state RG:** `rg-dev-terraformstate-uksouth`

### Identity / Namespace Snapshot
- **Entra tenant namespace:** `entra.azawslab.co.uk`
- **HQ AD domain:** `hq.azawslab.co.uk`
- **Branch namespace:** `br1.azawslab.co.uk`

### Text Diagram
```text
[Entra ID: entra.azawslab.co.uk]
              |
              |
      [Azure Subscription]
              |
   ---------------------------------
   |               |               |
   v               v               v
[Connectivity]   [Identity]     [Corp/Workload]
 rg-connectivity  rg-identity    rg-corp

Azure address space:
  Hub        = 10.0.0.0/16
  Workload   = 10.1.0.0/16
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
- [ ] VS Code / Codespaces plan confirmed
- [ ] GitHub environment `release-2` created
- [ ] Azure subscription upgraded to Pay-As-You-Go
- [ ] domain `entra.azawslab.co.uk` verified in Entra ID
- [ ] no CIDR overlap confirmed across Azure / on-prem / AWS
- [ ] evidence folders created under `docs/release2/evidence/`

---

## 5. Recommended Execution Order

### Core Phases
`P0 → P1 → P2a → P2b → P2c → P3 → P5 → P7 → P8 → P9a → P9b → P9c`

### Optional / Advanced Phases
- `P4` Azure Lighthouse
- `P6` Azure Firewall
- `O1` FortiGate NVA dual-firewall pattern
- `O2` Azure Arc
- `O3a` FortiGate ↔ VyOS BGP over IPSec
- `O3b` AWS Cisco branch with segmented BGP
- `O3c` global transit / transitive routing validation
- `O4` Entra Global Secure Access
- `O5` Azure Virtual Desktop + FSLogix

---

# PHASE P0: FOUNDATION & AUTOMATION BOOTSTRAP
==============================================

## Objective
Establish secretless authentication between GitHub Actions and Azure using OIDC, deploy the remote Terraform backend, and scaffold the repository structure.

## Key Configuration Snapshot
- **App registration / SPN:** `sp-terraform-gh`
- **GitHub environment:** `release-2`
- **Terraform backend RG:** `rg-dev-terraformstate-uksouth`
- **Terraform state storage account:** `stdevterraform001`
- **Terraform state container:** `tfstate`
- **Region:** `uksouth`

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
[RG: rg-dev-terraformstate-uksouth]
        |
        v
[Storage: stdevterraform001]
        |
        v
[Container: tfstate]
```

## Steps

### Step P0.1 – Confirm Azure context
```bash
az account show --output table
az account list --output table
```

### Step P0.2 – Create app registration and service principal
```bash
az ad app create --display-name "sp-terraform-gh" --sign-in-audience AzureADMyOrg

APP_ID=$(az ad app list --display-name "sp-terraform-gh" --query "[0].appId" -o tsv)
OBJECT_ID=$(az ad app list --display-name "sp-terraform-gh" --query "[0].id" -o tsv)

az ad sp create --id "$APP_ID"

SUB_ID=$(az account show --query id -o tsv)
az role assignment create --assignee "$APP_ID" --role Contributor --scope "/subscriptions/$SUB_ID"
```

### Step P0.3 – Create federated credential
```bash
az ad app federated-credential create --id "$OBJECT_ID" --parameters '{
  "name": "github-actions-release2",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:your-username/your-repo:environment:release-2",
  "audiences": ["api://AzureADTokenExchange"]
}'
```

### Step P0.4 – Create Terraform backend
```bash
az group create --name rg-dev-terraformstate-uksouth --location uksouth

az storage account create \
  --name stdevterraform001 \
  --resource-group rg-dev-terraformstate-uksouth \
  --location uksouth \
  --sku Standard_LRS \
  --kind StorageV2

ACCOUNT_KEY=$(az storage account keys list \
  --account-name stdevterraform001 \
  --resource-group rg-dev-terraformstate-uksouth \
  --query "[0].value" -o tsv)

az storage container create \
  --name tfstate \
  --account-name stdevterraform001 \
  --account-key "$ACCOUNT_KEY"
```

### Step P0.5 – Scaffold repo layout
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
  - allowed locations = `uksouth`
  - allowed VM SKUs = B-series only
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
  - UK South only
  - B-series only
  - mandatory tags
```

## Steps

### Step P1.1 – Create management groups
```bash
az account management-group create --name mg-platform-prod-global --display-name "mg-platform-prod-global"
az account management-group create --name mg-landingzones-prod-global --display-name "mg-landingzones-prod-global"
az account management-group create --name mg-sandbox-prod-global --display-name "mg-sandbox-prod-global"
```

### Step P1.2 – Move subscription under landing zones
```bash
SUB_ID=$(az account show --query id -o tsv)

az account management-group subscription add \
  --name mg-landingzones-prod-global \
  --subscription "$SUB_ID"
```

### Step P1.3 – Verify hierarchy
```bash
az account management-group show --name mg-landingzones-prod-global --expand --output json
```

### Step P1.4 – Deploy custom policies
Implement in `terraform/environments/dev/policies.tf`.

Required controls:
- allowed locations
- allowed VM SKUs
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

# PHASE P2a: TERRAFORM – REUSABLE MODULES
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
- **Monitoring intent:**
  - shared Log Analytics workspace

## Text Diagram
```text
[environments/dev/main.tf]
        |
        +--> [modules/security]
        |         |
        |         +--> Key Vault
        |         +--> random_password
        |
        +--> [modules/networking]
        |         |
        |         +--> hub/spoke VNets
        |         +--> subnets / NSGs / UDRs
        |
        +--> [modules/compute]
        |         |
        |         +--> private-only VM + NIC
        |
        +--> [modules/monitoring]
                  |
                  +--> Log Analytics
```

## Suggested Structure
```text
terraform/
├── environments/
│   └── dev/
└── modules/
    ├── compute/
    ├── monitoring/
    ├── networking/
    └── security/
```

## Steps

### Step P2a.1 – Create module folders
```bash
mkdir -p terraform/modules/{security,networking,compute,monitoring}
```

### Step P2a.2 – Build security module
Include:
- Key Vault
- `random_password`
- secret storage for VM admin password

### Step P2a.3 – Build networking module
Include:
- hub VNet
- workload spoke
- optional extra spoke(s)
- subnets
- NSGs
- route tables
- peering

### Step P2a.4 – Build compute module
Include:
- NIC without public IP
- workload VM
- secure admin secret flow

### Step P2a.5 – Build monitoring module
Include:
- Log Analytics workspace
- shared monitoring dependencies as needed

### Step P2a.6 – Validate
```bash
cd terraform/environments/dev
terraform fmt -check
terraform init
terraform validate
terraform plan
```

## Minimum Validation
- [ ] `terraform validate` succeeds
- [ ] `terraform plan` succeeds
- [ ] password handled as sensitive
- [ ] workload NIC has no public IP

## Suggested Evidence
- `docs/release2/evidence/P2a/tf-validate.txt`
- `docs/release2/evidence/P2a/tf-plan.txt`
- `docs/release2/evidence/P2a/vm-networkprofile.txt`

---

# PHASE P2b: ANSIBLE CONFIGURATION MANAGEMENT
=============================================

## Objective
Apply post-deployment configuration using reusable Ansible roles.

## Execution Environment Note
For this project, P2b is executed from the **workspace / Codespace** environment rather than the normal local editing workflow. This keeps Ansible-related work in a controlled Linux environment and separates it from general documentation work.

## Key Configuration Snapshot
- **Roles:**
  - `common`
  - `ad-join`
  - `webserver`
- **Execution path:** through your chosen private management path
- **Validation standard:** lint + successful run + idempotent rerun

## Text Diagram
```text
[Operator / Runner]
        |
        | management access
        v
[Private Azure VM / Management Path]
        |
        +--> [Role: common]
        +--> [Role: ad-join]
        +--> [Role: webserver]

Target outcome:
  - baseline config
  - domain join where applicable
  - IIS / app role where applicable
```

## Steps

### Step P2b.1 – Create role structure
```bash
mkdir -p ansible/roles/{common,ad-join,webserver}/{tasks,vars,handlers}
```

### Step P2b.2 – Create playbook structure
```bash
touch ansible/site.yml
mkdir -p ansible/inventory/dev
```

### Step P2b.3 – Build inventory
Use private IP addressing and the management access path you actually deploy.

### Step P2b.4 – Run lint
```bash
cd ansible
ansible-lint site.yml
```

### Step P2b.5 – Execute playbook
```bash
cd ansible
ansible-playbook -i inventory/dev/hosts.yml site.yml
```

### Step P2b.6 – Re-run for idempotency
```bash
cd ansible
ansible-playbook -i inventory/dev/hosts.yml site.yml
```

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

## Execution Environment Note
For this project, selected P2c validation tasks are performed from the **workspace / Codespace** environment to keep CI/CD-related checks in a consistent remote environment.

## Key Configuration Snapshot
- **Workflows:**
  - `oidc-test.yml`
  - `tf-ci.yml`
  - `tf-cd.yml`
- **GitHub environment:** `release-2`
- **Core checks:**
  - OIDC login
  - Terraform fmt/validate/plan
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

### Step P2c.1 – Create OIDC test workflow
Create `.github/workflows/oidc-test.yml`.

### Step P2c.2 – Create Terraform CI workflow
Required checks:
- checkout
- Azure login via OIDC
- setup Terraform
- `terraform fmt -check`
- `terraform init`
- `terraform validate`
- `terraform plan`

### Step P2c.3 – Create Terraform CD workflow
Required flow:
- push/merge to controlled branch
- Azure login via OIDC
- `terraform init`
- `terraform apply -auto-approve`

### Step P2c.4 – Configure branch protection
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
- **Allowed region:** `uksouth`
- **Allowed VM family:** B-series
- **Mandatory tags:** at minimum `Environment`, `Project`, `Owner`
- **RBAC focus:** least privilege for automation and operator roles

## Text Diagram
```text
[Management Group Policy Layer]
             |
             +--> Allowed region = UK South
             +--> Allowed SKUs   = B-series
             +--> Mandatory tags
             +--> RBAC review

Any non-compliant deployment:
  --> denied before resource creation
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
- [ ] non-UK South deployment denied
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
- **Hub VNet:** `10.0.0.0/16`
- **Workload spoke:** `10.1.0.0/16`
- **Optional additional spoke:** `10.2.0.0/16`
- **Key elements:** peerings, subnets, NSGs, route tables

## Text Diagram
```text
               [Hub VNet]
              10.0.0.0/16
                  / \
                 /   \
                v     v
 [Workload Spoke]     [Optional Spoke]
   10.1.0.0/16          10.2.0.0/16

Core intent:
  - central connectivity
  - peering-based reachability
  - route control for later firewall phases
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
az network vnet peering list --resource-group rg-connectivity-prod-uksouth --vnet-name vnet-dev-uksouth-hub -o table
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
- **Traffic intent:** `0.0.0.0/0` routed to Azure Firewall
- **Role:** internet egress control
- **Budget note:** commonly ephemeral

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

Validation intent:
  - allowed traffic passes
  - blocked traffic denied
  - logs confirm inspection
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
  - `0.0.0.0/0` → Azure Firewall
  - internal / hybrid prefixes → FortiGate

## Text Diagram
```text
                 [Azure Firewall]
                      ^
                      | 0.0.0.0/0
[Workload Spokes] ----+ 
                      |
                      v internal / hybrid
                 [FortiGate NVA]

Intent:
  - split policy domains
  - keep egress and hybrid inspection separate
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

# PHASE O3a: FORTIGATE ↔ VyOS BGP OVER IPSEC
============================================

## Objective
Establish hybrid connectivity between Azure and the on-prem simulated environment using **FortiGate on Azure** and **VyOS on Hyper-V** with BGP over IPSec.

## Key Configuration Snapshot
- **Azure edge:** FortiGate NVA
- **On-prem edge:** VyOS
- **Azure / FortiGate ASN:** `65515`
- **On-prem VyOS ASN:** `65001`
- **On-prem advertised prefix:** `192.168.1.0/24`
- **Key protocol pair:** IPSec + BGP

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

Route intent:
  - FortiGate advertises Azure prefixes
  - VyOS advertises 192.168.1.0/24
```

## Steps

### Step O3a.1 – Prepare VyOS
Document:
- management IP
- WAN-facing interface
- LAN-facing interface
- ASN
- Azure peer IP
- shared secret handling approach

### Step O3a.2 – Enable VyOS API if using provider-based automation
Secure and document API access appropriately.

### Step O3a.3 – Configure IPSec
Create the tunnel between FortiGate and VyOS using the values defined in the master plan.

### Step O3a.4 – Configure BGP
Establish BGP adjacency between FortiGate and VyOS.

### Step O3a.5 – Validate on VyOS
```bash
show bgp summary
show ip route
show vpn ipsec sa
```

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
PHASE O3c: TRANSITIVE ROUTING (GLOBAL HUB)
===========================================

                    [Azure FortiGate NVA] (ASN 65515)
                    (Transit Hub – route reflector)
                           /        \
                          /          \
   (BGP over IPSec)     /             \      (BGP over IPSec)
                        /               \
                       v                 v
                 [On-Prem HQ]      [AWS Branch]
                  (ASN 65001)       (ASN 65002)
                 192.168.1.0/24     172.16.1.0/24
                                     172.16.2.0/24

Route propagation:
  - HQ learns: 172.16.1.0/24, 172.16.2.0/24 via FortiGate
  - AWS learns: 192.168.1.0/24 via FortiGate

Traffic flow (AWS -> HQ):
  172.16.2.10 -> (tunnel) -> FortiGate -> (tunnel) -> 192.168.1.10

Verification:
  traceroute from AWS to HQ shows Azure FortiGate as middle hop.
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

Intent:
  - identity-aware private access
  - reduced dependence on legacy VPN model
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
- **FinOps note:** session hosts may be treated as ephemeral

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

Validation intent:
  - user can sign in
  - profile persists correctly
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
└── release2/
    └── evidence/
        ├── P0/
        ├── P1/
        ├── P2a/
        ├── P2b/
        ├── P2c/
        ├── P3/
        ├── P4/
        ├── P5/
        ├── P6/
        ├── P7/
        ├── P8/
        ├── P9a/
        ├── P9b/
        ├── P9c/
        ├── O1/
        ├── O2/
        ├── O3a/
        ├── O3b/
        ├── O3c/
        ├── O4/
        └── O5/
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
```

## Validation Checklist
- [ ] IPSec tunnel status is "up" (FortiGate: `diagnose vpn ike gateway list`).
- [ ] BGP state is "Established" (`get router info bgp summary`).
- [ ] Spoke VM effective routes show `192.168.1.0/24` with next hop FortiGate IP (10.1.1.4).
- [ ] `ping 192.168.1.10` from spoke VM succeeds through tunnel.

## Text Diagram – Phase O3a Resources
```
PHASE O3a: BGP OVER IPSEC (AZURE FORTIGATE ↔ ON-PREM HQ)
========================================================

[Azure Hub – FortiGate NVA: vm-dev-fortigate-01]
   ASN: 65515
   BGP Router ID: 10.1.1.4
         │
         │ (IPSec tunnel – IKEv2 / AES256)
         │ (BGP peering over tunnel)
         ▼
[On-Premises HQ – Hyper-V RRAS]
   ASN: 65001
   BGP Router ID: 192.168.1.1
   Advertised routes: 192.168.1.0/24

Routes exchanged:
   FortiGate advertises: 10.0.0.0/8, 172.16.0.0/12
   RRAS advertises: 192.168.1.0/24

Spoke VM: vm-dev-client-01 (10.1.0.4)
   Effective route: 192.168.1.0/24 → NextHop: 10.1.1.4 (FortiGate)

Result: Azure workloads can reach on-prem servers (and vice versa).

LEGEND:
======>
[IPSec tunnel]        Encrypted VPN
[BGP]                 Dynamic route exchange
```

---

# Phase O3b: Multi-Cloud Foundation – AWS Cisco NVA with Segmented Peering

## Objective
Deploy a Cisco Catalyst 8000V NVA in an AWS VPC (with DMZ and Trusted subnets), establish BGP peering with Azure FortiGate, and selectively advertise DMZ (172.16.2.0/24) vs. Trusted (172.16.1.0/24) routes.

## Step-by-Step Actions

### Step O3b.1: Deploy AWS VPC and Cisco NVA using Terraform (AWS provider)
```hcl
# provider "aws" configured separately
resource "aws_vpc" "branch" {
  cidr_block = "172.16.0.0/16"
  tags = { Name = "vpc-azawslab-branch" }
}

resource "aws_subnet" "trusted" {
  vpc_id            = aws_vpc.branch.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "subnet-trusted" }
}

resource "aws_subnet" "dmz" {
  vpc_id            = aws_vpc.branch.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "subnet-dmz" }
}

# Cisco 8000V AMI (example – replace with actual)
data "aws_ami" "cisco" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Cisco Cloud Services Router (CSR) 1000V *"]
  }
  owners = ["679593333241"]
}

resource "aws_instance" "cisco" {
  ami           = data.aws_ami.cisco.id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.trusted.id
  associate_public_ip_address = true
  tags = { Name = "cisco-dev-branch-01" }
}
```

### Step O3b.2: Configure Cisco IOS‑XE for BGP (selective advertisement)
```bash
# SSH to Cisco instance
configure terminal
router bgp 65002
 bgp router-id 172.16.1.10
 neighbor 10.1.1.4 remote-as 65515   # Azure FortiGate IP (over IPSec tunnel)
 neighbor 10.1.1.4 activate
 !
 address-family ipv4
  network 172.16.1.0 mask 255.255.255.0   # Advertise Trusted
  network 172.16.2.0 mask 255.255.255.0   # Advertise DMZ
  neighbor 10.1.1.4 activate
 exit-address-family
end
write memory
```

### Step O3b.3: Establish IPSec tunnel between Cisco and FortiGate (similar to O3a but with AWS public IPs)
(Steps omitted for brevity – symmetric to O3a.)

### Step O3b.4: Verify BGP routes on FortiGate
```bash
get router info routing-table bgp
# Should show:
#   172.16.1.0/24 via 10.1.1.10 (Cisco)
#   172.16.2.0/24 via 10.1.1.10
```

## Validation Checklist
- [ ] AWS Cisco instance is running and reachable.
- [ ] BGP peering to FortiGate is Established (`show ip bgp summary` on Cisco).
- [ ] FortiGate routing table includes both 172.16.1.0/24 and 172.16.2.0/24.
- [ ] Spoke VM (`vm-dev-client-01`) can ping 172.16.1.10 (Cisco trusted NIC) via FortiGate.

## Text Diagram – Phase O3b Resources
```
PHASE O3b: AWS CISCO NVA (SEGMENTED PEERING)
=============================================

[AWS VPC: 172.16.0.0/16]
         │
         ├── [Subnet: Trusted] (172.16.1.0/24) → Cisco NVA NIC: 172.16.1.10
         ├── [Subnet: DMZ] (172.16.2.0/24)
         │
         └── [Cisco Catalyst 8000V: cisco-dev-branch-01] (ASN 65002)
               │
               │ (BGP over IPSec)
               ▼
[Azure FortiGate: vm-dev-fortigate-01] (ASN 65515)
         │
         └── (learns routes) → 172.16.1.0/24 (Trusted), 172.16.2.0/24 (DMZ)

Selective advertisement (Cisco config):
  network 172.16.1.0 mask 255.255.255.0   # Trusted segment
  network 172.16.2.0 mask 255.255.255.0   # DMZ segment
  # No "redistribute connected" – only these two prefixes.

Azure Spoke VM can reach both subnets via FortiGate.

LEGEND:
======>
[Cisco NVA]           Multi-cloud BGP router
[Trusted / DMZ]       Logical workload segments
```

### FinOps Teardown for O3b
```bash
# From AWS CLI / Terraform
terraform -chdir=aws/ destroy -auto-approve
# Also remove IPSec tunnel configuration from FortiGate (Terraform destroy)
```

---

# Phase O3c: Multi-Cloud Transitive Routing (The Global Hub)

## Objective
Enable transitive routing through the Azure FortiGate so that AWS branch and On‑Prem HQ can communicate via the Azure hub (without direct VPN).

## Step-by-Step Actions

### Step O3c.1: Configure FortiGate to readvertise routes between BGP peers
On FortiGate, enable route redistribution:
```bash
config router bgp
    config neighbor
        edit "192.168.1.1"   # HQ
            set route-reflector-client enable   # or simply ensure no filtering
        next
        edit "172.16.1.10"   # AWS Cisco
            set route-reflector-client enable
        next
    end
    config network
        # Already advertising Azure prefixes
    end
    set ibgp-multipath enable
end
```

### Step O3c.2: Ensure no inbound route filtering (default accept)
```bash
config router prefix-list
    edit "allow-all"
        config rule
            edit 1
                set action permit
                set prefix 0.0.0.0 0.0.0.0
                set ge 0 le 32
            next
        end
    next
end
```

### Step O3c.3: Verify transit routing
From AWS Cisco NVA, attempt to ping on‑prem HQ server (192.168.1.10):

```bash
# On AWS Cisco
ping 192.168.1.10 source 172.16.1.10
# Should succeed, with traceroute showing Azure FortiGate IP (10.1.1.4) as transit.

# On on‑prem HQ, ping AWS DMZ instance (172.16.2.10)
ping 172.16.2.10
```

### Step O3c.4: Capture traceroute evidence
```bash
# From AWS Cisco
traceroute 192.168.1.10
# Output should show:
# 1 172.16.1.4 (FortiGate trust IP) ... then 192.168.1.1 (HQ RRAS)

# Save output
traceroute 192.168.1.10 > docs/release2/evidence/O3c/traceroute-aws-to-hq.txt
```

## Validation Checklist
- [ ] BGP tables on FortiGate contain both HQ and AWS prefixes.
- [ ] AWS Cisco can ping on‑prem HQ server.
- [ ] On‑prem HQ can ping AWS DMZ instance.
- [ ] Traceroute shows Azure FortiGate as transit hop (proving hub‑spoke model).

## Text Diagram – Phase O3c Resources
```
PHASE O3c: TRANSITIVE ROUTING (GLOBAL HUB)
===========================================

                    [Azure FortiGate NVA] (ASN 65515)
                    (Transit Hub – route reflector)
                           /        \
                          /          \
   (BGP over IPSec)     /             \      (BGP over IPSec)
                        /               \
                       ▼                 ▼
[On-Prem HQ]                      [AWS Branch]
 (ASN 65001)                        (ASN 65002)
 192.168.1.0/24                    172.16.1.0/24
                                   172.16.2.0/24

Route propagation:
  - HQ learns: 172.16.1.0/24, 172.16.2.0/24 via FortiGate
  - AWS learns: 192.168.1.0/24 via FortiGate

Traffic flow (AWS → HQ):
  172.16.2.10 → (tunnel) → FortiGate (10.1.1.4) → (tunnel) → 192.168.1.10

Verification:
  traceroute from AWS to HQ shows Azure FortiGate as middle hop.

LEGEND:
======>
[Transit Hub]         Central BGP route reflector
[Global Hub]          True multi-cloud hybrid connectivity
```

### FinOps Teardown for O3c
No additional resources – depends on FortiGate and Cisco NVAs. Destroy those previous ephemeral resources:
```bash
terraform destroy -target=azurerm_linux_virtual_machine.fortigate -auto-approve
terraform -chdir=aws/ destroy -auto-approve
```

---

# Phase O4: Unified Zero Trust Edge – Entra Global Secure Access (GSA)

## Objective
Replace legacy Azure VPN Gateway (OpenVPN P2S) with Microsoft Entra Global Secure Access (SSE edge). Configure Private Access for RDP to `vm-dev-client-01` (no VPN client required), Internet Access for web filtering, and optionally Remote Networks for router‑to‑PoP BGP.

## Step-by-Step Actions

### Step O4.1: Enable GSA in Entra admin centre (UI or Graph API)
```powershell
# Using Microsoft Graph PowerShell (requires Global Admin)
Connect-MgGraph -Scopes "NetworkAccess.ReadWrite.All"

# Enable Private Access (ZTNA)
Update-MgNetworkAccessSetting -NetworkAccessSettingId "PrivateAccess" -Enabled $true

# Enable Internet Access (SWG)
Update-MgNetworkAccessSetting -NetworkAccessSettingId "InternetAccess" -Enabled $true
```

### Step O4.2: Deploy Private Access connector (VM in Azure)
```hcl
# terraform/modules/gsa_connector/main.tf
resource "azurerm_windows_virtual_machine" "gsa_connector" {
  name                = "vm-dev-gsa-connector-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = random_password.gsa_connector.result
  network_interface_ids = [azurerm_network_interface.gsa_connector.id]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "gsa_connector" {
  name                = "nic-gsa-connector-01"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id   # management subnet (10.0.4.0/24)
    private_ip_address_allocation = "Dynamic"
  }
}
```

After VM creation, install the GSA connector agent (download from Entra admin centre) and register it.

### Step O4.3: Create Private Access application segment for RDP
Using Microsoft Graph API:
```json
// docs/release2/evidence/O4/private-access-segment.json
{
  "name": "Seg-Corp-RDP",
  "applicationSegments": [
    {
      "destinationHost": "10.1.0.4",
      "ports": ["3389"],
      "protocol": "TCP"
    }
  ],
  "connectorGroupId": "<connector-group-id>"
}
```

Upload via PowerShell:
```powershell
$body = Get-Content -Raw .\private-access-segment.json
Invoke-MgGraphRequest -Method POST -Uri "[https://graph.microsoft.com/beta/networkAccess/applicationSegments](https://graph.microsoft.com/beta/networkAccess/applicationSegments)" -Body $body
```

### Step O4.4: Configure Conditional Access policy to require GSA
In Entra admin centre → Protection → Conditional Access → New policy:
- Users: `azw-Test-Users`
- Target resources: Private Access app (RDP segment)
- Grant: "Require compliant device" or "Require Global Secure Access"
- Session: "Use Global Secure Access"

### Step O4.5: Validate access (no VPN required)
On a client device (Windows/macOS) with GSA client installed and signed in:
```powershell
# Without GSA – RDP should fail (network unreachable)
Test-NetConnection 10.1.0.4 -Port 3389   # fails

# After GSA client connects – traffic is tunneled via ZTNA
# RDP should succeed to vm-dev-client-01 (private IP)
mstsc /v:10.1.0.4
```

### Step O4.6: (Optional) Remote Networks – BGP from FortiGate to GSA PoP
Replace legacy VPN Gateway by peering FortiGate directly to Entra GSA PoP. This step is complex and requires Entra GSA premium trial.
```bash
# On FortiGate – configure IPSec to GSA PoP (pre‑shared key provided by Entra)
config vpn ipsec phase1-interface
    edit "to-gsa-pop"
        set interface "trust"
        set ike-version 2
        set remote-gw <gsa-pop-public-ip>
        set psksecret "<psk>"
    next
end
```

Then create a "Remote Network" in Entra admin centre and associate with the BGP peer.

## Validation Checklist
- [ ] GSA Private Access connector VM status = "Active" in Entra.
- [ ] RDP to `10.1.0.4` succeeds only when GSA client is running (proves ZTNA).
- [ ] Azure VPN Gateway can be decommissioned (no more $138/month).
- [ ] (Optional) BGP session to GSA PoP shows "Established".

## Text Diagram – Phase O4 Resources
```text
PHASE O4: ENTRA GLOBAL SECURE ACCESS (SSE EDGE)
================================================

[Remote User Laptop]
         │
         ├── (GSA client – no VPN adapter)
         │     └── Identity + device compliance (Conditional Access)
         ▼
[Entra GSA Edge – Point of Presence (PoP)]
         │
         ├── Private Access (ZTNA)
         │         └── (connector: vm-dev-gsa-connector-01 in mgmt subnet)
         │
         ├── Internet Access (SWG)
         │         └── Web filtering, tenant restrictions
         │
         └── Remote Networks (optional BGP)
               └── IPSec tunnel to FortiGate (Azure)

Traffic flow (RDP to private VM):
  User → GSA client → GSA PoP → connector VM → spoke VM (10.1.0.4)
  No public IP, no inbound firewall rule – true Zero Trust.

Legacy VPN Gateway (vpngw-dev-uksouth) – DECOMMISSIONED.
Savings: ~$138/month.

LEGEND:
======>
[GSA client]          Identity‑based tunnel
[Private Access]      ZTNA – no inbound firewall required
```

### FinOps Teardown for O4
```bash
# Decommission legacy VPN Gateway (if still running)
terraform destroy -target=azurerm_virtual_network_gateway.vpngw -auto-approve

# Remove GSA connector VM (if not needed)
terraform destroy -target=azurerm_windows_virtual_machine.gsa_connector -auto-approve

# In Entra admin centre, disable GSA features or leave (no cost if not used)
```

---

# Phase O5: Modern End-User Computing – AVD & FSLogix

## Objective
Deploy Azure Virtual Desktop (AVD) with pooled session hosts (Windows 11 Multi‑session), FSLogix profile containers on Azure Files (premium), and auto‑scaling (power on/off). Integrate with Entra GSA (from O4) for Zero Trust access.

## Step-by-Step Actions

### Step O5.1: Deploy AVD host pool, workspace, and application group (Terraform)
```hcl
# terraform/modules/avd/main.tf
resource "azurerm_virtual_desktop_host_pool" "pooled" {
  name                 = "hp-dev-pooled"
  location             = var.location
  resource_group_name  = var.resource_group_name
  type                 = "Pooled"
  load_balancer_type   = "BreadthFirst"
  maximum_sessions_allowed = 10

  custom_rdp_properties = "targetisaadjoined:i:1;useavadmsgextension:i:1;"
}

resource "azurerm_virtual_desktop_application_group" "desktop" {
  name                 = "dag-dev-desktop"
  location             = var.location
  resource_group_name  = var.resource_group_name
  type                 = "Desktop"
  host_pool_id         = azurerm_virtual_desktop_host_pool.pooled.id
  friendly_name        = "Development Desktop"
  description          = "Windows 11 Multi-session AVD"
}

resource "azurerm_virtual_desktop_workspace" "avd" {
  name                = "ws-dev-uksouth"
  location            = var.location
  resource_group_name = var.resource_group_name
  friendly_name       = "Azawslab AVD Workspace"
  description         = "Central AVD workspace"
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "link" {
  workspace_id         = azurerm_virtual_desktop_workspace.avd.id
  application_group_id = azurerm_virtual_desktop_application_group.desktop.id
}
```

### Step O5.2: Deploy session host VMs (pooled, ephemeral)
```hcl
resource "azurerm_network_interface" "avd_session" {
  count               = 2
  name                = "nic-avd-session-0${count.index+1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.avd_subnet_id   # snet-avd-sessionhosts
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "avd_session" {
  count                 = 2
  name                  = "vm-dev-avdsession-0${count.index+1}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_B2s"   # ephemeral – destroy after test
  admin_username        = "azureuser"
  admin_password        = var.admin_password   # from Key Vault
  network_interface_ids = [azurerm_network_interface.avd_session[count.index].id]

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-avd-m365"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    Ephemeral = "true"
  }
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "avd" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.pooled.id
  expiration_date = timeadd(timestamp(), "8h")
  token           = azurerm_virtual_desktop_host_pool.pooled.registration_token
}
```

### Step O5.3: Deploy Azure Files premium share for FSLogix
```hcl
resource "azurerm_storage_account" "fslogix" {
  name                     = "stdevfslogix001"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Premium"
  account_kind             = "FileStorage"
  replication_type         = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_share" "fslogix" {
  name                 = "share-dev-fslogix"
  storage_account_name = azurerm_storage_account.fslogix.name
  quota                = 100   # GB
}
```

### Step O5.4: Configure FSLogix on session hosts (via DSC or Ansible)
Example PowerShell script to run on each session host:
```powershell
# Install FSLogix agent
$uri = "[https://aka.ms/fslogix_download](https://aka.ms/fslogix_download)"
$installer = "C:\temp\FSLogix_x64.msi"
Invoke-WebRequest -Uri $uri -OutFile $installer
msiexec /i $installer /quiet

# Configure registry
$regPath = "HKLM:\SOFTWARE\FSLogix\Profiles"
New-Item -Path $regPath -Force
Set-ItemProperty -Path $regPath -Name "Enabled" -Value 1 -Type DWord
Set-ItemProperty -Path $regPath -Name "VHDLocations" -Value "\\stdevfslogix001.file.core.windows.net\share-dev-fslogix" -Type String
Set-ItemProperty -Path $regPath -Name "SizeInMBs" -Value 30000 -Type DWord
```

### Step O5.5: Configure auto‑scaling (scaling plan)
Using Azure CLI (Terraform support limited):
```bash
az desktopvirtualization scaling-plan create \
  --name "sp-dev-avd-scaling" \
  --resource-group rg-dev-avd-uksouth \
  --location uksouth \
  --time-zone "GMT Standard Time" \
  --schedule '{
    "name": "Weekday",
    "daysOfWeek": ["Monday","Tuesday","Wednesday","Thursday","Friday"],
    "rampUpStartTime": "08:00",
    "rampUpLoadBalancingAlgorithm": "BreadthFirst",
    "peakStartTime": "10:00",
    "peakLoadBalancingAlgorithm": "DepthFirst",
    "rampDownStartTime": "18:00",
    "rampDownLoadBalancingAlgorithm": "BreadthFirst",
    "offPeakLoadBalancingAlgorithm": "BreadthFirst"
  }'
```

### Step O5.6: Validate FSLogix roaming
Test procedure:
1. User logs into `vm-dev-avdsession-01`, creates a desktop file.
2. Logs out (profile unloads, FSLogix container saved).
3. User logs into `vm-dev-avdsession-02` (different host).
4. Desktop file appears – proves profile container follows the user.

### Step O5.7: Integrate with Entra GSA (from O4)
Add the AVD app (workspace URL) as a Private Access segment in GSA. Users can now access AVD without VPN.

## Validation Checklist
- [ ] AVD workspace shows as "Available" in Entra admin centre / Remote Desktop client.
- [ ] FSLogix registry keys present on session hosts.
- [ ] Roaming test passes (file persists across different session hosts).
- [ ] Auto‑scaling plan shows hosts powered off during off‑peak hours (check `az vm power-state`).
- [ ] RDP to AVD session via GSA client (no VPN) succeeds.

## Text Diagram – Phase O5 Resources
```text
PHASE O5: AZURE VIRTUAL DESKTOP + FSLOGIX
==========================================

[Remote User – GSA Client]
         │
         │ (HTTPS / RDP over ZTNA)
         ▼
[AVD Workspace: ws-dev-uksouth] → (published desktop)
         │
         ▼
[AVD Host Pool: hp-dev-pooled] (load‑balanced)
         │
         ├── Session Host: vm-dev-avdsession-01 (ephemeral)
         ├── Session Host: vm-dev-avdsession-02 (ephemeral)
         │
         └── FSLogix agent installed on each

[Azure Files Premium: stdevfslogix001]
         │
         └── File Share: share-dev-fslogix (Profile .vhdx containers)

Auto‑scaling:
  - Weekdays 08:00‑18:00 → hosts running (peak)
  - Outside hours → hosts deallocated (cost savings)

Roaming flow:
  User logs into host-01 → profile mounted from share → log out → container unmounted
  User logs into host-02 → same profile mounted → desktop files appear

LEGEND:
======>
[FSLogix]            Profile container – separates user state from compute
{Auto-scaling}       FinOps best practice – pay only for active sessions
```

### FinOps Teardown for O5
```bash
# Deallocate or destroy AVD session hosts (ephemeral)
terraform destroy -target=azurerm_windows_virtual_machine.avd_session -auto-approve

# Remove AVD resources (host pool, workspace, etc.) if not needed
terraform destroy -target=azurerm_virtual_desktop_host_pool.pooled -auto-approve

# Azure Files premium share may have cost – delete if not required
terraform destroy -target=azurerm_storage_account.fslogix -auto-approve
```

---

**Congratulations!** We have now implemented the entire `README_PLAN.md` – from OIDC foundation to Zero Trust SSE and modern VDI.

**Final Checklist:**
- [ ] All phases (P0–P9c, O1–O5) have evidence in `docs/release2/evidence/`.
- [ ] Ephemeral resources destroyed (Azure Firewall, FortiGate, Cisco NVA, AVD hosts).
- [ ] Terraform state clean and locked.
- [ ] `terraform destroy` executed for all non‑persistent components.
- [ ] Cost analysis shows $0 projected spend (except for minimal storage and Entra ID free tier).

**Recruiter Hook (Final):**  
"Architected a full enterprise hybrid security platform using Terraform, Ansible, and GitHub Actions with OIDC – eliminating all static secrets. Implemented functional traffic separation (Azure Firewall + FortiGate NVA), multi‑cloud transitive BGP routing, and replaced legacy VPNs with Entra Global Secure Access (ZTNA). Delivered modern end‑user computing with AVD and FSLogix, all while adhering to strict FinOps principles ($200 lab budget) and CLI‑first validation."

---


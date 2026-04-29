# Phase-by-Phase Implementation Guide (Release 2)

**Version:** 1.0 (Prompt 1 – Phases P0, P1, P2a, P2b, P2c)  
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

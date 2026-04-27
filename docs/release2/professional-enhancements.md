# Professional Enhancements Addendum (Release 2)

**Purpose:** Elevate the project from a learning demo to a production‑grade, real‑world showcase.  
**Applies to:** All core phases (P0–P9c) and optional phases.  
**Prerequisite:** You must have completed Phase 0 (Foundation Setup) and have a working Terraform backend.

---

## 1. Bastion Host (Secure Jumpbox) – Updated Prerequisite

**Why:** Real production environments never assign public IPs to workload VMs. Instead, they use a **jumpbox** or **Azure Bastion** as a secure entry point.

**Decision:** Use **Azure Bastion** (fully managed PaaS) – no maintenance, but costs ~$0.19/hour. Deploy it only when needed (e.g., during Ansible runs), then destroy.

### 1.1 Add Bastion Subnet to Hub VNet

In Phase 5 (Hub‑Spoke Networking), ensure the hub VNet has a subnet named exactly `AzureBastionSubnet` with prefix `/26` (e.g., `10.0.4.0/26`). Update the `networking` module accordingly.

### 1.2 Deploy Bastion Host (Terraform)

Add this to the `terraform/environments/dev/main.tf` (or as a separate module). **Note:** Bastion requires a public IP.

```hcl
resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion-uksouth-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main" {
  name                = "bastion-dev-uksouth"
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id  # reference AzureBastionSubnet
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
```

### 1.3 Remove Public IPs from Workload VMs

In the `compute` module, **delete** the `azurerm_public_ip` resource and any association. Workload VMs should only have private IPs.

### 1.4 Configure Ansible to Use Bastion as Proxy

Modify the `ansible/inventory.yml` to use the Bastion host as a `ProxyJump`.

```yaml
all:
  children:
    windows_vms:
      hosts:
        vm-dev-client-01:
          ansible_host: 10.1.0.4           # private IP of the VM
          ansible_user: azureuser
          ansible_password: !vault |
            $ANSIBLE_VAULT...
          ansible_connection: winrm
          ansible_winrm_server_cert_validation: ignore
          ansible_ssh_common_args: '-o ProxyCommand="ssh -W %h:%p -q azureuser@<bastion-public-ip> -o StrictHostKeyChecking=no"'
```

**Cost control:** Deploy Bastion only when you run Ansible. Run `terraform destroy -target=azurerm_bastion_host.main` after each session. Document this in the `onboarding.md`.

---

## 2. Remote Backend & State Locking (Already Done)

Terraform’s `azurerm` backend automatically uses blob leases → state locking is active. No change needed. Add this note to  `phase0-foundation-setup.md`:

> ✅ **State locking** is enabled by default. Concurrent `terraform apply` from multiple sources will fail with a “lock conflict” error, preventing state corruption.

---

## 3. Dynamic Secrets with Azure Key Vault

**Replace static `admin_password` variables with automatically generated secrets stored in Key Vault.**

### 3.1 Generate Random Password

In `terraform/environments/dev/main.tf`:

```hcl
resource "random_password" "vm_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-admin-password"
  value        = random_password.vm_password.result
  key_vault_id = module.security.key_vault_id
}
```

### 3.2 Use the Password in VM Creation

```hcl
module "compute_win" {
  source = "../../modules/compute"
  vm_name          = "vm-dev-client-01"
  admin_password   = random_password.vm_password.result   # never hardcoded
  # ... other arguments
}
```

**Evidence:** Screenshot of the secret in Key Vault (value hidden). In `terraform plan` output, you will see `admin_password = (sensitive value)`.

---

## 4. Multi‑Environment Workspaces (Dev / Prod)

the structure already has `environments/dev/`. Add `environments/prod/` as a copy but with different CIDR blocks and naming.

### 4.1 Create `prod` environment

```bash
mkdir -p terraform/environments/prod
cp terraform/environments/dev/*.tf terraform/environments/prod/
```

Edit `prod/main.tf`:
- Change backend `key` to `release2.prod.tfstate`
- Change all names (e.g., `vnet-dev-...` → `vnet-prod-...`)
- Change address spaces (e.g., `10.10.0.0/16` for prod)

### 4.2 Use Workspaces (Alternative)

If you prefer workspaces over folder duplication, run:

```bash
terraform workspace new prod
terraform workspace select prod
```

Then use `terraform.workspace` variable to change names and CIDRs. This is more advanced but cleaner.

**Recruiter hook:** *“Implemented separate Dev and Prod environments using Terraform workspaces, ensuring identical infrastructure configuration with different networking and naming.”*

---

## 5. Ansible Roles over Playbooks

Refactor the monolithic playbooks into reusable roles.

### 5.1 Create Role Structure

```
ansible/
├── roles/
│   ├── common/
│   │   ├── tasks/
│   │   │   └── main.yml          # Security baseline tasks
│   │   └── vars/
│   │       └── main.yml          # Role-specific variables
│   ├── ad-join/
│   │   └── tasks/
│   │       └── main.yml
│   └── webserver/
│       └── tasks/
│           └── main.yml
├── site.yml
├── inventory.yml
└── ansible.cfg
```

### 5.2 Example `common/tasks/main.yml`

```yaml
- name: Disable SMBv1
  ansible.windows.win_regedit:
    path: HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters
    name: SMB1
    data: 0
    type: dword

- name: Enable Windows Defender real‑time monitoring
  ansible.windows.win_shell: Set-MpPreference -DisableRealtimeMonitoring $false
```

### 5.3 `site.yml` (Entry point)

```yaml
- hosts: windows_vms
  roles:
    - common
    - ad-join
    - webserver
```

### 5.4 Update GitHub Actions to run `ansible-lint`

Add a step before playbook execution:

```yaml
- name: Run ansible-lint
  run: |
    ansible-lint ansible/site.yml
    ansible-lint ansible/roles/*/tasks/*.yml
```

---

## 6. Additional Pro‑Level Tips

### 6.1 `lifecycle` Block for Critical Resources

Prevent accidental deletion of Key Vault, Storage Account, VNet:

```hcl
resource "azurerm_key_vault" "this" {
  # ...
  lifecycle {
    prevent_destroy = true
  }
}
```

### 6.2 Branch Protection Rule (GitHub)

1. GitHub repo → **Settings** → **Branches** → **Add rule**.
2. Branch name pattern: `release-2`.
3. Require pull request reviews (≥1).
4. Require status checks (select the CI workflow).
5. Require conversation resolution.
6. **Save.**

### 6.3 Tag Every Resource (Already in Phase 1)

Ensure all Terraform resources have a `tags` block that includes:

```hcl
tags = {
  Environment = "Development"
  Project     = "Azawslab-Release2"
  Owner       = "rik"
  CostCenter  = "Lab-123"
}
```

---

## 7. Updated Phase Sequence (With Enhancements)

| Phase | Original | Enhancement | New Deliverable |
|-------|----------|-------------|----------------|
| P0 | Foundation | State locking note, Bastion cost warning | Updated `phase0-foundation-setup.md` |
| P1 | Landing Zone | – | – |
| P2a | Terraform modules | Dynamic secrets, `prevent_destroy` | Modules use `random_password`, KV secret |
| P2b | Ansible | Bastion proxy, roles, ansible-lint | Role‑based playbooks, inventory with ProxyJump |
| P2c | CI/CD | Branch protection, ansible-lint step | Updated GitHub workflow, protection rule |
| P3 | Governance | – | – |
| P5 | Networking | Bastion subnet + host | Bastion deployed (ephemeral) |

---

## 8. Cost & Effort Added

| Enhancement | Extra cost (if any) | Extra effort |
|-------------|---------------------|--------------|
| Bastion host | ~$0.19/hour (destroy after use) | 1‑2 hours (setup + Ansible proxy config) |
| Dynamic secrets | $0 (free within Key Vault) | 30 minutes |
| Multi‑environment | $0 | 1 hour |
| Ansible roles | $0 | 1‑2 hours (refactoring) |
| Branch protection | $0 | 5 minutes |
| **Total** | **<$2** (if Bastion used for 10 hours) | **~4‑6 hours** |

---

## 9. Verification Checklist for “Pro” Status

- [ ] Bastion host deploys and you can RDP/SSH to private VMs through it.
- [ ] Terraform plan shows `admin_password = (sensitive)` – no plain text.
- [ ] `terraform destroy` is blocked for critical resources (lifecycle).
- [ ] `ansible-lint` runs in GitHub Actions and passes.
- [ ] Pull request to `release-2` cannot be merged without review.
- [ ] There is a `prod` environment (or workspace) with different CIDR blocks.
- [ ] Ansible roles are separate and `site.yml` uses them.

---

**After you apply these enhancements, the project will be indistinguishable from an internal enterprise platform. Recruiters will see production‑grade thinking, not just academic steps.**
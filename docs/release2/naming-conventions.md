# Release 2 Naming Conventions (Revised)

**Version:** 4.0 (Aligns with `README_PLAN_Revised.md` – Phases P0 through P9c plus O1–O5)  
**Last Updated:** [Current Date]  
**Applies to:** All Release 2 phases (foundation, core governance, optional hybrid/multi‑cloud, and end‑user computing).  
**Related Docs:** [Architecture Decision Records](./architechture.md), [Phase Plan](./README_PLAN_Revised.md)

---

## 1. Principles

- **Consistency** – Every resource follows the same pattern.
- **Readability** – Names clearly describe purpose, environment, and location.
- **Azure CAF alignment** – Matches Microsoft Cloud Adoption Framework recommendations.
- **Self‑documenting** – All identities (users, groups, SPNs) include a mandatory **Description** field explaining purpose.
- **FinOps awareness** – Ephemeral resources (Azure Firewall, FortiGate, AVD hosts) are named with standard patterns but will be destroyed after validation.

---

## 2. Resource Naming Patterns

| Resource Type | Pattern | Example | Notes |
|---------------|---------|---------|-------|
| **Management Group** | `mg-<purpose>-<env>-<region>` | `mg-platform-prod-global`, `mg-landingzones-prod-global`, `mg-sandbox-prod-global` | Use `prod` for lab; region `global` for management plane |
| **Subscription** | `sub-<workload>-<env>-<region>` | `sub-azaws-enterprise-prod` | Single subscription for lab (upgraded free trial) |
| **Resource Group** | `rg-<service>-<env>-<region>` | `rg-dev-terraformstate-uksouth`, `rg-connectivity-prod-uksouth`, `rg-corp-prod-uksouth`, `rg-identity-prod-uksouth` | `<service>` = connectivity, corp, identity, terraformstate, etc. |
| **Virtual Network** | `vnet-<env>-<region>-<purpose>` | `vnet-dev-uksouth-hub`, `vnet-dev-uksouth-spoke-workload`, `vnet-dev-uksouth-spoke-avd` | Purpose: hub, spoke-workload, spoke-avd, spoke-fortigate |
| **Subnet** | `snet-<purpose>` | `snet-GatewaySubnet`, `snet-AzureFirewallSubnet`, `snet-AzureBastionSubnet`, `snet-workload`, `snet-avd-sessionhosts`, `snet-mgmt` | Reserved names must match exactly |
| **Network Interface** | `nic-<vmname>-01` | `nic-dc1-01`, `nic-avd-session-01`, `nic-fortigate-01` | |
| **Public IP** | `pip-<resource>-<region>-01` | `pip-azfw-uksouth-01`, `pip-fortigate-uksouth-01` | Only for resources requiring inbound internet (firewall, VPN gateway) |
| **Network Security Group** | `nsg-<purpose>-<direction>` | `nsg-workload-inbound`, `nsg-mgmt-outbound`, `nsg-fortigate-inbound` | |
| **Route Table** | `rt-<purpose>-<region>` | `rt-udr-to-firewall-uksouth`, `rt-udr-to-fortigate-uksouth` | For forced tunneling and East‑West steering |
| **VPN Gateway** | `vpngw-<env>-<region>` | `vpngw-dev-uksouth` | Legacy – will be decommissioned after Phase O4 |
| **Local Network Gateway** | `lngw-<env>-<site>` | `lngw-dev-hq`, `lngw-dev-branch-br1` | For on‑prem / AWS simulation |
| **Azure Firewall** | `afw-<env>-<region>-01` | `afw-dev-uksouth-01` | **Ephemeral** – destroyed after Phase P6 validation |
| **Firewall Policy** | `afwp-<env>-<region>` | `afwp-dev-uksouth` | |
| **FortiGate NVA** | `vm-<env>-fortigate-01` | `vm-dev-fortigate-01` | **Ephemeral** – destroyed after Phase O3c / O4 validation |
| **Cisco Catalyst 8000V (AWS)** | `cisco-<env>-branch-01` | `cisco-dev-branch-01` | Naming used in AWS EC2; referenced in Azure FortiGate peer config |
| **Key Vault** | `kv-<env>-<purpose>-<suffix>` | `kv-dev-platform-001` | Suffix = 3-digit random or sequential |
| **Log Analytics Workspace** | `la-<env>-<purpose>` | `la-dev-platform` | |
| **Storage Account (Terraform state)** | `st<env><service><unique>` | `stdevterraform001` | Max 24 chars, lowercase, no hyphens |
| **Storage Account (FSLogix)** | `st<env>fslogix<unique>` | `stdevfslogix001` | Premium file share for profile containers |
| **Recovery Services Vault** | `rsv-<env>-<purpose>` | `rsv-dev-backup`, `rsv-dev-asr` | Immutable backup + MUA |
| **Azure Resource Guard** | `rg-<env>-resourceguard` | `rg-dev-resourceguard` | For MUA enforcement on backup |
| **Virtual Machine** | `vm-<env>-<role>-<number>` | `vm-dev-dc1-01`, `vm-dev-client-01`, `vm-dev-avd-session-01`, `vm-dev-fortigate-01` | Role: dc1, client, avd-session, fortigate, bastion, gsa-connector |
| **Availability Set** | `aset-<env>-<role>` | `aset-dev-avdsession` | |
| **Disk** | `disk-<vmname>-os|data-01` | `disk-dc1-os-01`, `disk-avdsession-data-01` | |
| **Azure Policy Definition** | `policy-<shortname>` | `policy-allowed-locations`, `policy-allowed-vm-skus`, `policy-mandatory-tags` | |
| **Policy Assignment** | `polassign-<purpose>-<scope>` | `polassign-allowed-locations-mg`, `polassign-allowed-skus-mg` | Scope: mg (management group) or sub |
| **Role Assignment** | `role-<principal>-<role>-<scope>` | `role-sp-terraform-contributor-sub`, `role-azw-platformadmins-contributor-mg` | |
| **Sentinel Workbook** | `workbook-<purpose>` | `workbook-azure-activity` | Built‑in or custom |
| **Analytic Rule** | `rule-<detection-name>` | `rule-multiple-failed-signins`, `rule-bgp-peer-flap` | |
| **Data Connector** | `connector-<source>` | `connector-azure-activity`, `connector-azure-firewall` | |
| **Azure Monitor Alert** | `alert-<condition>-<resource>` | `alert-high-cpu-vm-dev-client`, `alert-azfw-throughput` | |
| **Action Group** | `ag-<env>-<type>` | `ag-dev-email` | Email, ITSM, etc. |
| **Private DNS Zone** | `privatelink.<service>.azure.com` | `privatelink.blob.core.windows.net`, `privatelink.vaultcore.azure.net` | Fixed names – do not modify |
| **Azure Arc Connected Machine** | Use existing VM name (e.g., `vm-dev-dc1-01`) | | Metadata indicates `Arc` |
| **AVD Host Pool** | `hp-<env>-<pooltype>` | `hp-dev-pooled`, `hp-dev-personal` | Pooled = multi‑session |
| **AVD Application Group** | `dag-<env>-<type>` | `dag-dev-desktop`, `dag-dev-remoteapp` | Desktop or RemoteApp |
| **AVD Workspace** | `ws-<env>-<region>` | `ws-dev-uksouth` | |
| **FSLogix Profile Share** | `share-<env>-fslogix` | `share-dev-fslogix` | Azure Files share name |
| **Entra GSA Remote Network** | `gsa-rn-<site>` | `gsa-rn-azurehub`, `gsa-rn-awsbranch` | Logical container in Entra admin centre |
| **Entra GSA Private Access Connector** | `vm-<env>-gsa-connector-01` | `vm-dev-gsa-connector-01` | VM that hosts the GSA connector |

---

## 3. Environment Tags

Every resource must have these tags (apply at resource group or resource level):

| Tag Key | Example Value | Description |
|---------|---------------|-------------|
| `Environment` | `Development` | Use `Development` for Release 2 (single lab environment) |
| `Project` | `Azawslab-Release2` | Fixed for all Release 2 resources |
| `Owner` | `YourName` or `AzureLab` | Your identifier |
| `CostCenter` | `Lab-123` | Optional but recommended |
| `Ephemeral` | `true` | For resources destroyed after validation (Azure Firewall, FortiGate, AVD hosts) |
| `DeploymentMethod` | `Terraform` | All resources must be IaC |
| `AutoShutdown` | `true` | For VMs that are not ephemeral but should be auto-shutdown |

---

## 4. User, Group & Service Principal Naming (with Descriptions)

**All identity objects must have a non‑empty `Description` field** that clearly explains purpose, scope, and any caveats.

### Users (Main Tenant)

| Type | Naming Pattern | Example | Mandatory Description Example |
|------|----------------|---------|-------------------------------|
| Primary admin | `admin-<name>` | `admin-rik` | `"Primary Global Administrator for Release 2 – used for all configuration, policy assignment, and lighthouse delegation."` |
| Break‑glass admin | `bg-admin-<name>` | `bg-admin-emergency` | `"Emergency cloud‑only Global Administrator with FIDO2 MFA – stored in secure password manager. Used if primary admin inaccessible."` |
| Test user (general) | `test-<purpose>` | `test-rdp`, `test-sentinel`, `test-avd`, `test-gsa` | `"Test user for RDP connectivity via GSA Private Access, Sentinel incident simulation, and AVD assignment."` |

### Users (Customer Tenant – for Phase P4 Lighthouse)

| Type | Naming Pattern | Example | Mandatory Description Example |
|------|----------------|---------|-------------------------------|
| Customer admin | `cust-admin-<name>` | `cust-admin-rik` | `"Admin account in customer tenant used to accept Lighthouse delegation and verify cross‑tenant management via CLI (az vm list)."` |
| Customer reader | `cust-reader-<name>` | `cust-reader-audit` | `"Test user to validate read‑only delegated permissions from provider tenant."` |

### Groups (Main Tenant)

All groups must include a **Description** in Microsoft Entra ID.

| Group Name | Members | Mandatory Description |
|------------|---------|-----------------------|
| `azw-Platform-Admins` | `admin-rik`, `bg-admin-emergency` | `"Platform Administrators – full access to management groups, policies, networking, firewall, Key Vault, Sentinel, and Lighthouse delegation."` |
| `azw-Network-Operators` | `test-netadmin` (if created) | `"Network Operators – Network Contributor role on hub and spoke VNets, NSGs, UDRs, VPN Gateway, Azure Firewall, and FortiGate NVA."` |
| `azw-Security-Engineers` | `test-secadmin`, `admin-rik` | `"Security Engineers – Security Reader, Key Vault Reader, Sentinel Contributor, Defender for Cloud access, and GSA policy viewer."` |
| `azw-Test-Users` | `test-rdp`, `test-sentinel`, `test-avd`, `test-gsa` | `"Test users for Conditional Access policies, AVD assignment, GSA Private Access, and validation."` |

### Service Principals (Machine Identities)

| Name | Purpose | Mandatory Description |
|------|---------|------------------------|
| `sp-terraform-gh` | GitHub Actions with OIDC | `"Service principal used by GitHub Actions to deploy infrastructure via Terraform. Uses federated credential (OIDC) – no client secret. Contributor on the dev subscription."` |
| `sp-ansible` | Ansible automation (optional) | `"Service principal for Ansible to configure VMs (domain join, IIS, security baseline) via Azure dynamic inventory. Can reuse sp-terraform-gh if permissions suffice."` |
| `sp-lighthouse-customer` | Cross‑tenant automation (optional) | `"Service principal in customer tenant for automated delegated actions (e.g., inventory collection from provider tenant)."` |

---

## 5. Domain & DNS Suffixes

| Component | DNS Suffix | Used For |
|-----------|------------|----------|
| Corporate HQ Active Directory | `hq.azawslab.co.uk` | Primary AD forest, writeable DCs (on‑prem / Hyper‑V) |
| Branch RODC site | `br1.azawslab.co.uk` | Branch office namespace (optional for Phase O3a/O3b) |
| Entra ID tenant | `entra.azawslab.co.uk` | Cloud identity (verified custom domain) |
| Azure VM default DNS | `*.cloudapp.azure.com` | No need to customise; use internal DNS or Azure Private DNS |

**UPN transformation:** On‑prem users have UPN `user@hq.azawslab.co.uk`. Entra Connect transforms to `user@entra.azawslab.co.uk` during sync.

---

## 6. VNet Peering, UDRs, and BGP

- **VNet peering (Phase P5):**  
  Hub (`vnet-dev-uksouth-hub`) peers with each spoke (e.g., `vnet-dev-uksouth-spoke-workload`, `vnet-dev-uksouth-spoke-avd`).  
  Peering is bidirectional. Gateway transit is **not** used because spoke UDRs point directly to firewall/NVA.

- **UDRs (Phases P5, P6, O1):**  
  - Route table `rt-udr-to-firewall-uksouth` attached to spoke subnets: `0.0.0.0/0` → Azure Firewall private IP.
  - Route table `rt-udr-to-fortigate-uksouth` attached to spoke subnets: `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16` → FortiGate NVA private IP.

- **BGP (Phases O3a, O3b, O3c):**  
  BGP peer names are defined within FortiGate and Cisco configurations, not as Azure resources.  
  Use descriptive peer names: `peer-hq-rras` (ASN 65001), `peer-aws-cisco` (ASN 65002).  
  Azure FortiGate BGP ASN: `65515`.

---

## 7. Phase‑Specific Naming Examples (P0 – P9c, O1 – O5)

| Phase | Resource Type | Example Name(s) |
|-------|---------------|------------------|
| **P0** | Resource Group (state) | `rg-dev-terraformstate-uksouth` |
| **P0** | Storage Account (state) | `stdevterraform001` |
| **P0** | Service Principal | `sp-terraform-gh` (with OIDC federated credential) |
| **P1** | Management Groups | `mg-platform-prod-global`, `mg-landingzones-prod-global`, `mg-sandbox-prod-global` |
| **P1** | Subscription | `sub-azaws-enterprise-prod` |
| **P1** | Policy definitions | `policy-allowed-locations`, `policy-allowed-vm-skus`, `policy-mandatory-tags` |
| **P2a** | Resource Group (networking) | `rg-connectivity-prod-uksouth` |
| **P2a** | Hub VNet | `vnet-dev-uksouth-hub` |
| **P2a** | Spoke VNet (workload) | `vnet-dev-uksouth-spoke-workload` |
| **P2a** | Key Vault | `kv-dev-platform-001` |
| **P2a** | Log Analytics | `la-dev-platform` |
| **P2b** | Jumpbox / Bastion | `vm-dev-bastion-01` (or Azure Bastion service) |
| **P2b** | Domain Controller (simulated) | `vm-dev-dc1-01` (if on‑prem not available) |
| **P2b** | Client test VM | `vm-dev-client-01` |
| **P2c** | GitHub environment | `release-2` (branch) |
| **P3** | Policy assignments | `polassign-allowed-locations-mg`, `polassign-allowed-skus-mg`, `polassign-mandatory-tags-mg` |
| **P3** | RBAC assignment | `role-sp-terraform-contributor-sub` |
| **P4** | Lighthouse template | `lighthouse-customer-delegation.json` |
| **P5** | Route table (to AzFW) | `rt-udr-to-firewall-uksouth` |
| **P5** | Route table (to FortiGate) | `rt-udr-to-fortigate-uksouth` |
| **P5** | NSG (workload spoke) | `nsg-workload-inbound` |
| **P6** | Azure Firewall | `afw-dev-uksouth-01` (ephemeral) |
| **P6** | Firewall policy | `afwp-dev-uksouth` |
| **P7** | Defender for Cloud | Enable on subscription – no name needed |
| **P8** | Analytic rule | `rule-multiple-failed-signins`, `rule-azfw-blocked-traffic` |
| **P8** | Workbook | `workbook-azure-activity` |
| **P9a** | Alert rule | `alert-high-cpu-vm-dev-client` |
| **P9a** | Action Group | `ag-dev-email` |
| **P9b** | Recovery Services Vault | `rsv-dev-backup` |
| **P9b** | Resource Guard | `rg-dev-resourceguard` |
| **P9c** | Documentation | `docs/onboarding.md`, `CONTRIBUTING.md` |
| **O1** | FortiGate NVA | `vm-dev-fortigate-01` (ephemeral) |
| **O1** | FortiGate NSG | `nsg-fortigate-inbound` |
| **O2** | Azure Arc enabled VM | `vm-dev-dc1-01` (Arc‑enabled) – no separate name |
| **O3a** | BGP peer (FortiGate) | `peer-hq-rras` (logical) |
| **O3b** | Cisco NVA (AWS) | `cisco-dev-branch-01` (EC2 name tag) |
| **O3c** | Transitive route propagation | (No separate resource) |
| **O4** | Entra GSA Remote Network | `gsa-rn-azurehub` |
| **O4** | Entra GSA Connector VM | `vm-dev-gsa-connector-01` |
| **O5** | AVD Host Pool | `hp-dev-pooled` |
| **O5** | AVD Session Host VMs | `vm-dev-avdsession-01`, `vm-dev-avdsession-02` |
| **O5** | FSLogix Storage Account | `stdevfslogix001` |
| **O5** | FSLogix Share | `share-dev-fslogix` |

---

## 8. Exceptions & Special Cases

- **Azure built‑in subnets:** `GatewaySubnet`, `AzureFirewallSubnet`, `AzureBastionSubnet` – must use exact names.
- **Private DNS zones:** Must match the exact service FQDN (e.g., `privatelink.blob.core.windows.net`, `privatelink.vaultcore.azure.net`).
- **Storage account names:** Only lowercase letters and numbers, 3‑24 characters. Use prefix `st`, environment, purpose, and a short unique suffix (e.g., `stdevterraform001`).
- **Management Group names:** No spaces, hyphens allowed. Must be unique across tenant.
- **Ephemeral resources:** Azure Firewall, FortiGate NVA, Cisco NVA, and AVD session hosts must include the tag `Ephemeral = true` and will be destroyed after evidence collection. Do not rely on their persistence.
- **Tags:** Always include `Environment=Development`, `Project=Azawslab-Release2`, `DeploymentMethod=Terraform`.

---

## 9. Enforcement & Review

- All Terraform modules must accept `name` and `tags` variables – no hardcoded names.
- Pull requests must include a description of naming conformance.
- Evidence screenshots (if used) should clearly show resource names matching these conventions. **Primary evidence is CLI output** – names there must match.
- **Identity objects (users, groups, SPNs) must include the Description field** as shown in Section 4.
- Any deviation from these conventions must be documented in the ADR.

---

**End of Document – Use this as the authoritative naming reference for all Release 2 implementations aligned with `README_PLAN_Revised.md`.**

## 10. Repository & Evidence File Naming (Portability & Audit)

These conventions are **local to the Git repository** and are enforced via pull request reviews, not Azure policies.

### 10.1 Terraform File Naming (per module or environment root)

| File Type | Pattern | Example |
|-----------|---------|---------|
| Root configuration | `main.tf` | `terraform/environments/dev/main.tf` |
| Variables | `variables.tf` | `terraform/modules/compute/variables.tf` |
| Outputs | `outputs.tf` | `terraform/modules/networking/outputs.tf` |
| Terraform version & providers | `versions.tf` | `terraform/environments/dev/versions.tf` |
| Module call (root) | `main.tf` (only one per directory) | – |
| Variable values (non‑secret) | `terraform.tfvars` | **Do not commit** – use `.example` file |
| Variable values example | `terraform.tfvars.example` | `terraform/environments/dev/terraform.tfvars.example` |

**Secrets:** Never commit `.tfvars` with secrets. Use `random_password` + Key Vault (ADR‑008).

### 10.2 Ansible File Naming

| File/Directory | Pattern | Example |
|----------------|---------|---------|
| Master playbook | `site.yml` | `ansible/site.yml` |
| Role directory | `roles/<role-name>/` | `ansible/roles/ad-join/` |
| Role tasks | `roles/<role-name>/tasks/main.yml` | `ansible/roles/webserver/tasks/main.yml` |
| Role variables | `roles/<role-name>/vars/main.yml` | `ansible/roles/common/vars/main.yml` |
| Inventory file | `inventory/<env>/hosts.yml` | `ansible/inventory/dev/hosts.yml` (or `.ini`) |
| Group variables | `inventory/<env>/group_vars/all.yml` | `ansible/inventory/dev/group_vars/windows.yml` |
| Ansible Vault encrypted file | `*.vault.yml` | `secrets/vault.yml` (gitignored) |

### 10.3 Evidence Directory & File Naming (`docs/release2/evidence/`)

Each phase/sub‑phase has its own subdirectory. Evidence files must be named using the pattern:

`<phase>_<step>_<description>_<type>.<extension>`

| `<type>` | Meaning | Extension |
|----------|---------|-----------|
| `term` | Terminal output (CLI) | `.txt` or `.log` |
| `kql` | Kusto query and results | `.kql` or `.txt` |
| `tfplan` | Terraform plan output | `.txt` |
| `tfapply` | Terraform apply output | `.txt` |
| `ansible` | Ansible playbook run output | `.txt` |
| `scr` | Screenshot (portal) – secondary only | `.png` |
| `config` | Configuration file (e.g., ARM template, policy JSON) | `.json`, `.yaml`, `.tf` |

**Examples:**

- `P0_step2_oidc-handshake_term.txt`
- `P2a_module-tree_tfplan.txt`
- `P6_firewall-block-curl_kql.txt`
- `P8_sentinel-incident_scr.png`
- `O3a_bgp-summary_term.txt`

**Rules:**
- **Primary evidence must be terminal/KQL** (`.txt`, `.log`, `.kql`). Screenshots are only supplementary.
- Each file must be committed alongside the pull request that implements the phase.
- Do not commit large binary files (use text logs).

### 10.4 GitHub Actions Workflow Naming

| Workflow | File path | Purpose |
|----------|-----------|---------|
| OIDC test | `.github/workflows/oidc-test.yml` | Validate OIDC handshake (Phase 0) |
| Terraform CI | `.github/workflows/tf-ci.yml` | `plan`, `fmt`, `validate` on PR |
| Terraform CD | `.github/workflows/tf-cd.yml` | `apply` on merge to `release-2` |
| Ansible lint | `.github/workflows/ansible-lint.yml` | `ansible-lint` on roles |

**Branch protection:** `release-2` requires PR and status checks (CI workflows must pass).

---

## 11. Missed Items Check (Cross‑referenced against `README_PLAN_Revised.md`)

The following items are **not** Azure resources but should be named consistently. They are covered in sections above or in other docs:

| Item | Where defined | Status |
|------|---------------|--------|
| Terraform module names | `terraform/modules/<module-name>/` (e.g., `compute`, `networking`) | Added §10.1 |
| Ansible role names | `common`, `ad-join`, `webserver` | Added §10.2 |
| Evidence filenames | Pattern per §10.3 | Added |
| GitHub workflow filenames | `oidc-test.yml`, `tf-ci.yml`, `tf-cd.yml`, `ansible-lint.yml` | Added §10.4 |
| ARM template for Lighthouse | `lighthouse-customer-delegation.json` | Already in phase examples |
| Policy definition JSON | `policy-allowed-locations.json`, etc. | Use phase examples |
| KQL query files | `rule-multiple-failed-signins.kql` | Implied in §10.3 |
| FSLogix profile share name | `share-dev-fslogix` | Already in §7 |
| Azure Resource Guard name | `rg-dev-resourceguard` | Already in §7 |
| Entra GSA connector VM name | `vm-dev-gsa-connector-01` | Already in §7 |

**No critical naming gaps remain.**

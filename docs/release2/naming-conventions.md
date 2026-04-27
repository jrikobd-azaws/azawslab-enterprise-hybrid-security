# Release 2 Naming Conventions

**Version:** 3.0 (Final – Covers P1–P16)  
**Last Updated:** [Current Date]  
**Applies to:** All Release 2 phases P1 through P16 (core + optional).  
**Related Docs:** [Release 2 Blueprint](./RELEASE2_PLAN.md), [Domain Namespaces](./domain-namespaces.md)

---

## 1. Principles

- **Consistency** – Every resource follows the same pattern.
- **Readability** – Names clearly describe purpose, environment, and location.
- **Azure CAF alignment** – Matches Microsoft Cloud Adoption Framework recommendations.
- **Self‑documenting** – All identities (users, groups, SPNs) include a mandatory **Description** field explaining purpose.

---

## 2. Resource Naming Patterns

| Resource Type | Pattern | Example | Notes |
|---------------|---------|---------|-------|
| **Management Group** | `mg-<purpose>` | `mg-platform`, `mg-landingzones`, `mg-sandbox` | Lowercase, hyphens |
| **Subscription** | `sub-<environment>-<workload>` | `sub-dev-azawslab` | Single subscription for lab |
| **Resource Group** | `rg-<environment>-<component>-<region>` | `rg-dev-networking-uksouth`, `rg-prod-identity-uksouth` | Use `dev` for Release 2 (greenfield) |
| **Virtual Network** | `vnet-<environment>-<region>-<purpose>` | `vnet-dev-uksouth-hub`, `vnet-dev-uksouth-spoke-workload` | Purpose: hub, spoke-avd, spoke-fortigate |
| **Subnet** | `snet-<purpose>` | `snet-GatewaySubnet`, `snet-AzureFirewallSubnet`, `snet-workload`, `snet-bastion`, `snet-avd-sessionhosts` | Matches Azure reserved names where required |
| **Network Interface** | `nic-<vmname>-01` | `nic-dc1-01`, `nic-avd-session-01` | |
| **Public IP** | `pip-<resource>-<region>-01` | `pip-azfw-uksouth-01`, `pip-vpngw-uksouth-01` | |
| **Network Security Group** | `nsg-<purpose>-<direction>` | `nsg-workload-inbound`, `nsg-mgmt-outbound` | Or `nsg-<vmrole>` |
| **Route Table** | `rt-<purpose>-<region>` | `rt-udr-to-firewall-uksouth` | |
| **VPN Gateway** | `vpngw-<environment>-<region>` | `vpngw-dev-uksouth` | |
| **Local Network Gateway** | `lngw-<environment>-<site>` | `lngw-dev-branch-br1` | For on‑prem simulation |
| **Azure Firewall** | `afw-<environment>-<region>-01` | `afw-dev-uksouth-01` | |
| **Firewall Policy** | `afwp-<environment>-<region>` | `afwp-dev-uksouth` | |
| **Key Vault** | `kv-<environment>-<purpose>-<suffix>` | `kv-dev-platform-001` | Suffix = 3-digit random or sequential |
| **Log Analytics Workspace** | `la-<environment>-<purpose>` | `la-dev-platform` | |
| **Storage Account** | `st<env><purpose><unique>` | `stdefterraform001`, `stdevdiaglogs001` | No hyphens, max 24 chars, lowercase |
| **Recovery Services Vault** | `rsv-<environment>-<purpose>` | `rsv-dev-backup`, `rsv-dev-asr` | For Backup + ASR |
| **Automation Account** | `aa-<environment>-<region>` | `aa-dev-uksouth` | |
| **Virtual Machine** | `vm-<environment>-<role>-<number>` | `vm-dev-dc1-01`, `vm-dev-avdsession-01`, `vm-dev-client-01` | Role: dc, avdsession, client, bastion |
| **Availability Set** | `aset-<environment>-<role>` | `aset-dev-avdsession` | |
| **Disk** | `disk-<vmname>-os|data-01` | `disk-dc1-os-01`, `disk-avdsession-data-01` | |
| **Azure Policy Definition** | `policy-<shortname>` | `policy-allowed-locations` | |
| **Policy Assignment** | `polassign-<purpose>-<scope>` | `polassign-allowed-locations-mg` | |
| **Role Assignment** | `role-<principal>-<scope>-<suffix>` | `role-terraform-sp-contributor-rg` | |
| **Sentinel Workbook** | `workbook-<purpose>` | `workbook-azure-activity` | Use built-in name or custom |
| **Analytic Rule** | `rule-<detection-name>` | `rule-multiple-failed-signins` | |
| **Data Connector** | `connector-<source>` | `connector-azure-activity` | |
| **Azure Monitor Alert** | `alert-<condition>-<resource>` | `alert-high-cpu-vm-dev-dc1` | |
| **Action Group** | `ag-<environment>-<type>` | `ag-dev-email` | |
| **Private DNS Zone** | `privatelink.<service>.azure.com` | `privatelink.blob.core.windows.net` | Fixed name for Private Link |
| **Azure Arc Machine** | Use existing VM name (e.g., `vm-dev-dc1-01`) | | No separate naming needed |
| **FortiGate NVA** | `vm-dev-fortigate-01` | | Follow VM naming |
| **AVD Host Pool** | `hp-<environment>-<pooltype>` | `hp-dev-pooled` | |
| **AVD Application Group** | `dag-<environment>-<type>` | `dag-dev-desktop` | |
| **AVD Workspace** | `ws-<environment>-<region>` | `ws-dev-uksouth` | |

---

## 3. Environment Tags

Every resource must have these tags (apply at resource group or resource level):

| Tag Key | Example Value | Description |
|---------|---------------|-------------|
| `Environment` | `Development`, `Test`, `Production` | Use `Development` for Release 2 |
| `Project` | `Azawslab-Release2` | Fixed for all Release 2 resources |
| `Owner` | `YourName` or `AzureLab` | Your identifier |
| `CostCenter` | `Lab-123` | Optional but recommended |
| `AutoShutdown` | `True` | For VMs that should be auto-shutdown |
| `DeploymentMethod` | `Terraform` | All resources must be IaC |

---

## 4. User, Group & Service Principal Naming (with Descriptions)

**All identity objects must have a non‑empty `Description` field** that clearly explains purpose, scope, and any caveats.

### Users (Main Tenant)

| Type | Naming Pattern | Example | Mandatory Description Example |
|------|----------------|---------|-------------------------------|
| Primary admin | `admin-<name>` | `admin-rik` | `"Primary Global Administrator for Release 2 – used for all configuration and validation."` |
| Break‑glass admin | `bg-admin-<name>` | `bg-admin-emergency` | `"Emergency cloud‑only Global Administrator with FIDO2 MFA – stored in secure password manager. Used if primary admin inaccessible."` |
| Test user (general) | `test-<purpose>` | `test-rdp`, `test-sentinel`, `test-avd` | `"Test user for RDP connectivity validation. Member of azw-Test-Users group."` |
| Test user (privileged role) | `test-<role>-admin` | `test-netadmin`, `test-secadmin` | `"Test user to validate Network Contributor role assignment on hub‑spoke resources."` |
| Service account (legacy) | `svc-<tool>` | `svc-terraform` | `"Legacy service account for Terraform – prefer service principal sp-terraform-gh instead."` |

### Users (Customer Tenant – for Phase P4 Lighthouse)

| Type | Naming Pattern | Example | Mandatory Description Example |
|------|----------------|---------|-------------------------------|
| Customer admin | `cust-admin-<name>` | `cust-admin-rik` | `"Admin account in customer tenant used to accept Lighthouse delegation and verify cross‑tenant management."` |
| Customer reader | `cust-reader-<name>` | `cust-reader-audit` | `"Test user to validate read‑only delegated permissions from provider tenant."` |

### Groups (Main Tenant)

All groups must include a **Description** in Microsoft Entra ID.

| Group Name | Members | Mandatory Description |
|------------|---------|-----------------------|
| `azw-Platform-Admins` | `admin-rik`, `bg-admin-emergency` | `"Platform Administrators – full access to management groups, policies, networking, firewall, Key Vault, and Sentinel."` |
| `azw-Network-Operators` | `test-netadmin` | `"Network Operators – Network Contributor role on hub and spoke VNets, NSGs, UDRs, VPN Gateway, and Azure Firewall."` |
| `azw-Security-Engineers` | `test-secadmin`, `admin-rik` | `"Security Engineers – Security Reader, Key Vault Reader, Sentinel Contributor, Defender for Cloud access."` |
| `azw-Test-Users` | `test-rdp`, `test-sentinel`, `test-avd` | `"Test users for Conditional Access policies, AVD assignment, GSA testing, and validation."` |

### Service Principals (Machine Identities)

| Name | Purpose | Mandatory Description |
|------|---------|------------------------|
| `sp-terraform-gh` | GitHub Actions for Terraform | `"Service principal used by GitHub Actions to deploy infrastructure via Terraform. Contributor on dev subscription."` |
| `sp-ansible` | Ansible automation | `"Service principal for Ansible to configure VMs (domain join, IIS, security baseline). Can reuse sp-terraform-gh if permissions suffice."` |
| `sp-lighthouse-customer` | Optional cross‑tenant automation | `"Service principal in customer tenant for automated delegated actions (e.g., inventory collection)."` |

---

## 5. Domain & DNS Suffixes

| Component | DNS Suffix | Used For |
|-----------|------------|----------|
| Corporate HQ Active Directory | `hq.azawslab.co.uk` | Primary AD forest, writeable DCs |
| Branch RODC site (Phase P5 / optional) | `br1.azawslab.co.uk` | Branch office namespace (optional suffix for client DNS) |
| Entra ID tenant | `entra.azawslab.co.uk` | Cloud identity (verified custom domain) |
| Azure VM default DNS | `*.cloudapp.azure.com` | No need to customise; use internal DNS |

**UPN transformation:** On‑prem users have UPN `user@hq.azawslab.co.uk` (or `user@br1.azawslab.co.uk`). Entra Connect transforms to `user@entra.azawslab.co.uk` during sync.

---

## 6. VNet Peering & BGP – Coverage in Phases

- **VNet peering (Phase P5 – core):**  
  Hub (`vnet-dev-uksouth-hub`) peers with each spoke (e.g., `vnet-dev-uksouth-spoke-workload`).  
  Peering is bidirectional. Gateway transit is **not** enabled by default (optional, not required for core).

- **BGP over VPN Gateway (Phase P12 – optional):**  
  Enabled on VPN Gateway (`vpngw-dev-uksouth`) via `--enable-bgp`.  
  Peer ASN = 65001 (simulated on‑prem router).  
  Verify with `az network vnet-gateway list-bgp-peer-status`.  
  Azure will learn on‑prem routes (e.g., `192.168.0.0/16`) and propagate to peered spokes if gateway transit is configured.

---

## 7. Phase‑Specific Naming Examples (P1 – P16)

| Phase | Resource Type | Example Name(s) |
|-------|---------------|------------------|
| **P1** | Management Group | `mg-platform`, `mg-landingzones`, `mg-sandbox` |
| **P1** | Subscription | `sub-dev-azawslab` |
| **P2a** | Resource Group (networking) | `rg-dev-networking-uksouth` |
| **P2a** | Hub VNet | `vnet-dev-uksouth-hub` |
| **P2a** | Spoke VNet (workload) | `vnet-dev-uksouth-spoke-workload` |
| **P2a** | Key Vault | `kv-dev-platform-001` |
| **P2a** | Log Analytics | `la-dev-platform` |
| **P2b** | VM (DC1) | `vm-dev-dc1-01` |
| **P2b** | VM (Client for testing) | `vm-dev-client-01` |
| **P2c** | GitHub Actions environment | `release-2` (branch name) |
| **P3** | Policy assignment | `polassign-allowed-locations-mg` |
| **P3** | RBAC assignment example | `role-terraform-sp-contributor-rg` |
| **P4** | Lighthouse ARM template | `lighthouse-customer-delegation.json` |
| **P5** | Route table (UDR) | `rt-udr-to-firewall-uksouth` |
| **P5** | NSG (workload spoke) | `nsg-workload-inbound` |
| **P6** | Azure Firewall | `afw-dev-uksouth-01` |
| **P6** | Firewall policy | `afwp-dev-uksouth` |
| **P7** | Defender plan | Enable on subscription, no name needed |
| **P8** | Analytic rule | `rule-multiple-failed-signins` |
| **P8** | Workbook | `workbook-azure-activity` |
| **P9a** | Alert rule | `alert-high-cpu-vm-dev-dc1` |
| **P9b** | Recovery Services Vault (Backup) | `rsv-dev-backup` |
| **P9b** | Recovery Services Vault (ASR) | `rsv-dev-asr` |
| **P9c** | Onboarding doc | `docs/onboarding.md` |
| **P10** (FortiGate NVA) | FortiGate VM | `vm-dev-fortigate-01` |
| **P10** | FortiGate NSG | `nsg-fortigate-inbound` |
| **P11** (Azure Arc) | Arc‑enabled VM | Use same VM name, e.g., `vm-dev-dc1-01` (Arc-enabled) |
| **P12** (BGP) | BGP VPN Gateway | `vpngw-dev-uksouth` (with BGP enabled) |
| **P13** (GSA Private Access) | GSA Private Network Connector VM | `vm-dev-gsa-connector-01` |
| **P14** (GSA Internet Access) | GSA Internet Access policy | `gsa-tenant-restrictions-prod` (in Entra admin centre) |
| **P15** (GSA Advanced Patterns) | Design documents | `docs/gsa-compliance-routing.md`, `docs/gsa-universal-ca.md` |
| **P16** (AVD) | AVD Host Pool | `hp-dev-pooled` |
| **P16** | AVD Session Host VM | `vm-dev-avdsession-01`, `vm-dev-avdsession-02` |
| **P16** | FSLogix storage account | `stdevfslogix001` |

---

## 8. Exceptions & Special Cases

- **Azure built‑in subnets:** `GatewaySubnet`, `AzureFirewallSubnet`, `AzureBastionSubnet` – must use exact names.
- **Private DNS zones:** Must match the exact service FQDN (e.g., `privatelink.blob.core.windows.net`).
- **Storage account names:** Only lowercase letters and numbers, 3‑24 characters. Use prefix `st`, environment, purpose, and a short unique suffix (e.g., `stdevterraform001`).
- **Management Group names:** No spaces, hyphens allowed. Must be unique across tenant.
- **Tags:** Always include `Environment=Development`, `Project=Azawslab-Release2`.

---

## 9. Enforcement & Review

- All Terraform modules must accept `name` and `tags` variables – no hardcoded names.
- Pull requests must include a description of naming conformance.
- Evidence screenshots should clearly show resource names matching these conventions.
- **Identity objects (users, groups, SPNs) must include the Description field** as shown in Section 4.

---

**End of Document – Use this as the authoritative naming reference for all Release 2 implementations (P1–P16).**
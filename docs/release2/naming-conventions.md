# Release 2 Naming Conventions

**Version:** 5.0  
**Last Updated:** [Current Date]  
**Aligns with:** `README_PLAN.md`  
**Applies to:** All Release 2 phases (`P0â€“P9c`, `O1â€“O5`)  
**Related Docs:** [Architecture Decision Records](./architechture.md), [Master Plan](./README_PLAN.md), [Implementation Tracker](./implementation-tracker.md), [Phase Guide](./Phases-with-steps.md)

---

## 1. Purpose

This document defines the naming rules for all Release 2 resources, identities, files, evidence outputs, and automation artifacts.

The goals are:
- consistent naming across the entire repo and Azure environment
- quick operator recognition during build and troubleshooting
- alignment with Azure CAF-style conventions where practical
- compatibility with Terraform, Azure CLI, GitHub Actions, and evidence capture workflows
- explicit support for the revised hybrid routing design using **VyOS**, not RRAS

If this document conflicts with `README_PLAN.md`, follow `README_PLAN.md` and then update this file.

---

## 2. Naming Principles

### 2.1 Consistency
Use the same pattern for the same resource type across every phase.

### 2.2 Readability
Names should reveal:
- purpose
- environment
- region
- sequence number where needed

### 2.3 Azure Compatibility
Respect Azure naming constraints:
- storage accounts must be lowercase, no hyphens, max 24 chars
- some subnet names are reserved and must match exactly
- some service names must remain globally unique

### 2.4 Operational Clarity
Names should make troubleshooting easy from:
- Azure CLI output
- Terraform plans
- GitHub workflow logs
- evidence files

### 2.5 Lifecycle Awareness
Ephemeral resources use the same standard naming format as persistent resources, but must also be tagged and tracked clearly for teardown.

---

## 3. Environment and Scope Model

> **Deployability-validated naming note:** Region and compute SKU values are finalized only after subscription-level availability validation, then naming is aligned to the confirmed implementation target.

Release 2 uses a **single primary lab environment** with naming that still reflects production-style structure.

### Standard Values
- **Environment token:** `dev`
- **Region token:** `norwayeast`
- **Management-plane region token:** `global`
- **Subscription environment token:** `prod` where the design intentionally mirrors enterprise structure
- **Project identifier:** `Azawslab-Release2`

### Notes
- Resource names may contain both `dev` and `prod` depending on the object type and inherited design model.
- Management groups and subscription names preserve the enterprise-style patterns from the master plan.
- Workload/build resources should remain internally consistent with the examples in this document.

---

## 4. Core Resource Naming Patterns

| Resource Type | Pattern | Example | Notes |
|---|---|---|---|
| Management Group | `mg-<purpose>-<env>-<region>` | `mg-platform-prod-global` | Management plane uses `global` |
| Subscription | `sub-<workload>-<env>` or `sub-<workload>-<env>-<region>` | `sub-azaws-enterprise-prod` | Use actual subscription name chosen in lab |
| Resource Group | `rg-<service>-<env>-<region>` | `rg-dev-workload-norwayeast` | Use logical service boundary |
| Virtual Network | `vnet-<env>-<region>-<purpose>` | `vnet-dev-norwayeast-spoke-workload` | Purpose examples: `hub`, `spoke-workload`, `spoke-avd` |
| Subnet | `snet-<purpose>` | `snet-workload` | Reserved names must match exactly where required |
| Network Interface | `nic-<vmname>-<nn>` | `nic-vm-dev-client-01-01` | Keep sequence for multi-NIC scenarios |
| Public IP | `pip-<resource>-<region>-<nn>` | `pip-azfw-norwayeast-01` | Only where public IP is required |
| NSG | `nsg-<purpose>-<direction>` | `nsg-workload-inbound` | Purpose-driven |
| Route Table | `rt-<purpose>-<region>` | `rt-udr-to-firewall-norwayeast` | For forced tunneling / steering |
| VPN Gateway | `vpngw-<env>-<region>` | `vpngw-dev-norwayeast` | Use only if phase requires it |
| Local Network Gateway | `lngw-<env>-<site>` | `lngw-dev-hq` | HQ, branch, AWS, etc. |
| Azure Firewall | `afw-<env>-<region>-<nn>` | `afw-dev-norwayeast-01` | Often ephemeral |
| Firewall Policy | `afwp-<env>-<region>` | `afwp-dev-norwayeast` | Paired with Azure Firewall |
| FortiGate NVA VM | `vm-<env>-fortigate-<nn>` | `vm-dev-fortigate-01` | Ephemeral for validation unless retained |
| Key Vault | `kv-<env>-<purpose>-<suffix>` | `kv-dev-platform-001` | Suffix should be numeric or random |
| Log Analytics Workspace | `la-<env>-<purpose>` | `la-dev-platform` | Shared monitoring target |
| Storage Account (Terraform state) | `st<env><service><unique>` | `stdevterraform001` | Lowercase only, no hyphens |
| Storage Account (FSLogix) | `st<env>fslogix<unique>` | `stdevfslogix001` | Premium as required by design |
| Recovery Services Vault | `rsv-<env>-<purpose>` | `rsv-dev-backup` | Backup / DR scope |
| Resource Guard RG | `rg-<env>-resourceguard` | `rg-dev-resourceguard` | For MUA / Resource Guard design |
| Virtual Machine | `vm-<env>-<role>-<nn>` | `vm-dev-dc1-01` | Applies to Azure VMs |
| VyOS On-Prem VM | `vyos-<env>-onprem-<nn>` | `vyos-dev-onprem-01` | Standard on-prem routing platform for Release 2 |
| Availability Set | `aset-<env>-<role>` | `aset-dev-avdsession` | Use only if needed |
| Disk | `disk-<vmname>-<type>-<nn>` | `disk-vm-dev-client-01-os-01` | `os` or `data` |
| Policy Definition | `policy-<shortname>` | `policy-allowed-locations` | Short and readable |
| Policy Assignment | `polassign-<purpose>-<scope>` | `polassign-allowed-locations-mg` | Scope examples: `mg`, `sub` |
| Role Assignment Label | `role-<principal>-<role>-<scope>` | `role-sp-terraform-contributor-sub` | Documentation/logical label |
| Action Group | `ag-<env>-<type>` | `ag-dev-email` | Alert target |
| Alert Rule | `alert-<condition>-<resource>` | `alert-high-cpu-vm-dev-client-01` | Use readable condition |
| Sentinel Workbook | `workbook-<purpose>` | `workbook-azure-activity` | Built-in or custom |
| Analytic Rule | `rule-<detection-name>` | `rule-multiple-failed-signins` | Use readable detection name |
| Data Connector | `connector-<source>` | `connector-azure-activity` | Sentinel connector labels |
| Private DNS Zone | fixed provider format | `privatelink.blob.core.windows.net` | Do not modify provider-defined names |
| Azure Arc Machine | existing machine name | `vm-dev-dc1-01` | Arc projects existing machine identity |
| AVD Host Pool | `hp-<env>-<pooltype>` | `hp-dev-pooled` | `pooled`, `personal` |
| AVD App Group | `dag-<env>-<type>` | `dag-dev-desktop` | Desktop or RemoteApp |
| AVD Workspace | `ws-<env>-<region>` | `ws-dev-norwayeast` | Use region suffix |
| FSLogix Share | `share-<env>-fslogix` | `share-dev-fslogix` | Azure Files share |
| GSA Remote Network | `gsa-rn-<site>` | `gsa-rn-azurehub` | Logical object in Entra |
| GSA Connector VM | `vm-<env>-gsa-connector-<nn>` | `vm-dev-gsa-connector-01` | Connector host VM |

---

## 5. Reserved / Special Names

These must be used exactly where the Azure service requires them:

| Resource Type | Required Name |
|---|---|
| VPN gateway subnet | `GatewaySubnet` |
| Azure Firewall subnet | `AzureFirewallSubnet` |
| Azure Bastion subnet | `AzureBastionSubnet` |

When following the subnet standard, represent these as:
- `snet-GatewaySubnet`
- `snet-AzureFirewallSubnet`
- `snet-AzureBastionSubnet`

Do not rename the actual reserved subnet value inside Azure.

---

## 6. Network and Routing Naming

This section is especially important for phases `P5`, `P6`, `O1`, `O3a`, `O3b`, and `O3c`.

### 6.1 Core Network Objects

| Object | Pattern | Example |
|---|---|---|
| Hub VNet | `vnet-<env>-<region>-hub` | `vnet-dev-norwayeast-hub` |
| Workload spoke | `vnet-<env>-<region>-spoke-workload` | `vnet-dev-norwayeast-spoke-workload` |
| AVD spoke | `vnet-<env>-<region>-spoke-avd` | `vnet-dev-norwayeast-spoke-avd` |
| FortiGate segment/spoke | `vnet-<env>-<region>-spoke-fortigate` | `vnet-dev-norwayeast-spoke-fortigate` |
| Workload subnet | `snet-workload` | `snet-workload` |
| Management subnet | `snet-mgmt` | `snet-mgmt` |
| AVD subnet | `snet-avd-sessionhosts` | `snet-avd-sessionhosts` |

### 6.2 Peering Names

| Pattern | Example |
|---|---|
| `peer-<source>-to-<target>` | `peer-hub-to-workload` |
| `peer-<source>-to-<target>` | `peer-workload-to-hub` |

Keep peering names directional if Azure requires separate objects on each side.

### 6.3 BGP / Hybrid Peer Labels

Use descriptive peer labels in configuration notes, evidence, and diagrams:

| Peer Type | Name |
|---|---|
| HQ on-prem VyOS peer | `peer-hq-vyos` |
| AWS Cisco peer | `peer-aws-cisco` |
| Transit FortiGate peer label | `peer-az-fortigate` |

### 6.4 BGP ASN Reference

| Site / Device | ASN |
|---|---|
| Azure FortiGate transit hub | `65515` |
| HQ on-prem VyOS | `65001` |
| AWS Cisco branch | `65002` |

### 6.5 Advertised Prefix Labels

| Site | Prefix Example |
|---|---|
| HQ on-prem | `192.168.1.0/24` |
| AWS branch segment 1 | `172.16.1.0/24` |
| AWS branch segment 2 | `172.16.2.0/24` |

### Rule
Do **not** use RRAS-era peer labels such as `peer-hq-rras` anywhere in Release 2 documentation, config notes, or evidence files.

---

## 7. Security and Governance Naming

### 7.1 Policies

| Pattern | Example |
|---|---|
| `policy-<shortname>` | `policy-allowed-locations` |
| `policy-<shortname>` | `policy-allowed-vm-skus` |
| `policy-<shortname>` | `policy-mandatory-tags` |

### 7.2 Policy Assignments

| Pattern | Example |
|---|---|
| `polassign-<purpose>-mg` | `polassign-allowed-locations-mg` |
| `polassign-<purpose>-sub` | `polassign-allowed-skus-sub` |

### 7.3 Role Assignment Labels

These are documentation/logical naming conventions for evidence, scripts, and notes.

| Pattern | Example |
|---|---|
| `role-<principal>-<role>-<scope>` | `role-sp-terraform-contributor-sub` |
| `role-<principal>-<role>-<scope>` | `role-azw-platformadmins-reader-mg` |

---

## 8. Identity Naming Standards

All identity objects must have clear and non-empty descriptions.

### 8.1 Users

| Pattern | Example | Notes |
|---|---|---|
| `<firstname>.<lastname>` | `admin.lab` | Use lab-safe identities |
| UPN suffix (HQ AD) | `user@hq.azawslab.co.uk` | On-prem identities |
| UPN suffix (Entra) | `user@entra.azawslab.co.uk` | Cloud identities |

### 8.2 Groups

| Pattern | Example |
|---|---|
| `azw-<scope>-<role>` | `azw-platform-admins` |
| `azw-<service>-<access>` | `azw-sentinel-readers` |

### 8.3 App Registrations / Service Principals

| Pattern | Example |
|---|---|
| `sp-<purpose>-<platform>` | `sp-terraform-gh` |
| `sp-<purpose>-<platform>` | `sp-monitoring-automation` |

### 8.4 Mandatory Description Standard

Every identity object should include a description stating:
- purpose
- scope
- whether it is human or workload identity
- whether it is temporary or persistent

**Example description:**
> GitHub Actions workload identity for Release 2 Terraform deployment to Azure subscription using OIDC federation.

---

## 9. VM and Role Naming Standards

Use the VM pattern:
`vm-<env>-<role>-<nn>`

### Standard Role Examples

| Role | Example |
|---|---|
| Domain controller | `vm-dev-dc1-01` |
| Client | `vm-dev-client-01` |
| Session host | `vm-dev-avd-session-01` |
| FortiGate | `vm-dev-fortigate-01` |
| GSA connector | `vm-dev-gsa-connector-01` |

### On-Prem Platform Example
| Device | Example |
|---|---|
| VyOS | `vyos-dev-onprem-01` |

Use consistent role tokens. Prefer:
- `dc1`
- `client`
- `fortigate`
- `avd-session`
- `gsa-connector`

Avoid ad hoc role values unless the master plan explicitly introduces a new role.

---

## 10. Phase-Specific Naming Examples

### P0 â€“ Foundation
- `sp-terraform-gh`
- `rg-dev-terraformstate-norwayeast`
- `stdevterraform001`
- `tfstate`

### P1 / P3 â€“ Governance
- `mg-platform-prod-global`
- `mg-landingzones-prod-global`
- `mg-sandbox-prod-global`
- `policy-allowed-locations`
- `policy-allowed-vm-skus`
- `policy-mandatory-tags`

### P5 – Hub-Spoke Networking
- `vnet-dev-norwayeast-hub`
- `vnet-dev-norwayeast-spoke-workload`
- `snet-workload`
- `snet-mgmt`
- `rt-udr-to-firewall-norwayeast`

### P6 â€“ Azure Firewall
- `afw-dev-norwayeast-01`
- `afwp-dev-norwayeast`
- `pip-azfw-norwayeast-01`

### O1 â€“ FortiGate
- `vm-dev-fortigate-01`
- `pip-fortigate-norwayeast-01`
- `rt-udr-to-fortigate-norwayeast`

### O3a â€“ FortiGate â†” VyOS
- `vm-dev-fortigate-01`
- `vyos-dev-onprem-01`
- `peer-hq-vyos`
- `lngw-dev-hq`

### O3b â€“ AWS Branch
- `peer-aws-cisco`
- `cisco-dev-branch-01`

### O5 â€“ AVD
- `hp-dev-pooled`
- `dag-dev-desktop`
- `ws-dev-norwayeast`
- `stdevfslogix001`
- `share-dev-fslogix`

---

## 11. Repository and File Naming Standards

### 11.1 Core Documentation Files

Use these exact canonical file names for Release 2 support docs:

| File Purpose | Canonical Name |
|---|---|
| Master plan | `README_PLAN.md` |
| Implementation tracker | `implementation-tracker.md` |
| Phase execution guide | `Phases-with-steps.md` |
| Naming conventions | `naming-conventions.md` |
| Architecture decisions | `architechture.md` |
| Build checklist | `build_checklist.md` |

### 11.2 Terraform Files

| Pattern | Example |
|---|---|
| `main.tf` | root or module entry file |
| `variables.tf` | input variable definitions |
| `outputs.tf` | outputs |
| `providers.tf` | provider configuration |
| `backend.tf` | backend configuration |
| `policies.tf` | governance resources |
| `networking.tf` | VNet / subnet / peering resources |

### 11.3 Ansible Files

| Pattern | Example |
|---|---|
| `site.yml` | main playbook |
| `hosts.yml` | inventory file |
| `main.yml` | role task entrypoint |
| `group_vars/<group>.yml` | group variables |
| `host_vars/<host>.yml` | host variables |

### 11.4 GitHub Workflow Files

| Pattern | Example |
|---|---|
| `oidc-test.yml` | OIDC handshake test |
| `tf-ci.yml` | Terraform plan/validate pipeline |
| `tf-cd.yml` | Terraform apply pipeline |

### Rule
Do not reference `README_PLAN_Revised.md` anywhere in Release 2 files. The canonical source-of-truth filename is `README_PLAN.md`.

---

## 12. Evidence File Naming Standards

Release 2 is CLI-first. Evidence file names should be predictable and phase-scoped.

### 12.1 Evidence Directory Pattern
`docs/release2/evidence/<Phase>/`

### 12.2 Evidence File Pattern
`<topic>.txt`, `<topic>.md`, or `<topic>.png`

Prefer text-first naming.

### Examples by Phase

| Phase | Example Evidence Files |
|---|---|
| P0 | `oidc-test.txt`, `backend-init.txt`, `role-assignment.txt` |
| P1 | `mg-hierarchy.txt`, `policy-assignments.txt`, `deny-test-region.txt` |
| P2a | `tf-validate.txt`, `tf-plan.txt`, `vm-networkprofile.txt` |
| P2b | `ansible-lint.txt`, `ansible-run-01.txt`, `ansible-run-02-idempotent.txt` |
| P2c | `oidc-workflow-run.txt`, `terraform-plan-pr-comment.txt`, `terraform-apply-run.txt` |
| P3 | `policy-state.txt`, `deny-test-sku.txt`, `rbac-assignments.txt` |
| P5 | `vnet-list.txt`, `vnet-peering.txt`, `route-table-validation.txt` |
| P6 | `firewall-deploy.txt`, `blocked-request-test.txt`, `firewall-log-query.txt` |
| O3a | `ipsec-status.txt`, `bgp-summary-vyos.txt`, `route-table-validation.txt` |
| O3c | `transit-route-summary.txt`, `path-validation.txt`, `packet-path-notes.md` |
| O5 | `host-pool-status.txt`, `fslogix-validation.txt`, `session-validation.txt` |

### Evidence Rules
- Prefer `.txt` or `.md` over screenshots where possible
- Keep names short and readable
- Avoid spaces in filenames
- Use phase folders consistently
- If a screenshot is required, use descriptive names such as `branch-protection-view.png`

---

## 13. Tagging Standards

Every Azure resource should include these baseline tags unless technically unsupported:

| Tag Key | Example Value | Notes |
|---|---|---|
| `Environment` | `Development` | Standard for Release 2 |
| `Project` | `Azawslab-Release2` | Fixed project tag |
| `Owner` | `YourName` or `AzureLab` | Operator identity |
| `CostCenter` | `Lab-123` | Optional but recommended |
| `Ephemeral` | `true` | Set for teardown-bound resources |
| `DeploymentMethod` | `Terraform` | Default for IaC-managed resources |
| `AutoShutdown` | `true` | Use for eligible VMs |

### Tag Rule
If a resource is intended for teardown after validation, the `Ephemeral=true` tag should be present where supported.

---

## 14. Naming Anti-Patterns to Avoid

Do not use:
- inconsistent region tokens such as mixing outdated and finalized region tokens such as `uksouth`, `norwayeast`, and ad hoc abbreviations
- stale RRAS-era names such as `peer-hq-rras`
- vague names such as `vm-test`, `rg-temp`, `net1`
- mixed sequence styles such as `01`, `1`, `001` on the same resource family without reason
- spaces in filenames
- portal-generated defaults when a controlled name can be supplied

### Bad vs Good Examples

| Bad | Good |
|---|---|
| `peer-hq-rras` | `peer-hq-vyos` |
| `vm-test` | `vm-dev-client-01` |
| `rg-temp` | `rg-dev-workload-norwayeast` |
| `storage1` | `stdevterraform001` |
| `firewallpolicy` | `afwp-dev-norwayeast` |

---

## 15. Quick Reference Summary

### Core Examples
- `mg-platform-prod-global`
- `sub-azaws-enterprise-prod`
- `rg-dev-workload-norwayeast`
- `vnet-dev-norwayeast-hub`
- `vnet-dev-norwayeast-spoke-workload`
- `afw-dev-norwayeast-01`
- `afwp-dev-norwayeast`
- `vm-dev-fortigate-01`
- `vyos-dev-onprem-01`
- `kv-dev-platform-001`
- `la-dev-platform`
- `sp-terraform-gh`
- `peer-hq-vyos`
- `peer-aws-cisco`
- `hp-dev-pooled`
- `ws-dev-norwayeast`

---

## 16. Final Consistency Check

Before considering naming complete, confirm:

- [ ] all Release 2 docs reference `README_PLAN.md`
- [ ] no Release 2 doc uses `peer-hq-rras`
- [ ] all O3a references use **VyOS**
- [ ] file paths in `README.md` match actual filenames
- [ ] evidence filenames follow the phase folder structure
- [ ] resource examples remain aligned with the master plan

---

## 17. Maintenance Rule

Whenever you introduce:
- a new Azure resource type
- a new hybrid component
- a new optional phase
- a renamed support file












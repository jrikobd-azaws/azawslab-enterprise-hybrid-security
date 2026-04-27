## Phase 1 – Azure Landing Zone Foundation

| Step | Action | Portal / CLI | Evidence |
|------|--------|--------------|----------|
| 1 | Create management groups: `mg-platform`, `mg-landingzones`, `mg-sandbox` under Tenant Root Group | Portal → Management Groups → + Create | Screenshot of hierarchy |
| 2 | Move your subscription under `mg-landingzones` | Portal → Management Groups → select MG → + Add subscription | Screenshot showing subscription in MG |
| 3 | Define naming convention: create `docs/release2/naming-conventions.md` with patterns for RGs, VNets, subnets, Key Vault, etc. | Local / GitHub editor | File committed |
| 4 | Define tag model: create `docs/release2/tag-model.md` with keys `Environment`, `Project`, `Owner`, `CostCenter` | Local / GitHub editor | File committed |
| 5 | Validate: `az account management-group list --expand` | Azure CLI | Terminal output screenshot |

---

## Phase 2a – Terraform Reusable Modules

| Step | Action | Portal / CLI | Evidence |
|------|--------|--------------|----------|
| 1 | Create folder `terraform/modules/{networking,security,compute,monitoring}` | GitHub / VS Code | Folder structure screenshot |
| 2 | Write `networking` module (VNet + subnets) with variables, outputs, README | Code editor | Module files committed |
| 3 | Write `security` module (Key Vault) | Code editor | Module files committed |
| 4 | Write `compute` module (Windows VM with private IP only – no public IP) | Code editor | Module files committed |
| 5 | Write `monitoring` module (Log Analytics workspace) | Code editor | Module files committed |
| 6 | Create `environments/dev/main.tf` that calls modules with specific names (e.g., `vnet-dev-uksouth-hub`) | Code editor | Root config committed |
| 7 | Run `terraform init`, `terraform validate`, `terraform plan` | CLI (Codespaces or local) | Screenshot of `terraform plan` output |

---

## Phase 2b – Ansible Configuration Management

| Step | Action | Portal / CLI | Evidence |
|------|--------|--------------|----------|
| 1 | Create folder `ansible/playbooks/` and `ansible/roles/` structure | GitHub / VS Code | Folder structure screenshot |
| 2 | Create `ansible/inventory.yml` with `ansible_ssh_common_args` to proxy through Bastion (once Bastion is deployed) | Code editor | Inventory file committed |
| 3 | Write role `common` (disable SMBv1, enable Defender) | Code editor | Role YAML files committed |
| 4 | Write role `ad-join` (domain join to `hq.azawslab.co.uk`) | Code editor | Role YAML files committed |
| 5 | Write role `webserver` (install IIS) | Code editor | Role YAML files committed |
| 6 | Create `site.yml` that imports all three roles | Code editor | Site.yml committed |
| 7 | (After a Windows VM is deployed via Terraform) Run `ansible-lint site.yml`, then `ansible-playbook -i inventory.yml site.yml --ask-vault-pass` | CLI | Playbook output + VM in AD screenshot + IIS welcome page |

---

## Phase 2c – CI/CD Pipeline (GitHub Actions)

| Step | Action | Portal / CLI | Evidence |
|------|--------|--------------|----------|
| 1 | Create `.github/workflows/terraform-ci.yml` using OIDC (federated credentials) | Code editor | Workflow file committed |
| 2 | Add GitHub secrets: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID` | GitHub Repo → Settings → Secrets | Screenshot of secrets (values hidden) |
| 3 | Create a pull request changing a variable in `environments/dev/main.tf` | GitHub Web UI | Screenshot of PR with Terraform plan comment |
| 4 | Merge the PR – trigger `terraform apply` | GitHub | Screenshot of green Actions run |
| 5 | Verify resource created in Azure Portal | Azure Portal | Screenshot of resource |

---

## Phase 3 – Governance (Azure Policy, RBAC, Key Vault)

| Step | Action | Portal / CLI / Terraform | Evidence |
|------|--------|--------------------------|----------|
| 1 | Create custom policy definition for allowed locations (e.g., `uksouth`, `westeurope`) | Terraform: `azurerm_policy_definition` | Policy definition committed |
| 2 | Assign the allowed locations policy to `mg-landingzones` | Terraform: `azurerm_subscription_policy_assignment` | Screenshot of policy assignment in portal |
| 3 | Create policy for required tags (Environment, Project, Owner, CostCenter) | Terraform: `azurerm_policy_definition` + assignment | Policy JSON committed |
| 4 | Verify: attempt to create a resource without required tags or in wrong region → fails | Azure CLI or Portal | Screenshot of error / denied |
| 5 | Create RBAC role assignment: give `sp-terraform-gh` Contributor on the subscription | Terraform: `azurerm_role_assignment` | Screenshot of IAM + role assignment |
| 6 | Create RBAC role assignment: give `azw-Security-Engineers` group Reader on the subscription (optional) | Terraform or Portal | Screenshot showing group membership |
| 7 | Deploy Key Vault (`kv-dev-platform-001`) using Terraform `security` module | Terraform | Screenshot of Key Vault in portal |
| 8 | Store a dummy secret (e.g., `dummy-password`) using `azurerm_key_vault_secret` | Terraform | Screenshot of secret in portal (value hidden) |
| 9 | Retrieve the secret via CLI: `az keyvault secret show --name dummy-password --vault-name kv-dev-platform-001` | Azure CLI | Terminal output screenshot |
| 10 | (Optional) Add `lifecycle { prevent_destroy = true }` to Key Vault | Terraform | Documented in code |

---

## Phase 4 – Azure Lighthouse (Cross‑Tenant Delegated Administration)

| Step | Action | Portal / CLI / ARM | Evidence |
|------|--------|--------------------|----------|
| 1 | Create a second Entra ID tenant (free) – this will be your “customer” tenant | [Entra admin center](https://entra.microsoft.com) → Create tenant | Screenshot of tenant creation |
| 2 | In the customer tenant, create a subscription (free trial or PAYG) or use an existing empty subscription | Azure Portal (customer tenant) | Screenshot of subscription |
| 3 | Prepare an ARM template (or Terraform) that defines Lighthouse delegation from your main (provider) tenant | Code editor | Template file committed |
| 4 | The template must include: `managedByTenantId` (your main tenant ID), `authorizations` with principalId and roleDefinitionId (e.g., Contributor) | Code editor | Template JSON |
| 5 | Deploy the Lighthouse template to the **customer subscription** (via Azure CLI or Portal) | `az deployment sub create --location uksouth --template-file lighthouse.json` | CLI output screenshot |
| 6 | In your main tenant, go to **Azure Lighthouse** → **My Customers** | Azure Portal (main tenant) | Screenshot showing the delegated customer subscription |
| 7 | Perform a delegated management action from your main tenant, e.g., list VMs in the customer subscription using `az vm list --subscription <customer-sub-id>` | Azure CLI | Terminal output screenshot |
| 8 | (Optional) In the customer tenant, verify the delegation entry under **Azure Lighthouse** → **Service providers** | Azure Portal (customer tenant) | Screenshot |
| 9 | Capture evidence: `evidence/P4/portal-my-customers.png`, `evidence/P4/cli-cross-tenant-vms.png`, `evidence/P4/lighthouse-template.json` | – | Files and screenshots |

**Time estimate for all four phases:** Phase 1 (0.5h), Phase 2 (6‑8h), Phase 3 (2‑3h), Phase 4 (1.5h) – **Total ~10‑13 hours**

## Phase 5 – Hub‑Spoke Networking + Automation

| Step | Action | Portal / CLI / Terraform | Evidence |
|------|--------|--------------------------|----------|
| 1 | Create Hub VNet (`vnet-dev-uksouth-hub`, 10.0.0.0/16) with subnets: `GatewaySubnet`, `AzureFirewallSubnet`, `Mgmt`, and `AzureBastionSubnet` | Terraform (networking module) | Screenshot of Hub VNet + subnets |
| 2 | Create Spoke VNet (`vnet-dev-uksouth-spoke-workload`, 10.1.0.0/16) with subnet `Workload` | Terraform (networking module) | Screenshot of Spoke VNet |
| 3 | Create bidirectional VNet peering between Hub and Spoke | Terraform: `azurerm_virtual_network_peering` | Screenshot of peering status (Connected) |
| 4 | Create Route Table (`rt-udr-to-firewall-uksouth`) with default route (0.0.0.0/0) pointing to Azure Firewall private IP (placeholder 10.0.2.4) | Terraform: `azurerm_route_table` + `azurerm_route` | Screenshot of route table routes |
| 5 | Associate the route table to the Spoke’s `Workload` subnet | Terraform: `azurerm_subnet_route_table_association` | CLI: `az network route-table show` |
| 6 | Create Network Security Group (`nsg-workload-inbound`) with rule allowing RDP only from `Mgmt` subnet (10.0.3.0/24) | Terraform: `azurerm_network_security_group` + `azurerm_network_security_rule` | Screenshot of NSG inbound rules |
| 7 | Associate NSG to the Spoke’s `Workload` subnet | Terraform: `azurerm_subnet_network_security_group_association` | Screenshot of subnet associations |
| 8 | Deploy test VMs: one in Hub `Mgmt` subnet (jump host), one in Spoke `Workload` subnet (private, no public IP) | Terraform (compute module) | Screenshot of VMs with private IPs only |
| 9 | Validate: Ping from Hub VM to Spoke VM (should succeed), RDP from internet to Spoke VM (should fail), RDP from Hub VM to Spoke VM (should succeed) | CLI / RDP client | Screenshot of ping success + RDP failure |

---

## Phase 6 – Azure Firewall

| Step | Action | Portal / CLI / Terraform | Evidence |
|------|--------|--------------------------|----------|
| 1 | Deploy Azure Firewall (`afw-dev-uksouth-01`) in `AzureFirewallSubnet` with standard public IP | Terraform: `azurerm_firewall` + `azurerm_public_ip` | Screenshot of Firewall overview |
| 2 | Create Firewall Policy (`afwp-dev-uksouth`) | Terraform: `azurerm_firewall_policy` | Screenshot of policy |
| 3 | Add network rule collection: allow DNS (UDP/53) to 8.8.8.8, 8.8.4.4 | Terraform: `azurerm_firewall_policy_rule_collection_group` | Screenshot of network rules |
| 4 | Add application rule collection: allow HTTPS to `*.microsoft.com`, `*.azure.com` | Terraform (as above) | Screenshot of application rules |
| 5 | Enable diagnostic settings to send Firewall logs to Log Analytics workspace | Terraform: `azurerm_monitor_diagnostic_setting` | Screenshot of diagnostic settings |
| 6 | Update the UDR’s next hop IP to the actual private IP of the Firewall (retrieved via `azurerm_firewall.main.ip_configuration[0].private_ip_address`) | Terraform (depends on firewall) | CLI: `az network firewall show` |
| 7 | From Spoke test VM: `nslookup google.com` (allowed), `curl http://example.com` (blocked) | CLI on Spoke VM (via Bastion) | Screenshot of curl error + firewall logs |
| 8 | Query Log Analytics: `AzureDiagnostics | where Category == "AzureFirewallNetworkRule" | take 10` | Log Analytics | Screenshot of KQL results showing blocked traffic |

---

## Phase 7 – Defender for Cloud

| Step | Action | Portal / CLI / Terraform | Evidence |
|------|--------|--------------------------|----------|
| 1 | Enable Microsoft Defender for Cloud on the subscription (free CSPM features) | Portal: Defender for Cloud → Environment settings → Enable | Screenshot of enabled status |
| 2 | Enable one Defender plan (e.g., `Servers P1` or `Key Vault`) – use free trial if available | Portal: Defender plans → toggle On | Screenshot of enabled plan |
| 3 | Note the initial Secure Score | Portal: Defender for Cloud → Secure Score | Screenshot of before score |
| 4 | Choose one recommendation (e.g., “Enable diagnostic logs for Key Vault”) and remediate it via Terraform or portal | Terraform: `azurerm_monitor_diagnostic_setting` for Key Vault | Screenshot of recommendation marked “Completed” |
| 5 | Wait up to 24 hours (or force refresh) and capture the improved Secure Score | Portal | Screenshot of after score |
| 6 | (Optional) Use CLI: `az security secure-score-controls list` | CLI | Terminal output |

---

## Phase 8 – Microsoft Sentinel

| Step | Action | Portal / CLI / Terraform | Evidence |
|------|--------|--------------------------|----------|
| 1 | Enable Microsoft Sentinel on the existing Log Analytics workspace (`la-dev-platform`) | Portal: Microsoft Sentinel → + Create → select workspace | Screenshot of Sentinel overview |
| 2 | Add the “Azure Activity” data connector (free) | Portal: Sentinel → Data connectors → Azure Activity → Open connector → Connect | Screenshot showing “Connected” status |
| 3 | Create an analytic rule (scheduled query) to detect multiple failed sign-ins: KQL: `SigninLogs | where ResultType == 50057 | summarize Occurrences = count() by IPAddress, UserPrincipalName | where Occurrences > 5` | Portal: Analytics → + Create → Scheduled query rule | Screenshot of rule KQL |
| 4 | Set rule frequency: 1 hour, alert threshold >0, generate incident | Portal (same wizard) | Screenshot of rule configuration |
| 5 | Generate a test incident: use a test user to attempt login with wrong password 6 times | Manual or script | Screenshot of incident in Sentinel → Incidents |
| 6 | (Optional) Deploy a workbook (e.g., “Azure Activity Logs” built‑in) | Portal: Sentinel → Workbooks → Save | Screenshot of workbook view |

---

## Phase 9a – Monitoring & Alerting

| Step | Action | Portal / CLI / Terraform | Evidence |
|------|--------|--------------------------|----------|
| 1 | Create an Action Group (`ag-dev-email`) with email receiver (your email) | Terraform: `azurerm_monitor_action_group` or Portal | Screenshot of action group |
| 2 | Create a Metric Alert rule: alert when CPU > 80% on the test VM (`vm-dev-client-01`) | Terraform: `azurerm_monitor_metric_alert` | Screenshot of alert rule |
| 3 | Generate high CPU load on the test VM (e.g., run a stress script or loop) | CLI / PowerShell | – |
| 4 | Verify alert fires and you receive email | Portal: Monitor → Alerts + email inbox | Screenshot of fired alert + email |
| 5 | Create a Log Analytics dashboard: pin a saved query (e.g., `AzureActivity | take 10`) to a dashboard | Portal: Log Analytics → Query → Pin to dashboard | Screenshot of dashboard tile |

---

## Phase 9b – Disaster Recovery Strategy (Azure Backup + ASR)

| Step | Action | Portal / CLI / Terraform | Evidence |
|------|--------|--------------------------|----------|
| 1 | Create Recovery Services Vault for Backup (`rsv-dev-backup`) | Terraform: `azurerm_recovery_services_vault` | Screenshot of vault |
| 2 | Create a backup policy (daily backup, 30‑day retention) | Terraform: `azurerm_backup_policy_vm` | Screenshot of policy |
| 3 | Enable backup for the test VM (`vm-dev-client-01`) | Portal: Backup → Azure Virtual Machine → select VM → assign policy | Screenshot of backup item |
| 4 | Create second Recovery Services Vault for Azure Site Recovery (`rsv-dev-asr`) | Terraform or Portal | Screenshot of ASR vault |
| 5 | Replicate the test VM to a secondary region (e.g., UK West) | Portal: ASR → + Replicate → select VM → target region | Screenshot of replication health “Healthy” |
| 6 | Run a test failover (isolated network), verify VM boots | Portal: Replicated items → Test failover | Screenshot of test VM running in secondary region |
| 7 | Clean up test failover | Portal: Cleanup test failover | – |
| 8 | Write DR plan document `docs/release2/disaster-recovery-plan.md` with RPO (24h), RTO (1h), step‑by‑step failback procedure | Local editor | File committed |

---

## Phase 9c – Onboarding Documentation

| Step | Action | Portal / CLI / Terraform | Evidence |
|------|--------|--------------------------|----------|
| 1 | Create `docs/onboarding.md` with: prerequisites (Azure sub, GitHub account), setting up Codespaces, installing tools, authenticating Azure CLI, cloning repo, running Terraform, running Ansible, portal verification steps | Local editor | File committed |
| 2 | Create `CONTRIBUTING.md` with: branch strategy (`release-2`), PR process (require plan comment, approval), naming conventions, testing requirements, how to run CI locally | Local editor | File committed |
| 3 | (Optional) Ask a colleague or future‑self to follow the guide on a fresh environment to validate completeness | Manual | Feedback documented |

---

**Time estimates for remaining phases:** P5 (3-4h), P6 (2-3h), P7 (1-2h), P8 (2-3h), P9a (1.5h), P9b (2-3h), P9c (1h) – **Total ~13-17 hours for phases 5-9c**
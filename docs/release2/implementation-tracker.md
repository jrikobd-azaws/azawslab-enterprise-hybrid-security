```markdown
# Implementation Tracker – Release 2 (Azure Enterprise Hybrid Security)

**Last Updated:** [Date]  
**Owner:** [Your Name]  
**Repository:** `https://github.com/your-username/your-repo`  
**Purpose:** Single source of truth for deployment, validation, and teardown.

---

## Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Completed and validated |
| 🔄 | In progress |
| ❌ | Blocked / failed |
| ⚠️ | Ephemeral – destroy immediately after validation |
| 🧪 | Optional – skip if not needed |

---

## Preparation Phase (Pre-P0) – Do this before any code

### 1. Azure Account & Subscription
- [ ] Upgrade free trial to **Pay-As-You-Go** (retain $200 credit)
- [ ] Verify custom domain `entra.azawslab.co.uk` in Entra ID
- [ ] Subscription ID: `_________________________________`
- [ ] Set cost alerts ($10, $50, $100) in Azure Cost Management

### 2. Global IP Addressing Strategy (non‑overlapping)
- [ ] Azure Hub: `10.0.0.0/16`
- [ ] Azure Spokes: `10.1.0.0/16`, `10.2.0.0/16`
- [ ] On‑prem Hyper‑V: `192.168.1.0/24`
- [ ] AWS Branch VPC: `172.16.0.0/16`
- [ ] *Checked:* No CIDR overlaps.

### 3. GitHub & Repository Setup
- [ ] Create **private** repo `azawslab-release2`
- [ ] Create environment `release-2` (Settings → Environments)
- [ ] Prepare secrets (to be filled after Phase 0.2):
  - `AZURE_CLIENT_ID`
  - `AZURE_TENANT_ID`
  - `AZURE_SUBSCRIPTION_ID`
- [ ] *(Optional for local runs)* `ARM_CLIENT_ID`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`

### 4. Development Environment – GitHub Codespaces
- [ ] `.devcontainer/devcontainer.json` created (see template below)
- [ ] `az --version`, `terraform --version`, `ansible --version` all work
- [ ] `az login --use-device-code` succeeds

**`.devcontainer/devcontainer.json` snippet:**

    {
      "image": "mcr.microsoft.com/devcontainers/universal:2",
      "features": {
        "ghcr.io/devcontainers/features/terraform:1": {},
        "ghcr.io/devcontainers/features/azure-cli:1": {},
        "ghcr.io/devcontainers/features/ansible:1": {}
      },
      "extensions": ["hashicorp.terraform", "redhat.ansible", "ms-vscode.azurecli"]
    }

### 5. Local Hyper‑V (for O3a/O3c – on‑prem simulation)
- [ ] Hyper‑V enabled (or VMware/VirtualBox)
- [ ] VM `hyperv-dc1` (Windows Server 2022) – static IP `192.168.1.10/24`
- [ ] (Optional) VM `hyperv-rras` – static IP `192.168.1.1/24`
- [ ] Outbound internet tested: `ping 8.8.8.8`

### 6. AWS Account (for O3b – Cisco NVA – ephemeral)
- [ ] AWS free tier account created
- [ ] IAM user with Programmatic access → keys saved
- [ ] GitHub secrets added: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- [ ] *Note:* NVA destroyed within hours → stays within free tier limits.

### 7. Entra ID & Service Principal Bootstrap
- [ ] Global Administrator role confirmed
- [ ] Run Phase 0.2 script → creates `sp-terraform-gh` with OIDC federated credential
- [ ] Contributor role assigned at subscription scope

### 8. Smoke Test (validation before Phase 0)
- [ ] `az account show` → correct subscription
- [ ] `terraform init` in empty directory → no errors
- [ ] GitHub Actions OIDC test workflow passes (`.github/workflows/oidc-test.yml`)

**Preparation finished ✅ – proceed to Phase 0.**

---

## Core Phases (P0 – P9c)

| Phase | Name | Depends | Est. | Status | Evidence Path (from repo root) | Last Run | FinOps Teardown | Validation Command |
|-------|------|---------|------|--------|-------------------------------|----------|-----------------|--------------------|
| **P0** | Foundation & OIDC Backend | Prep | 1h | [ ] | `docs/release2/evidence/P0/oidc-test.txt` | | N/A (persistent) | `terraform init` |
| **P1** | Landing Zone & MGs | P0 | 30m | [ ] | `docs/release2/evidence/P1/policy-assignments.txt` | | N/A | `az policy assignment list --scope "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"` |
| **P2a** | Terraform Modules | P1 | 1h | [ ] | `docs/release2/evidence/P2a/tf-plan.txt` | | `terraform destroy -target=module.compute` | `az vm show -n vm-dev-client-01 --expand networkProfile` (no public IP) |
| **P2b** | Ansible Config | P2a | 45m | [ ] | `docs/release2/evidence/P2b/ansible-run.txt` | | N/A | `ansible-inventory --list` |
| **P2c** | CI/CD Pipeline | P0,P2a | 45m | [ ] | `docs/release2/evidence/P2c/pr-plan-comment.png` | | N/A | Create PR → see plan comment |
| **P3** | Governance (RBAC) | P1 | 30m | [ ] | `docs/release2/evidence/P3/policy-violation.txt` | | N/A | `az policy state list` |
| **P4** | Azure Lighthouse | P0 | 30m | [ ] | `docs/release2/evidence/P4/cross-tenant-vms.txt` | | Delete registration definition | `az vm list --subscription <customer-sub-id>` |
| **P5** | Hub‑Spoke Networking | P0 | 1h | [ ] | `docs/release2/evidence/P5/vnet-peering.txt` | | N/A | `az network vnet peering list -g rg-connectivity-prod-uksouth -n vnet-dev-uksouth-hub` |
| **P6** | Azure Firewall (ephemeral) | P5 | 1h | [ ] | `docs/release2/evidence/P6/blocked-curl.txt` | | ⚠️ `terraform destroy -target=azurerm_firewall.afw` | `curl http://example.com` from spoke VM → blocked |
| **P7** | Defender for Cloud | P0 | 30m | [ ] | `docs/release2/evidence/P7/secure-score-after.txt` | | Remove premium plans only | `az security secure-score list` |
| **P8** | Microsoft Sentinel | P7 | 45m | [ ] | `docs/release2/evidence/P8/incident-screenshot.png` | | N/A | `az sentinel incident list` |
| **P9a** | Azure Monitor & Alerts | P2a | 30m | [ ] | `docs/release2/evidence/P9a/alert-email.png` | | Delete alert rule | `az monitor metric alert show -n alert-high-cpu-vm-dev-client` |
| **P9b** | Disaster Recovery (Backup+MUA) | P2a | 1h | [ ] | `docs/release2/evidence/P9b/mua-block.txt` | | Delete ASR vault only | `az backup item list --vault-name rsv-dev-backup` |
| **P9c** | Handover & FinOps Teardown | All Core | 30m | [ ] | `docs/release2/evidence/P9c/terraform-destroy.txt` | | `terraform destroy -auto-approve` | Azure Cost Analysis → $0 projected |

---

## Optional Phases (O1 – O5)

| Phase | Name | Depends | Est. | Status | Evidence Path | Last Run | Teardown (mandatory) | Cost Warning |
|-------|------|---------|------|--------|----------------|----------|----------------------|--------------|
| **O1** | Dual‑Firewall (FortiGate NVA) | P5,P6 | 2h | [ ] | `docs/release2/evidence/O1/traceroute-eastwest.txt` | | ⚠️ `terraform destroy -target=azurerm_linux_virtual_machine.fortigate` | Ephemeral + Market image |
| **O2** | Azure Arc | P0 | 45m | [ ] | `docs/release2/evidence/O2/connected-machine-list.txt` | | Disconnect agent | minimal |
| **O3a** | BGP over IPSec (FortiGate ↔ HQ) | O1, Hyper‑V | 1.5h | [ ] | `docs/release2/evidence/O3a/bgp-summary.txt` | | ⚠️ Destroy FortiGate (O1) | depends on O1 |
| **O3b** | AWS Cisco NVA | O1, AWS | 2h | [ ] | `docs/release2/evidence/O3b/bgp-routes-fortigate.txt` | | ⚠️ `terraform -chdir=aws/ destroy` | AWS t3.micro (ephemeral) |
| **O3c** | Transitive Routing | O3a,O3b | 1h | [ ] | `docs/release2/evidence/O3c/traceroute-aws-to-hq.txt` | | ⚠️ Destroy FortiGate + Cisco | depends on O1+O3b |
| **O4** | Entra GSA (ZTNA) | P0,P2a | 1.5h | [ ] | `docs/release2/evidence/O4/rdp-via-gsa.txt` | | ⚠️ Destroy GSA Connector VM | trial license |
| **O5** | AVD + FSLogix | P5,O4 | 2h | [ ] | `docs/release2/evidence/O5/fslogix-roaming.txt` | | ⚠️ `terraform destroy -target=azurerm_windows_virtual_machine.avd_session` | Azure Files Premium + B2s |

---

## Post-Completion Checklist (Handover)

- [ ] All ephemeral resources destroyed: `az resource list --tag Ephemeral=true` empty
- [ ] Azure Firewall, FortiGate, Cisco NVA, AVD session hosts removed
- [ ] Cost Management shows $0 projected compute spend (storage < $1 acceptable)
- [ ] `onboarding.md` and `CONTRIBUTING.md` committed to `release-2`
- [ ] Terraform state `.tfstate` backup downloaded locally
- [ ] One‑line rebuild test: new engineer clones and runs the tracker from Prep – succeeds within 60 min

---

## Troubleshooting – Common Enterprise Pitfalls

| Problem | Likely Cause | Fix |
|---------|--------------|-----|
| **OIDC workflow fails** | Federated credential subject mismatch | Ensure `repo:<owner>/<repo>:environment:release-2` exactly matches |
| **Terraform init fails** | Storage account name not unique | Append random digits to `stdevterraform` |
| **VM gets public IP** | Module drift / incorrect NIC config | Check NIC has no `public_ip_address_id` |
| **BGP peer never establishes** | NSG or AWS SG blocking UDP 500/4500 or TCP 179 | Open these ports on both sides |
| **GSA Private Access fails** | Connector cannot reach spoke VM | Place connector in Hub management subnet, verify peering |
| **Unexpected charges** | Ephemeral resource left running | Run `terraform destroy` for that phase immediately |

---

**End of Implementation Tracker – Copy‑paste ready.**
```
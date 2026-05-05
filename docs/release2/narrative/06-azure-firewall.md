# 06-azure-firewall

## 1. Objective

Phase P6 validates centralized internet egress inspection through Azure Firewall in the Release 2 hub-spoke topology.

The objective is to prove that workload-spoke traffic can be steered through a platform-managed Azure Firewall using Terraform-controlled routing, while keeping the firewall ephemeral for cost control.

## 2. Business Problem

Enterprise Azure environments normally require centralized egress control rather than allowing every workload subnet to reach the internet directly.

Without central inspection, teams lose:

- consistent outbound allow/deny control
- auditability of internet-bound traffic
- a clear enforcement point for platform security policy
- a clean path toward future dual-firewall routing with an NVA such as FortiGate

For this portfolio lab, Azure Firewall is also cost-heavy. The design therefore needs to prove the control without leaving the firewall running unnecessarily.

## 3. Technical Solution

P6 adds Azure Firewall capability to the existing `terraform/platform-networking/dev` root.

The implementation uses the existing P5 hub-spoke foundation:

- Hub VNet: `vnet-dev-norwayeast-hub`
- Connectivity resource group: `rg-connectivity-prod-norwayeast`
- Firewall subnet: `AzureFirewallSubnet`
- Workload route table: `rt-workload-to-hub-norwayeast`
- Workload subnet: `snet-workload`

Azure Firewall is implemented as a boolean-controlled ephemeral resource:

```hcl
enable_azure_firewall = true
```

When enabled, Terraform deploys:

- Azure Firewall: `afw-dev-norwayeast-01`
- Firewall Policy: `afwp-dev-norwayeast`
- Firewall Public IP: `pip-azfw-norwayeast-01`
- Firewall rule collection group: `rcg-p6-validation`
- Default route from the workload route table to the firewall private IP

The committed design keeps the firewall controlled through Terraform so it can be disabled later by setting:

```hcl
enable_azure_firewall = false
```

and rerunning the controlled GitHub Actions Terraform Apply workflow.

## 4. Architecture Snapshot

```text
[Workload VM / snet-workload]
          |
          | 0.0.0.0/0 route
          v
[rt-workload-to-hub-norwayeast]
          |
          | next hop: VirtualAppliance
          | next hop IP: 10.0.1.4
          v
[Azure Firewall: afw-dev-norwayeast-01]
          |
          v
[Internet / approved destinations]
```

The route table name `rt-workload-to-hub-norwayeast` is intentionally retained as a generic workload-to-hub steering table. It can support Azure Firewall now and later FortiGate NVA or hybrid route steering.

## 5. Implementation Summary

P6 was implemented through the `platform-networking-dev` Terraform root and deployed using GitHub Actions OIDC.

The first implementation used Azure Firewall Basic. GitHub Actions Apply partially succeeded but failed during firewall creation with:

```text
BasicSkuFirewallMissingManagementIpConfiguration
```

Root cause:

Azure Firewall Basic requires a separate management IP configuration and `AzureFirewallManagementSubnet`. The current P5 hub design reserved `AzureFirewallSubnet`, `AzureBastionSubnet`, and `GatewaySubnet`, but not `AzureFirewallManagementSubnet`.

Correction:

The Terraform implementation was updated to use Azure Firewall Standard instead of Basic. This allowed the firewall to deploy into the existing P5 hub design without adding a new management subnet.

The corrected GitHub Actions Apply succeeded and produced the firewall deployment.

## 6. Validation Summary

Confirmed after deployment:

- Azure Firewall deployed: `afw-dev-norwayeast-01`
- Firewall private IP: `10.0.1.4`
- Firewall Policy deployed: `afwp-dev-norwayeast`
- Public IP deployed: `pip-azfw-norwayeast-01`
- Firewall provisioning state: `Succeeded`
- Workload route table output present
- Default route output present
- GitHub Actions `platform-networking-dev` apply succeeded

Completed validation:
- workload traffic test through the firewall
- Microsoft/Azure HTTPS allow test
- social-media block test using facebook.com
- workload VM deallocated after testing
- Azure Firewall teardown completed through GitHub Actions

Deferred validation:
- firewall KQL/log validation was deferred because diagnostic settings were not enabled for this ephemeral deployment.

## 7. Evidence Path

Primary evidence is stored under:

```text
docs/release2/evidence/P6/
```

Key evidence files:

- `p6-readiness-current-state.txt`
- `p6-existing-azure-firewalls.json`
- `p6-platform-networking-disabled-plan.txt`
- `p6-platform-networking-enabled-plan.txt`
- `p6-failed-apply-partial-state.txt`
- `p6-firewall-post-apply-validation.txt`
- `p6-evidence.txt`
- `p6-execution-log.txt`

Supplementary screenshots:

- `p6-github-actions-platform-networking-apply-success.png`
- `p6-portal-connectivity-rg-firewall-resources.png`
- `p6-portal-firewall-overview.png`

## 8. Key Commands Used

Representative validation commands:

```powershell
terraform -chdir="terraform/platform-networking/dev" validate
terraform -chdir="terraform/platform-networking/dev" plan -no-color -input=false
terraform -chdir="terraform/platform-networking/dev" output

az network firewall show --resource-group "rg-connectivity-prod-norwayeast" --name "afw-dev-norwayeast-01" --output json
az network firewall policy show --resource-group "rg-connectivity-prod-norwayeast" --name "afwp-dev-norwayeast" --output json
az network public-ip show --resource-group "rg-connectivity-prod-norwayeast" --name "pip-azfw-norwayeast-01" --output json
az network route-table show --resource-group "rg-dev-workload-norwayeast" --name "rt-workload-to-hub-norwayeast" --output json
```

GitHub Actions was used for controlled deployment rather than local Terraform apply.

## 9. Lessons Learned

- Azure Firewall Basic has additional subnet and management IP requirements that must be accounted for during hub design.
- Standard SKU was a better fit for the existing P5 hub-spoke implementation because it avoided redesigning the hub subnet layout during P6.
- Partial Terraform applies can create some resources before a later resource fails; recovery should use Terraform convergence rather than manual deletion.
- Keeping Azure Firewall behind an enable/disable variable supports a clean ephemeral FinOps pattern.
- The existing `rt-workload-to-hub-norwayeast` route table is more future-proof than a firewall-specific route table name because it can later support FortiGate or hybrid routing as well.

## 10. Recruiter-Ready Outcome Statement

Implemented centralized Azure Firewall egress control in a Terraform-managed hub-spoke Azure landing zone. Deployed Azure Firewall, Firewall Policy, rule collections, public IP, and workload default-route steering through GitHub Actions OIDC, while preserving a cost-aware ephemeral lifecycle using Terraform enable/disable controls. Diagnosed and corrected a real Azure Firewall Basic SKU deployment issue by moving to Standard SKU and converging the partial Terraform state safely through CI/CD.

## 11. Teardown Summary

After deployment and workload egress validation, Azure Firewall was disabled by setting:

```hcl
enable_azure_firewall = false
```

A controlled GitHub Actions Terraform Apply was then run against `platform-networking-dev`.

Result:

```text
Apply complete! Resources: 0 added, 0 changed, 5 destroyed.
```

Destroyed ephemeral P6 resources:

- Azure Firewall
- Azure Firewall Policy
- Firewall Policy Rule Collection Group
- Azure Firewall Public IP
- Default route to Azure Firewall private IP

Post-teardown validation confirmed that the firewall-specific resources were absent, while the P5 hub-spoke foundation remained in Terraform state.

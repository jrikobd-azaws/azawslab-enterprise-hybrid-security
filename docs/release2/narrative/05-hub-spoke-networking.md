# 05-hub-spoke-networking

## 1. Objective

Phase P5 implemented the Azure hub-spoke networking foundation for Release 2.

The objective was to move from a spoke-only workload network to an enterprise-aligned hub-spoke topology with a separate platform networking Terraform root.

P5 deployed:

- a connectivity resource group
- a hub virtual network
- reserved hub subnets for Bastion, Azure Firewall, and VPN Gateway
- bidirectional hub/spoke VNet peerings
- a workload route table scaffold
- a route table association to the workload subnet

P5 did not deploy Azure Firewall, Azure Bastion, or VPN Gateway instances. Those services remain later phase work, but the hub network is now ready for them.

## 2. Business Problem

The environment previously had a workload spoke VNet but no central hub network.

That meant the design was missing the network foundation required for:

- centralized ingress and administrative access
- future Azure Bastion deployment
- future Azure Firewall forced tunneling
- future VPN Gateway or hybrid routing
- scalable workload spoke expansion
- enterprise-style platform/network separation

A production landing zone should not place every networking function inside a workload root. Hub networking is platform infrastructure and should have its own lifecycle boundary.

## 3. Technical Solution

P5 introduced a new Terraform root:

```text
terraform/platform-networking/dev
```

This root uses its own backend state key:

```text
platform-networking-dev.tfstate
```

A new reusable module was added:

```text
terraform/modules/hub-spoke-networking
```

The platform networking root discovers the existing workload spoke VNet using Azure data sources and then deploys the hub resources and connectivity controls.

This avoids changing the existing workload root and avoids touching the existing workload VM or the deallocated Ansible management host.

## 4. Architecture Snapshot

```text
[Azure subscription 1 / entra.azawslab.co.uk]
        |
        +-- rg-connectivity-prod-norwayeast
        |       |
        |       +-- vnet-dev-norwayeast-hub 10.0.0.0/16
        |              |
        |              +-- AzureBastionSubnet 10.0.0.0/26
        |              +-- AzureFirewallSubnet 10.0.1.0/26
        |              +-- GatewaySubnet 10.0.2.0/27
        |
        +-- rg-dev-workload-norwayeast
                |
                +-- vnet-dev-norwayeast-spoke-workload 10.10.0.0/16
                       |
                       +-- snet-workload 10.10.0.0/24
                       +-- snet-mgmt 10.10.1.0/24
                       |
                       +-- rt-workload-to-hub-norwayeast associated to snet-workload

Peering:
- peer-hub-to-spoke-workload
- peer-spoke-workload-to-hub
```

## 5. Implementation Summary

P5 started with a readiness audit. The audit confirmed that the environment had only the workload spoke VNet:

- `vnet-dev-norwayeast-spoke-workload`
- address space `10.10.0.0/16`
- subnets `snet-workload` and `snet-mgmt`

No hub VNet, route tables, or VNet peerings existed before P5.

The Terraform design was updated to avoid expanding the workload root further. Instead, P5 introduced a new platform networking root with its own state file.

The GitHub Actions Terraform CI and Apply workflows were updated to include:

```text
platform-networking-dev
terraform/platform-networking/dev
```

The Apply workflow deployed the new platform networking root successfully.

Deployment result:

```text
platform-networking-dev:
Resources: 9 added, 0 changed, 0 destroyed
```

The existing `workload-dev` root showed no infrastructure changes during the same deployment cycle.

## 6. Validation Summary

Validation confirmed:

- hub VNet exists in `rg-connectivity-prod-norwayeast`
- hub address space is `10.0.0.0/16`
- reserved hub subnets exist:
  - `AzureBastionSubnet`
  - `AzureFirewallSubnet`
  - `GatewaySubnet`
- workload spoke VNet remains in `rg-dev-workload-norwayeast`
- workload spoke address space remains `10.10.0.0/16`
- hub-to-spoke peering is `Connected`
- spoke-to-hub peering is `Connected`
- route table `rt-workload-to-hub-norwayeast` exists
- `snet-workload` is associated with the route table

This validates the P5 hub-spoke foundation and prepares the environment for P6 Azure Firewall.

## 7. Evidence Path

Primary evidence is stored under:

```text
docs/release2/evidence/P5/
```

Key evidence files:

```text
p5-readiness-current-state.txt
p5-platform-networking-plan.txt
p5-platform-networking-validation.txt
p5-evidence.txt
p5-execution-log.txt
```

## 8. Key Commands Used

Terraform plan:

```powershell
terraform plan -input=false -no-color
```

Hub VNet validation:

```powershell
az network vnet show `
  --resource-group 'rg-connectivity-prod-norwayeast' `
  --name 'vnet-dev-norwayeast-hub'
```

Peering validation:

```powershell
az network vnet peering list `
  --resource-group 'rg-connectivity-prod-norwayeast' `
  --vnet-name 'vnet-dev-norwayeast-hub'

az network vnet peering list `
  --resource-group 'rg-dev-workload-norwayeast' `
  --vnet-name 'vnet-dev-norwayeast-spoke-workload'
```

Route table validation:

```powershell
az network route-table list `
  --resource-group 'rg-dev-workload-norwayeast'

az network vnet subnet show `
  --resource-group 'rg-dev-workload-norwayeast' `
  --vnet-name 'vnet-dev-norwayeast-spoke-workload' `
  --name 'snet-workload'
```

## 9. Lessons Learned

P5 reinforced the importance of Terraform state boundaries.

The first design idea was to add hub-spoke resources to the existing workload root. That would have worked technically, but it would have mixed platform networking with workload compute.

The improved design created a new enterprise-aligned platform networking root. This keeps hub networking, future firewall resources, gateway subnets, and route controls separate from workload VM lifecycle.

P5 also confirmed that data sources can be useful when a platform root needs to reference an existing workload VNet without requiring a workload state output change.


## Post-P5 Platform Management State Split

After P5 closeout, the temporary Ansible management host was separated from the workload Terraform root into a dedicated platform-management root:

```text
terraform/platform-management/dev
```

The new backend state key is:

```text
platform-management-dev.tfstate
```

This refactor moved ownership of the existing management resource group, public IP, NIC, and Linux management VM out of `workload-dev.tfstate` and into `platform-management-dev.tfstate`.

No Azure resources were destroyed or recreated. Both roots were validated after the split:

```text
workload-dev: no changes
platform-management-dev: no changes
```

This improves the enterprise state model by keeping workload resources, platform networking, shared security, governance, and operations-plane management resources in separate lifecycle boundaries.
## 10. Recruiter-Ready Outcome Statement

Implemented an enterprise-aligned Azure hub-spoke networking foundation using Terraform. Added a dedicated platform networking root with separate state, deployed a hub VNet with reserved Bastion, Firewall, and Gateway subnets, configured bidirectional peering to the workload spoke, and associated a route table scaffold to the workload subnet. Validated the topology with CLI-first evidence while ensuring existing workload and management VM resources were not changed.


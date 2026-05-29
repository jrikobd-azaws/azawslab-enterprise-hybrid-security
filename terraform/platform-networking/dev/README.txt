# Platform-networking root

This Terraform root owns shared Azure networking infrastructure for Release 2 dev scope.

Owned here:
- connectivity resource group
- hub VNet
- AzureBastionSubnet
- AzureFirewallSubnet
- GatewaySubnet
- hub/spoke VNet peerings
- workload route table scaffold
- conditional Azure Firewall resources for P6 validation

State:
- platform-networking-dev.tfstate

Backend:
- resource group: rg-dev-terraformstate-norwayeast
- storage account: stdevtfstatene01
- container: tfstate
- key: platform-networking-dev.tfstate

Design notes:
- This root discovers the existing workload spoke VNet and workload subnet using Azure data sources.
- It does not read workload-dev remote-state outputs.
- Azure Firewall is treated as an ephemeral platform-networking resource.
- Azure Firewall deployment is controlled by enable_azure_firewall.
- Keep enable_azure_firewall false unless actively validating P6 or a dependent phase.
- After validation evidence is captured, disable Azure Firewall again and run a controlled GitHub Actions apply to remove cost-heavy firewall resources.
- The route table rt-workload-to-hub-norwayeast is retained as the generic workload-to-hub steering table for Azure Firewall, later FortiGate NVA routing, and future hybrid routes.

Azure Bastion lifecycle:
- AzureBastionSubnet is persistent hub-spoke foundation infrastructure.
- Azure Bastion host deployment is optional and controlled by enable_bastion.
- Keep enable_bastion false unless actively validating Bastion access or a dependent phase requires it.
- After Bastion evidence is captured, disable Bastion again and run controlled GitHub Actions Apply to remove cost-heavy Bastion resources.

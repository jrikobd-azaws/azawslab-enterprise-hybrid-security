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

State:
- platform-networking-dev.tfstate

This root reads workload VNet outputs from workload-dev.tfstate.

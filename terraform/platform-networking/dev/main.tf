data "azurerm_virtual_network" "workload_spoke" {
  name                = "vnet-dev-norwayeast-spoke-workload"
  resource_group_name = "rg-dev-workload-norwayeast"
}

data "azurerm_subnet" "workload" {
  name                 = "snet-workload"
  virtual_network_name = data.azurerm_virtual_network.workload_spoke.name
  resource_group_name  = data.azurerm_virtual_network.workload_spoke.resource_group_name
}

locals {
  common_tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

module "hub_spoke_networking" {
  source = "../../modules/hub-spoke-networking"

  connectivity_resource_group_name = "rg-connectivity-prod-norwayeast"
  location                         = "norwayeast"

  hub_vnet_name     = "vnet-dev-norwayeast-hub"
  hub_address_space = ["10.0.0.0/16"]

  bastion_subnet_prefixes  = ["10.0.0.0/26"]
  firewall_subnet_prefixes = ["10.0.1.0/26"]
  gateway_subnet_prefixes  = ["10.0.2.0/27"]

  workload_spoke_vnet_id             = data.azurerm_virtual_network.workload_spoke.id
  workload_spoke_vnet_name           = data.azurerm_virtual_network.workload_spoke.name
  workload_spoke_resource_group_name = data.azurerm_virtual_network.workload_spoke.resource_group_name
  workload_subnet_id                 = data.azurerm_subnet.workload.id

  hub_to_spoke_peering_name = "peer-hub-to-spoke-workload"
  spoke_to_hub_peering_name = "peer-spoke-workload-to-hub"

  workload_route_table_name         = "rt-workload-to-hub-norwayeast"
  enable_o1_fortigate_service_chain = var.enable_o1_fortigate_service_chain
  o1_service_chain_route_name       = var.o1_service_chain_route_name
  o1_service_chain_hq_prefix        = var.o1_service_chain_hq_prefix
  o1_service_chain_next_hop_ip      = var.o1_service_chain_next_hop_ip
  enable_bastion                    = false
  bastion_host_name                 = "bas-dev-norwayeast-01"
  bastion_public_ip_name            = "pip-bas-dev-norwayeast-01"

  enable_azure_firewall         = false
  azure_firewall_name           = "afw-dev-norwayeast-01"
  azure_firewall_public_ip_name = "pip-azfw-norwayeast-01"
  azure_firewall_policy_name    = "afwp-dev-norwayeast"
  azure_firewall_route_name     = "route-default-to-azure-firewall"

  tags = local.common_tags
}












resource "azurerm_resource_group" "connectivity" {
  name     = var.connectivity_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  address_space       = var.hub_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.bastion_subnet_prefixes
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.firewall_subnet_prefixes
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.gateway_subnet_prefixes
}

resource "azurerm_virtual_network_peering" "hub_to_workload_spoke" {
  name                         = var.hub_to_spoke_peering_name
  resource_group_name          = azurerm_resource_group.connectivity.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = var.workload_spoke_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "workload_spoke_to_hub" {
  name                         = var.spoke_to_hub_peering_name
  resource_group_name          = var.workload_spoke_resource_group_name
  virtual_network_name         = var.workload_spoke_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_route_table" "workload_to_hub" {
  name                = var.workload_route_table_name
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = var.workload_spoke_resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_route_table_association" "workload" {
  subnet_id      = var.workload_subnet_id
  route_table_id = azurerm_route_table.workload_to_hub.id
}

resource "azurerm_public_ip" "azure_firewall" {
  count = var.enable_azure_firewall ? 1 : 0

  name                = var.azure_firewall_public_ip_name
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall_policy" "this" {
  count = var.enable_azure_firewall ? 1 : 0

  name                = var.azure_firewall_policy_name
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "this" {
  count = var.enable_azure_firewall ? 1 : 0

  name                = var.azure_firewall_name
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this[0].id
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.azure_firewall[0].id
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "p6_validation" {
  count = var.enable_azure_firewall ? 1 : 0

  name               = "rcg-p6-validation"
  firewall_policy_id = azurerm_firewall_policy.this[0].id
  priority           = 100

  application_rule_collection {
    name     = "arc-allow-microsoft-services"
    priority = 100
    action   = "Allow"

    rule {
      name = "allow-microsoft-and-azure"

      protocols {
        type = "Https"
        port = 443
      }

      source_addresses = [
        "10.10.0.0/16"
      ]

      destination_fqdns = [
        "*.microsoft.com",
        "*.azure.com"
      ]
    }
  }

  network_rule_collection {
    name     = "nrc-allow-dns"
    priority = 200
    action   = "Allow"

    rule {
      name = "allow-dns"

      protocols = [
        "UDP",
        "TCP"
      ]

      source_addresses = [
        "10.10.0.0/16"
      ]

      destination_addresses = [
        "*"
      ]

      destination_ports = [
        "53"
      ]
    }
  }
}

resource "azurerm_route" "default_to_azure_firewall" {
  count = var.enable_azure_firewall ? 1 : 0

  name                   = var.azure_firewall_route_name
  resource_group_name    = var.workload_spoke_resource_group_name
  route_table_name       = azurerm_route_table.workload_to_hub.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.this[0].ip_configuration[0].private_ip_address
}


resource "azurerm_public_ip" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name                = var.bastion_public_ip_name
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  count = var.enable_bastion ? 1 : 0

  name                = var.bastion_host_name
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku                 = "Basic"
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }
}

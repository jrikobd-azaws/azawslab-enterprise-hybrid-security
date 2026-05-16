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
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "workload_spoke_to_hub" {
  name                         = var.spoke_to_hub_peering_name
  resource_group_name          = var.workload_spoke_resource_group_name
  virtual_network_name         = var.workload_spoke_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true

  depends_on = [
    azurerm_virtual_network_peering.hub_to_workload_spoke
  ]
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
resource "azurerm_route" "o1_hq_via_fortigate" {
  count = var.enable_o1_fortigate_service_chain ? 1 : 0

  name                   = var.o1_service_chain_route_name
  resource_group_name    = var.workload_spoke_resource_group_name
  route_table_name       = azurerm_route_table.workload_to_hub.name
  address_prefix         = var.o1_service_chain_hq_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.o1_service_chain_next_hop_ip

  depends_on = [
    azurerm_subnet_route_table_association.workload
  ]
}


resource "azurerm_route_table" "gateway_ingress_fgt" {
  count = var.enable_p5_gateway_ingress_fortigate ? 1 : 0

  name                = var.p5_gateway_ingress_route_table_name
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  tags                = var.tags
}

resource "azurerm_route" "gateway_ingress_workload_via_fgt_port1" {
  count = var.enable_p5_gateway_ingress_fortigate ? 1 : 0

  name                   = var.p5_gateway_ingress_route_name
  resource_group_name    = azurerm_resource_group.connectivity.name
  route_table_name       = azurerm_route_table.gateway_ingress_fgt[0].name
  address_prefix         = var.p5_gateway_ingress_workload_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.p5_gateway_ingress_fortigate_port1_ip
}

resource "azurerm_subnet_route_table_association" "gateway_ingress_fgt" {
  count = var.enable_p5_gateway_ingress_fortigate ? 1 : 0

  subnet_id      = azurerm_subnet.gateway.id
  route_table_id = azurerm_route_table.gateway_ingress_fgt[0].id

  depends_on = [
    azurerm_route.gateway_ingress_workload_via_fgt_port1
  ]
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

  dns {
    proxy_enabled = true
  }
  tags = var.tags
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

  name               = "rcg-o4-private-aks-egress"
  firewall_policy_id = azurerm_firewall_policy.this[0].id
  priority           = 100

  application_rule_collection {
    name     = "arc-o4-aks-platform-required"
    priority = 100
    action   = "Allow"

    rule {
      name             = "allow-aks-platform-fqdn-tag"
      source_addresses = ["10.10.0.0/16"]

      destination_fqdn_tags = [
        "AzureKubernetesService"
      ]

      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  application_rule_collection {
    name     = "arc-o4-aks-core-and-registry"
    priority = 110
    action   = "Allow"

    rule {
      name             = "allow-aks-core-microsoft-endpoints"
      source_addresses = ["10.10.0.0/16"]

      destination_fqdns = [
        "management.azure.com",
        "login.microsoftonline.com",
        "packages.microsoft.com",
        "mcr.microsoft.com",
        "*.data.mcr.microsoft.com",
        "mcr-0001.mcr-msedge.net",
        "*.microsoft.com",
        "*.azure.com"
      ]

      protocols {
        type = "Https"
        port = 443
      }
    }

    rule {
      name             = "allow-o4-acr-endpoints"
      source_addresses = ["10.10.0.0/16"]

      destination_fqdns = [
        "acrdevazawsne01.azurecr.io",
        "*.azurecr.io",
        "*.data.azurecr.io",
        "*.blob.core.windows.net"
      ]

      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  application_rule_collection {
    name     = "arc-o4-keyvault-monitoring"
    priority = 120
    action   = "Allow"

    rule {
      name             = "allow-keyvault-csi"
      source_addresses = ["10.10.0.0/16"]

      destination_fqdns = [
        "vault.azure.net",
        "*.vault.azure.net"
      ]

      protocols {
        type = "Https"
        port = 443
      }
    }

    rule {
      name             = "allow-azure-monitor-prometheus-grafana-dependencies"
      source_addresses = ["10.10.0.0/16"]

      destination_fqdns = [
        "*.ods.opinsights.azure.com",
        "*.oms.opinsights.azure.com",
        "dc.services.visualstudio.com",
        "*.monitoring.azure.com",
        "global.handler.control.monitor.azure.com",
        "norwayeast.handler.control.monitor.azure.com",
        "*.ingest.monitor.azure.com",
        "*.metrics.ingest.monitor.azure.com",
        "login.microsoftonline.com",
        "management.azure.com"
      ]

      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  network_rule_collection {
    name     = "nrc-o4-aks-platform-network"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "allow-dns"
      source_addresses      = ["10.10.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
      protocols             = ["UDP", "TCP"]
    }

    rule {
      name                  = "allow-ntp"
      source_addresses      = ["10.10.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["123"]
      protocols             = ["UDP"]
    }

    rule {
      name                  = "allow-azure-monitor-service-tag"
      source_addresses      = ["10.10.0.0/16"]
      destination_addresses = ["AzureMonitor"]
      destination_ports     = ["443"]
      protocols             = ["TCP"]
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

resource "azurerm_firewall_policy_rule_collection_group" "o5_avd_egress" {
  count = var.enable_azure_firewall && var.enable_o5_avd_egress ? 1 : 0

  name               = "rcg-o5-avd-egress"
  firewall_policy_id = azurerm_firewall_policy.this[0].id
  priority           = 110

  application_rule_collection {
    name     = "arc-o5-avd-required"
    priority = 100
    action   = "Allow"

    rule {
      name             = "allow-avd-service-fqdn-tag"
      source_addresses = var.o5_avd_source_addresses

      destination_fqdn_tags = [
        "WindowsVirtualDesktop"
      ]

      protocols {
        type = "Https"
        port = 443
      }
    }

    rule {
      name             = "allow-windows-update-fqdn-tag"
      source_addresses = var.o5_avd_source_addresses

      destination_fqdn_tags = [
        "WindowsUpdate"
      ]

      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  application_rule_collection {
    name     = "arc-o5-avd-auth-bootstrap"
    priority = 110
    action   = "Allow"

    rule {
      name             = "allow-avd-identity-arm-storage-bootstrap"
      source_addresses = var.o5_avd_source_addresses

      destination_fqdns = [
        "login.microsoftonline.com",
        "device.login.microsoftonline.com",
        "enterpriseregistration.windows.net",
        "pas.windows.net",
        "management.azure.com",
        "*.blob.core.windows.net"
      ]

      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  network_rule_collection {
    name     = "nrc-o5-avd-monitoring"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "allow-azure-monitor-service-tag"
      source_addresses      = var.o5_avd_source_addresses
      destination_addresses = ["AzureMonitor"]
      destination_ports     = ["443"]
      protocols             = ["TCP"]
    }
  }
}

resource "azurerm_route" "gateway_ingress_avd_via_fgt_port1" {
  count = var.enable_p5_gateway_ingress_fortigate && var.enable_o5_o6_private_admin_transit ? 1 : 0

  name                   = var.o5_gateway_ingress_avd_route_name
  resource_group_name    = azurerm_resource_group.connectivity.name
  route_table_name       = azurerm_route_table.gateway_ingress_fgt[0].name
  address_prefix         = var.o5_gateway_ingress_avd_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.p5_gateway_ingress_fortigate_port1_ip

  depends_on = [
    azurerm_subnet_route_table_association.gateway_ingress_fgt
  ]
}

resource "azurerm_firewall_policy_rule_collection_group" "o5_o6_private_admin_transit" {
  count = var.enable_azure_firewall && var.enable_o5_o6_private_admin_transit ? 1 : 0

  name               = "rcg-o5-o6-private-admin-transit"
  firewall_policy_id = azurerm_firewall_policy.this[0].id
  priority           = 120

  network_rule_collection {
    name     = "nrc-o5-o6-azure-admin-platform"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-avd-to-awx-private-ui"
      source_addresses      = var.o5_o6_admin_source_addresses
      destination_addresses = [var.o5_o6_awx_private_ip]
      destination_ports     = var.o5_o6_awx_nodeport_ports
      protocols             = ["TCP"]
    }

    rule {
      name                  = "allow-avd-to-aks-private-api"
      source_addresses      = var.o5_o6_admin_source_addresses
      destination_addresses = [var.o5_o6_aks_api_private_ip]
      destination_ports     = var.o5_o6_aks_api_ports
      protocols             = ["TCP"]
    }

    rule {
      name                  = "allow-avd-to-mgmt-ssh"
      source_addresses      = var.o5_o6_admin_source_addresses
      destination_addresses = [var.o5_o6_mgmt_private_ip]
      destination_ports     = var.o5_o6_mgmt_ssh_ports
      protocols             = ["TCP"]
    }
  }
}

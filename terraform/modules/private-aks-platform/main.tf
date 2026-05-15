locals {
  prometheus_name = "MSProm-${var.location}-${var.aks_name}"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "workload" {
  count = var.enabled ? 1 : 0

  name = var.workload_rg_name
}

data "azurerm_virtual_network" "workload_spoke" {
  count = var.enabled ? 1 : 0

  name                = var.workload_vnet_name
  resource_group_name = var.workload_rg_name
}

data "azurerm_firewall" "o4_egress" {
  count = var.enabled ? 1 : 0

  name                = var.azure_firewall_name
  resource_group_name = var.connectivity_rg_name
}

resource "azurerm_resource_group" "this" {
  count = var.enabled ? 1 : 0

  name     = var.resource_group_name
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_subnet" "aks" {
  count = var.enabled ? 1 : 0

  name                 = var.aks_subnet_name
  resource_group_name  = data.azurerm_resource_group.workload[0].name
  virtual_network_name = data.azurerm_virtual_network.workload_spoke[0].name
  address_prefixes     = var.aks_subnet_prefixes
}

resource "azurerm_route_table" "aks_egress" {
  count = var.enabled ? 1 : 0

  name                          = var.route_table_name
  location                      = data.azurerm_resource_group.workload[0].location
  resource_group_name           = data.azurerm_resource_group.workload[0].name
  bgp_route_propagation_enabled = true
  tags                          = var.common_tags
}

resource "azurerm_route" "default_to_firewall" {
  count = var.enabled ? 1 : 0

  name                   = "route-default-to-azure-firewall"
  resource_group_name    = data.azurerm_resource_group.workload[0].name
  route_table_name       = azurerm_route_table.aks_egress[0].name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_firewall.o4_egress[0].ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "aks" {
  count = var.enabled ? 1 : 0

  subnet_id      = azurerm_subnet.aks[0].id
  route_table_id = azurerm_route_table.aks_egress[0].id
}

resource "azurerm_user_assigned_identity" "aks" {
  count = var.enabled ? 1 : 0

  name                = var.aks_identity_name
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  tags                = var.common_tags
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_subnet.aks[0].id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks[0].principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_container_registry" "this" {
  count = var.enabled ? 1 : 0

  name                          = var.acr_name
  resource_group_name           = azurerm_resource_group.this[0].name
  location                      = azurerm_resource_group.this[0].location
  sku                           = var.acr_sku
  admin_enabled                 = false
  anonymous_pull_enabled        = false
  public_network_access_enabled = true
  tags                          = var.common_tags
}

resource "azurerm_monitor_workspace" "this" {
  count = var.enabled ? 1 : 0

  name                = var.monitor_workspace_name
  resource_group_name = azurerm_resource_group.this[0].name
  location            = azurerm_resource_group.this[0].location
  tags                = var.common_tags
}

resource "azurerm_monitor_data_collection_endpoint" "prometheus" {
  count = var.enabled ? 1 : 0

  name                = substr(local.prometheus_name, 0, 44)
  resource_group_name = azurerm_resource_group.this[0].name
  location            = azurerm_resource_group.this[0].location
  kind                = "Linux"
  tags                = var.common_tags
}

resource "azurerm_monitor_data_collection_rule" "prometheus" {
  count = var.enabled ? 1 : 0

  name                        = substr(local.prometheus_name, 0, 64)
  resource_group_name         = azurerm_resource_group.this[0].name
  location                    = azurerm_resource_group.this[0].location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.prometheus[0].id
  kind                        = "Linux"
  description                 = "DCR for O4 AKS Azure Monitor managed Prometheus."
  tags                        = var.common_tags

  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.this[0].id
      name               = "MonitoringAccount1"
    }
  }

  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = ["MonitoringAccount1"]
  }

  data_sources {
    prometheus_forwarder {
      streams = ["Microsoft-PrometheusMetrics"]
      name    = "PrometheusDataSource"
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  count = var.enabled ? 1 : 0

  name                                = var.aks_name
  location                            = azurerm_resource_group.this[0].location
  resource_group_name                 = azurerm_resource_group.this[0].name
  node_resource_group                 = var.node_resource_group
  dns_prefix                          = var.dns_prefix_private
  kubernetes_version                  = var.kubernetes_version
  private_cluster_enabled             = true
  private_dns_zone_id                 = "System"
  private_cluster_public_fqdn_enabled = false
  local_account_disabled              = true
  role_based_access_control_enabled   = true
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  sku_tier                            = "Free"
  tags                                = var.common_tags

  default_node_pool {
    name                         = "system"
    vm_size                      = var.node_vm_size
    node_count                   = var.system_node_count
    vnet_subnet_id               = azurerm_subnet.aks[0].id
    only_critical_addons_enabled = false
    node_public_ip_enabled       = false
    max_pods                     = 30
    temporary_name_for_rotation  = "sysrot"
    tags                         = var.common_tags

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks[0].id]
  }

  azure_active_directory_role_based_access_control {
    tenant_id              = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled     = false
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    outbound_type       = "userDefinedRouting"
    load_balancer_sku   = "standard"
    pod_cidr            = "10.244.0.0/16"
    service_cidr        = "10.240.0.0/16"
    dns_service_ip      = "10.240.0.10"
  }

  depends_on = [
    azurerm_role_assignment.aks_network_contributor,
    azurerm_subnet_route_table_association.aks
  ]
}

resource "azurerm_monitor_data_collection_rule_association" "prometheus" {
  count = var.enabled ? 1 : 0

  name                    = substr(local.prometheus_name, 0, 44)
  target_resource_id      = azurerm_kubernetes_cluster.this[0].id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.prometheus[0].id
  description             = "Association of O4 AKS managed Prometheus data collection rule."
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_container_registry.this[0].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this[0].kubelet_identity[0].object_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "aks_monitoring_metrics_publisher" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_monitor_workspace.this[0].id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_user_assigned_identity.aks[0].principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_dashboard_grafana" "this" {
  count = var.enabled ? 1 : 0

  name                          = var.grafana_name
  resource_group_name           = azurerm_resource_group.this[0].name
  location                      = azurerm_resource_group.this[0].location
  grafana_major_version         = var.grafana_major_version
  api_key_enabled               = false
  public_network_access_enabled = true
  tags                          = var.common_tags

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.this[0].id
  }
}

resource "azurerm_role_assignment" "grafana_identity_monitor_reader" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_monitor_workspace.this[0].id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.this[0].identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "platform_admins_grafana_admin" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_dashboard_grafana.this[0].id
  role_definition_name = "Grafana Admin"
  principal_id         = var.admin_group_object_ids[0]
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "app_operators_grafana_viewer" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_dashboard_grafana.this[0].id
  role_definition_name = "Grafana Viewer"
  principal_id         = var.app_operators_group_id
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "readers_grafana_viewer" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_dashboard_grafana.this[0].id
  role_definition_name = "Grafana Viewer"
  principal_id         = var.readers_group_id
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "platform_admins_monitor_reader" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_monitor_workspace.this[0].id
  role_definition_name = "Monitoring Reader"
  principal_id         = var.admin_group_object_ids[0]
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "app_operators_monitor_reader" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_monitor_workspace.this[0].id
  role_definition_name = "Monitoring Reader"
  principal_id         = var.app_operators_group_id
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "readers_monitor_reader" {
  count = var.enabled ? 1 : 0

  scope                = azurerm_monitor_workspace.this[0].id
  role_definition_name = "Monitoring Reader"
  principal_id         = var.readers_group_id
  principal_type       = "Group"
}

data "azurerm_private_dns_zone" "o5_aks_api" {
  count = var.enabled && var.enable_o5_avd_aks_dns_link ? 1 : 0

  name                = var.o5_aks_private_dns_zone_name
  resource_group_name = var.o5_aks_private_dns_zone_resource_group_name
}

data "azurerm_virtual_network" "o5_avd" {
  count = var.enabled && var.enable_o5_avd_aks_dns_link ? 1 : 0

  name                = var.o5_avd_vnet_name
  resource_group_name = var.o5_avd_vnet_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "o5_avd_aks_api" {
  count = var.enabled && var.enable_o5_avd_aks_dns_link ? 1 : 0

  name                  = "pdnslink-aks-api-to-o5-avd"
  resource_group_name   = data.azurerm_private_dns_zone.o5_aks_api[0].resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.o5_aks_api[0].name
  virtual_network_id    = data.azurerm_virtual_network.o5_avd[0].id
  registration_enabled  = false
  tags                  = var.common_tags
}

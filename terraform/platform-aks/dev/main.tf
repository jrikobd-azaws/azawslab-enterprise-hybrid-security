module "private_aks_platform" {
  source = "../../modules/private-aks-platform"

  enabled = var.enable_o4_private_aks

  location               = var.location
  resource_group_name    = var.aks_resource_group_name
  node_resource_group    = var.aks_node_resource_group_name
  workload_rg_name       = var.workload_resource_group_name
  workload_vnet_name     = var.workload_vnet_name
  aks_subnet_name        = var.aks_subnet_name
  aks_subnet_prefixes    = var.aks_subnet_prefixes
  connectivity_rg_name   = var.connectivity_resource_group_name
  azure_firewall_name    = var.azure_firewall_name
  route_table_name       = var.aks_route_table_name
  aks_name               = var.aks_name
  dns_prefix_private     = var.aks_dns_prefix_private_cluster
  kubernetes_version     = var.kubernetes_version
  node_vm_size           = var.aks_node_vm_size
  system_node_count      = var.aks_system_node_count
  admin_group_object_ids = var.aks_admin_group_object_ids
  app_operators_group_id = var.aks_app_operators_group_object_id
  readers_group_id       = var.aks_readers_group_object_id
  aks_identity_name      = var.aks_identity_name
  acr_name               = var.acr_name
  acr_sku                = var.acr_sku
  monitor_workspace_name = var.monitor_workspace_name
  grafana_name           = var.grafana_name
  grafana_major_version  = var.grafana_major_version
  common_tags            = var.tags

  enable_o5_avd_aks_dns_link                  = var.enable_o5_avd_aks_dns_link
  o5_avd_vnet_resource_group_name             = var.o5_avd_vnet_resource_group_name
  o5_avd_vnet_name                            = var.o5_avd_vnet_name
  o5_aks_private_dns_zone_resource_group_name = var.o5_aks_private_dns_zone_resource_group_name
  o5_aks_private_dns_zone_name                = var.o5_aks_private_dns_zone_name
}
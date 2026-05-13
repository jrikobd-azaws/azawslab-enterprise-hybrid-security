output "aks_cluster_name" {
  value = module.private_aks_platform.aks_cluster_name
}

output "aks_resource_group_name" {
  value = module.private_aks_platform.resource_group_name
}

output "aks_node_resource_group_name" {
  value = module.private_aks_platform.node_resource_group
}

output "aks_private_fqdn" {
  value = module.private_aks_platform.aks_private_fqdn
}

output "acr_login_server" {
  value = module.private_aks_platform.acr_login_server
}

output "monitor_workspace_id" {
  value = module.private_aks_platform.monitor_workspace_id
}

output "grafana_endpoint" {
  value = module.private_aks_platform.grafana_endpoint
}

output "aks_subnet_id" {
  value = module.private_aks_platform.aks_subnet_id
}

output "aks_route_table_id" {
  value = module.private_aks_platform.aks_route_table_id
}

output "aks_workload_identity_oidc_issuer_url" {
  value = module.private_aks_platform.aks_oidc_issuer_url
}

output "aks_app_operators_group_object_id" {
  value = module.private_aks_platform.app_operators_group_id
}

output "aks_readers_group_object_id" {
  value = module.private_aks_platform.readers_group_id
}
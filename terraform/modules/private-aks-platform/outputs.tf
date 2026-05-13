output "resource_group_name" {
  value = try(azurerm_resource_group.this[0].name, null)
}

output "node_resource_group" {
  value = try(azurerm_kubernetes_cluster.this[0].node_resource_group, null)
}

output "aks_cluster_name" {
  value = try(azurerm_kubernetes_cluster.this[0].name, null)
}

output "aks_private_fqdn" {
  value = try(azurerm_kubernetes_cluster.this[0].private_fqdn, null)
}

output "aks_oidc_issuer_url" {
  value = try(azurerm_kubernetes_cluster.this[0].oidc_issuer_url, null)
}

output "acr_login_server" {
  value = try(azurerm_container_registry.this[0].login_server, null)
}

output "monitor_workspace_id" {
  value = try(azurerm_monitor_workspace.this[0].id, null)
}

output "grafana_endpoint" {
  value = try(azurerm_dashboard_grafana.this[0].endpoint, null)
}

output "aks_subnet_id" {
  value = try(azurerm_subnet.aks[0].id, null)
}

output "aks_route_table_id" {
  value = try(azurerm_route_table.aks_egress[0].id, null)
}

output "app_operators_group_id" {
  value = var.app_operators_group_id
}

output "readers_group_id" {
  value = var.readers_group_id
}
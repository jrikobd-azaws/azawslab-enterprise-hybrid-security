output "connectivity_resource_group_name" {
  value = module.hub_spoke_networking.connectivity_resource_group_name
}

output "hub_vnet_name" {
  value = module.hub_spoke_networking.hub_vnet_name
}

output "hub_vnet_id" {
  value = module.hub_spoke_networking.hub_vnet_id
}

output "workload_route_table_id" {
  value = module.hub_spoke_networking.workload_route_table_id
}

output "azure_firewall_id" {
  value = module.hub_spoke_networking.azure_firewall_id
}

output "azure_firewall_private_ip_address" {
  value = module.hub_spoke_networking.azure_firewall_private_ip_address
}

output "azure_firewall_public_ip_id" {
  value = module.hub_spoke_networking.azure_firewall_public_ip_id
}

output "azure_firewall_policy_id" {
  value = module.hub_spoke_networking.azure_firewall_policy_id
}

output "azure_firewall_default_route_id" {
  value = module.hub_spoke_networking.azure_firewall_default_route_id
}

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

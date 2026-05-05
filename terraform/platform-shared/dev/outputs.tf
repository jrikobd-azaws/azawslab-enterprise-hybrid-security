output "generated_local_admin_password" {
  value     = module.security.generated_local_admin_password
  sensitive = true
}

output "defender_for_servers_pricing_id" {
  value = module.security.defender_for_servers_pricing_id
}

output "defender_for_servers_pricing_tier" {
  value = module.security.defender_for_servers_pricing_tier
}

output "defender_for_servers_subplan" {
  value = module.security.defender_for_servers_subplan
}

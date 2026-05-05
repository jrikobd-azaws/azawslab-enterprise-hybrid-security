output "generated_local_admin_password" {
  value     = module.security.generated_local_admin_password
  sensitive = true
}

output "defender_security_contact_id" {
  value = module.security.defender_security_contact_id
}

output "defender_security_contact_email" {
  value = module.security.defender_security_contact_email
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

output "p8_monitoring_resource_group_name" {
  value = module.monitoring.monitoring_resource_group_name
}

output "p8_log_analytics_workspace_id" {
  value = module.monitoring.log_analytics_workspace_id
}

output "p8_log_analytics_workspace_name" {
  value = module.monitoring.log_analytics_workspace_name
}

output "p8_sentinel_onboarding_id" {
  value = module.monitoring.sentinel_onboarding_id
}

output "p8_sentinel_analytics_rule_id" {
  value = module.monitoring.sentinel_analytics_rule_id
}

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

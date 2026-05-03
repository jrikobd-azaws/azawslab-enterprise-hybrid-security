output "generated_local_admin_password" {
  value     = module.security.generated_local_admin_password
  sensitive = true
}

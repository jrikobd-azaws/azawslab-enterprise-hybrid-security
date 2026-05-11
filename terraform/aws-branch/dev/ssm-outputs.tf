output "o3b_ssm_non_secret_parameter_names" {
  description = "O3b non-secret SSM parameter names managed by Terraform."
  value       = module.aws_branch.o3b_ssm_non_secret_parameter_names
}

output "o3b_secure_parameter_names" {
  description = "O3b SecureString parameter names reserved for runtime/manual secret insertion. Values are not managed by Terraform."
  value       = module.aws_branch.o3b_secure_parameter_names
}

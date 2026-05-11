output "o3b_rolesanywhere_trust_anchor_arn" {
  description = "IAM Roles Anywhere trust anchor ARN for O3b management host."
  value       = module.aws_branch.o3b_rolesanywhere_trust_anchor_arn
}

output "o3b_rolesanywhere_profile_arn" {
  description = "IAM Roles Anywhere profile ARN for O3b management host."
  value       = module.aws_branch.o3b_rolesanywhere_profile_arn
}

output "o3b_mgmt_ssm_reader_role_arn" {
  description = "IAM role ARN assumed by O3b management host through IAM Roles Anywhere."
  value       = module.aws_branch.o3b_mgmt_ssm_reader_role_arn
}
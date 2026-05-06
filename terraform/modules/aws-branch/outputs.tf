output "aws_branch_enabled" {
  description = "Whether the AWS branch foundation is enabled."
  value       = var.enable_o3b_aws_branch
}

output "aws_test_vms_enabled" {
  description = "Whether AWS branch test VMs are enabled."
  value       = var.enable_o3b_aws_test_vms
}

output "aws_cisco_enabled" {
  description = "Whether Cisco Catalyst 8000V deployment is enabled."
  value       = var.enable_o3b_aws_cisco
}

output "selected_config" {
  description = "Selected O3b AWS branch configuration. This output is for design validation only."
  value       = local.selected_config
}

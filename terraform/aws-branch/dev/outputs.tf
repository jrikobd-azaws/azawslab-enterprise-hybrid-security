output "aws_branch_enabled" {
  description = "Whether the AWS branch foundation is enabled."
  value       = module.aws_branch.aws_branch_enabled
}

output "aws_test_vms_enabled" {
  description = "Whether AWS branch test VMs are enabled."
  value       = module.aws_branch.aws_test_vms_enabled
}

output "aws_cisco_enabled" {
  description = "Whether Cisco Catalyst 8000V deployment is enabled."
  value       = module.aws_branch.aws_cisco_enabled
}

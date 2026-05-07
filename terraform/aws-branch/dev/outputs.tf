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

output "vpc_id" {
  description = "O3b AWS branch VPC ID."
  value       = module.aws_branch.vpc_id
}

output "trusted_vm_public_ip" {
  description = "Public IP of the trusted test VM."
  value       = module.aws_branch.trusted_vm_public_ip
}

output "dmz_vm_public_ip" {
  description = "Public IP of the DMZ test VM."
  value       = module.aws_branch.dmz_vm_public_ip
}

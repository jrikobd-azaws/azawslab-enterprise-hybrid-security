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

output "vpc_id" {
  description = "O3b AWS branch VPC ID."
  value       = try(aws_vpc.this[0].id, null)
}

output "trusted_vm_public_ip" {
  description = "Trusted test VM public IP."
  value       = try(aws_instance.trusted[0].public_ip, null)
}

output "dmz_vm_public_ip" {
  description = "DMZ test VM public IP."
  value       = try(aws_instance.dmz[0].public_ip, null)
}

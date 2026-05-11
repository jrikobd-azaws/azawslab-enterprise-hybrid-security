output "cisco_ami_id" {
  description = "Cisco Catalyst 8000V AMI ID resolved from AWS Marketplace SSM alias."
  value       = module.aws_branch.cisco_ami_id
}

output "cisco_instance_id" {
  description = "Cisco Catalyst 8000V EC2 instance ID."
  value       = module.aws_branch.cisco_instance_id
}

output "cisco_mgmt_public_ip" {
  description = "Cisco Catalyst 8000V management public IP."
  value       = module.aws_branch.cisco_mgmt_public_ip
}

output "cisco_untrusted_public_ip" {
  description = "Cisco Catalyst 8000V untrusted public IP for future IPSec."
  value       = module.aws_branch.cisco_untrusted_public_ip
}

output "cisco_mgmt_private_ip" {
  description = "Cisco Catalyst 8000V management private IP."
  value       = module.aws_branch.cisco_mgmt_private_ip
}

output "cisco_untrusted_private_ip" {
  description = "Cisco Catalyst 8000V untrusted private IP."
  value       = module.aws_branch.cisco_untrusted_private_ip
}

output "cisco_trusted_private_ip" {
  description = "Cisco Catalyst 8000V trusted private IP."
  value       = module.aws_branch.cisco_trusted_private_ip
}


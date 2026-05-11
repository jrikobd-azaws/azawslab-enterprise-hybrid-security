output "cisco_ami_id" {
  description = "Cisco Catalyst 8000V AMI ID resolved from AWS Marketplace SSM alias."
  value       = try(nonsensitive(data.aws_ssm_parameter.cisco_8000v_ami[0].value), null)
}

output "cisco_instance_id" {
  description = "Cisco Catalyst 8000V EC2 instance ID."
  value       = try(aws_instance.cisco[0].id, null)
}

output "cisco_mgmt_public_ip" {
  description = "Cisco Catalyst 8000V management public IP."
  value       = try(aws_eip.cisco_mgmt[0].public_ip, null)
}

output "cisco_untrusted_public_ip" {
  description = "Cisco Catalyst 8000V untrusted public IP for future IPSec."
  value       = try(aws_eip.cisco_untrusted[0].public_ip, null)
}

output "cisco_mgmt_private_ip" {
  description = "Cisco Catalyst 8000V management private IP."
  value       = try(aws_network_interface.cisco_mgmt[0].private_ip, null)
}

output "cisco_untrusted_private_ip" {
  description = "Cisco Catalyst 8000V untrusted private IP."
  value       = try(aws_network_interface.cisco_untrusted[0].private_ip, null)
}

output "cisco_trusted_private_ip" {
  description = "Cisco Catalyst 8000V trusted private IP."
  value       = try(aws_network_interface.cisco_trusted[0].private_ip, null)
}


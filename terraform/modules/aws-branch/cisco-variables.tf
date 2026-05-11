variable "cisco_instance_type" {
  description = "EC2 instance type for Cisco Catalyst 8000V."
  type        = string
}

variable "cisco_ami_ssm_parameter_name" {
  description = "AWS Marketplace public SSM parameter alias for the Cisco Catalyst 8000V AMI."
  type        = string
}

variable "cisco_mgmt_sg_name" {
  description = "Security group name for Cisco management interface."
  type        = string
}

variable "cisco_untrusted_sg_name" {
  description = "Security group name for Cisco untrusted/public VPN interface."
  type        = string
}

variable "cisco_trusted_sg_name" {
  description = "Security group name for Cisco trusted/private interface."
  type        = string
}

variable "aws_branch_azure_workload_prefix" {
  description = "Azure workload prefix routed from the AWS trusted subnet toward Cisco during O3b/O3c validation."
  type        = string
}

variable "aws_branch_hq_prefix" {
  description = "HQ/on-prem prefix routed from the AWS trusted subnet toward Cisco during O3b/O3c validation."
  type        = string
}

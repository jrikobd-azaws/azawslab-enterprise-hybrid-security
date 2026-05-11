variable "cisco_instance_type" {
  description = "EC2 instance type for Cisco Catalyst 8000V. t3.medium is a lab-safe default and can be overridden for performance testing."
  type        = string
  default     = "t3.medium"
}

variable "cisco_ami_ssm_parameter_name" {
  description = "AWS Marketplace public SSM parameter alias for the Cisco Catalyst 8000V AMI."
  type        = string
  default     = "/aws/service/marketplace/prod-rhyp4n745z2jk/17.12.07b"
}

variable "cisco_mgmt_sg_name" {
  description = "Security group name for Cisco management interface."
  type        = string
  default     = "azawslab-dev-aws-cisco-mgmt-sg"
}

variable "cisco_untrusted_sg_name" {
  description = "Security group name for Cisco untrusted/public VPN interface."
  type        = string
  default     = "azawslab-dev-aws-cisco-untrusted-sg"
}

variable "cisco_trusted_sg_name" {
  description = "Security group name for Cisco trusted/private interface."
  type        = string
  default     = "azawslab-dev-aws-cisco-trusted-sg"
}

variable "aws_branch_azure_workload_prefix" {
  description = "Azure workload prefix routed from the AWS trusted subnet toward Cisco during O3b/O3c validation."
  type        = string
  default     = "10.10.0.0/16"
}

variable "aws_branch_hq_prefix" {
  description = "HQ/on-prem prefix routed from the AWS trusted subnet toward Cisco during O3b/O3c validation."
  type        = string
  default     = "192.168.1.0/24"
}


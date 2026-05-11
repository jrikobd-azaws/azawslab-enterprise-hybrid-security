variable "aws_region" {
  description = "AWS region for the O3b AWS branch lab."
  type        = string
  default     = "eu-west-1"
}

variable "enable_o3b_aws_branch" {
  description = "Controls whether the O3b AWS branch foundation is deployed."
  type        = bool
  default     = false
}

variable "enable_o3b_aws_test_vms" {
  description = "Controls whether O3b AWS branch test VMs are deployed."
  type        = bool
  default     = false
}

variable "enable_o3b_aws_cisco" {
  description = "Controls whether the O3b Cisco Catalyst 8000V NVA is deployed."
  type        = bool
  default     = false
}

variable "ssh_source_cidr" {
  description = "Temporary source CIDR allowed to SSH to AWS test VMs."
  type        = string
  default     = "127.0.0.1/32"
}

variable "key_pair_name" {
  description = "Existing AWS EC2 key pair name for O3b test VMs."
  type        = string
  default     = "kp-dev-aws-branch"
}

variable "test_vm_instance_type" {
  description = "EC2 instance type for O3b AWS test VMs."
  type        = string
  default     = "t3.micro"
}
variable "additional_ssh_source_cidrs" {
  description = "Additional source CIDRs allowed to SSH to the AWS Cisco 8000V management interface, such as the Azure management/Ansible host."
  type        = list(string)
  default     = []
}
variable "enable_o3b_mgmt_rolesanywhere" {
  description = "Enable IAM Roles Anywhere for the Azure management host to retrieve O3b runtime secrets from AWS SSM."
  type        = bool
  default     = false
}

variable "o3b_rolesanywhere_ca_certificate_path" {
  description = "Path to the public CA certificate used by IAM Roles Anywhere trust anchor."
  type        = string
  default     = "certs/o3b-mgmt-ca.crt"
}

variable "o3b_mgmt_rolesanywhere_trust_anchor_name" {
  description = "IAM Roles Anywhere trust anchor name for O3b management host."
  type        = string
  default     = "ta-o3b-az-mgmt-ssm-reader"
}

variable "o3b_mgmt_rolesanywhere_profile_name" {
  description = "IAM Roles Anywhere profile name for O3b management host."
  type        = string
  default     = "prof-o3b-az-mgmt-ssm-reader"
}

variable "o3b_mgmt_ssm_reader_role_name" {
  description = "IAM role name assumed by vm-dev-mgmt-01 through IAM Roles Anywhere."
  type        = string
  default     = "role-o3b-mgmt-ssm-reader"
}

variable "o3b_mgmt_ssm_parameter_arns" {
  description = "Specific AWS SSM parameter ARNs readable by the O3b management host role."
  type        = list(string)
  default     = []
}

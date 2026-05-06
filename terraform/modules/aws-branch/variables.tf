variable "enable_o3b_aws_branch" {
  description = "Controls whether the O3b AWS branch foundation is deployed."
  type        = bool
}

variable "enable_o3b_aws_test_vms" {
  description = "Controls whether O3b AWS branch test VMs are deployed."
  type        = bool
}

variable "enable_o3b_aws_cisco" {
  description = "Controls whether the O3b Cisco Catalyst 8000V NVA is deployed."
  type        = bool
}

variable "aws_region" {
  description = "AWS region for O3b AWS branch resources."
  type        = string
}

variable "vpc_name" {
  description = "Canonical AWS branch VPC name."
  type        = string
}

variable "vpc_cidr" {
  description = "AWS branch VPC CIDR."
  type        = string
}

variable "mgmt_subnet_name" {
  description = "Management subnet name."
  type        = string
}

variable "mgmt_subnet_cidr" {
  description = "Management subnet CIDR."
  type        = string
}

variable "trusted_subnet_name" {
  description = "Trusted subnet name."
  type        = string
}

variable "trusted_subnet_cidr" {
  description = "Trusted subnet CIDR."
  type        = string
}

variable "dmz_subnet_name" {
  description = "DMZ subnet name."
  type        = string
}

variable "dmz_subnet_cidr" {
  description = "DMZ subnet CIDR."
  type        = string
}

variable "untrusted_subnet_name" {
  description = "Untrusted/public subnet name."
  type        = string
}

variable "untrusted_subnet_cidr" {
  description = "Untrusted/public subnet CIDR."
  type        = string
}

variable "cisco_name" {
  description = "Cisco Catalyst 8000V instance name."
  type        = string
}

variable "trusted_vm_name" {
  description = "Trusted segment test VM name."
  type        = string
}

variable "dmz_vm_name" {
  description = "DMZ segment test VM name."
  type        = string
}

variable "key_pair_name" {
  description = "AWS key pair name for O3b branch instances."
  type        = string
}

variable "common_tags" {
  description = "Common AWS tags."
  type        = map(string)
}

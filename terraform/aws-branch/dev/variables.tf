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

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

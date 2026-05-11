variable "enable_o3b_mgmt_rolesanywhere" {
  description = "Enable IAM Roles Anywhere for the Azure management host to retrieve O3b runtime secrets from AWS SSM."
  type        = bool
  default     = false
}

variable "o3b_rolesanywhere_ca_certificate_pem" {
  description = "Public CA certificate PEM used by the IAM Roles Anywhere trust anchor."
  type        = string
  default     = null
  nullable    = true
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
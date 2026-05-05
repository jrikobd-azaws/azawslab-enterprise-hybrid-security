variable "resource_group_name" {
  description = "Resource group name for security resources"
  type        = string
}

variable "location" {
  description = "Azure region for security resources"
  type        = string
}

variable "key_vault_secret_admin_object_ids" {
  description = "Object IDs that should have Key Vault secret administration permissions"
  type        = list(string)
}

variable "defender_security_contact_name" {
  description = "Name of the Defender for Cloud security contact resource."
  type        = string
  default     = "default"
}

variable "defender_security_contact_email" {
  description = "Email address used for Microsoft Defender for Cloud security notifications."
  type        = string
}

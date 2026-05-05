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

variable "defender_for_servers_pricing_tier" {
  description = "Microsoft Defender for Servers pricing tier. Use Standard to enable, or Free to disable."
  type        = string
  default     = "Standard"
}

variable "defender_for_servers_subplan" {
  description = "Microsoft Defender for Servers subplan. P1 is lower-cost than P2 and is used for P7 validation."
  type        = string
  default     = "P1"
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

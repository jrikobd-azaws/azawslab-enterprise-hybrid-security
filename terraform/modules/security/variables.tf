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

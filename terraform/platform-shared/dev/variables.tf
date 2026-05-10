variable "enable_p9b_backup" {
  description = "Controls whether P9b Recovery Services Vault, backup policy, and protected VM resources are deployed."
  type        = bool
  default     = false
}

variable "enable_key_vault_private_endpoint" {
  description = "Controls whether a Private Endpoint and Private DNS integration are created for the shared Key Vault."
  type        = bool
  default     = false
}

variable "key_vault_private_endpoint_name" {
  description = "Name of the Key Vault Private Endpoint."
  type        = string
  default     = "pe-kvdevazawsne01-norwayeast-01"
}

variable "key_vault_private_dns_zone_name" {
  description = "Private DNS zone name for Azure Key Vault Private Link."
  type        = string
  default     = "privatelink.vaultcore.azure.net"
}

variable "key_vault_private_dns_link_name" {
  description = "Name of the Private DNS VNet link for Key Vault."
  type        = string
  default     = "pdnslink-kv-spoke-workload-norwayeast-01"
}

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

variable "key_vault_private_endpoint_subnet_id" {
  description = "Subnet ID where the Key Vault Private Endpoint should be placed."
  type        = string
  default     = null
}

variable "key_vault_private_dns_vnet_id" {
  description = "VNet ID linked to the Key Vault Private DNS zone."
  type        = string
  default     = null
}

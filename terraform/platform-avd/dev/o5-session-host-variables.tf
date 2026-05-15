variable "enable_o5_session_host" {
  description = "Controls deployment of the first O5 AVD session host."
  type        = bool
  default     = false
}

variable "o5_session_host_name" {
  description = "Name of the first O5 AVD session host VM."
  type        = string
  default     = "vm-dev-avd-01"
}

variable "o5_session_host_nic_name" {
  description = "Name of the first O5 AVD session host NIC."
  type        = string
  default     = "nic-vm-dev-avd-01-01"
}

variable "o5_session_host_vm_size" {
  description = "VM size for the first O5 AVD session host. Deployed zoneless for North Europe SKU compatibility."
  type        = string
  default     = "Standard_D2s_v4"
}

variable "o5_session_host_admin_username" {
  description = "Local administrator username required by Azure VM creation. Day-to-day access uses Entra login."
  type        = string
  default     = "azureuser"
}

variable "o5_session_host_image_publisher" {
  description = "Windows desktop image publisher for the O5 AVD session host."
  type        = string
  default     = "MicrosoftWindowsDesktop"
}

variable "o5_session_host_image_offer" {
  description = "Windows desktop image offer for the O5 AVD session host."
  type        = string
  default     = "windows-11"
}

variable "o5_session_host_image_sku" {
  description = "Windows 11 AVD image SKU for the O5 AVD session host."
  type        = string
  default     = "win11-24h2-avd"
}

variable "o5_session_host_image_version" {
  description = "Windows image version for the O5 AVD session host."
  type        = string
  default     = "latest"
}

variable "o5_session_host_registration_expiration_date" {
  description = "Temporary AVD host pool registration token expiration date for first session host deployment."
  type        = string
  default     = "2026-05-22T00:22:40Z"
}

variable "o5_session_host_admin_password_key_vault_name" {
  description = "Existing Key Vault containing the local admin password secret."
  type        = string
  default     = "kvdevazawsne01"
}

variable "o5_session_host_admin_password_key_vault_resource_group_name" {
  description = "Resource group containing the existing Key Vault for the local admin password secret."
  type        = string
  default     = "rg-dev-security-norwayeast"
}

variable "o5_session_host_admin_password_secret_name" {
  description = "Existing Key Vault secret name for the local admin password."
  type        = string
  default     = "local-admin-password"
}
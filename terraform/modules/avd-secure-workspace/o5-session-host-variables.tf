variable "enable_session_host" {
  description = "Controls deployment of the first O5 AVD session host."
  type        = bool
  default     = false
}

variable "session_host_name" {
  description = "Name of the first O5 AVD session host VM."
  type        = string
  default     = "vm-dev-avd-01"
}

variable "session_host_nic_name" {
  description = "Name of the first O5 AVD session host NIC."
  type        = string
  default     = "nic-vm-dev-avd-01-01"
}

variable "session_host_vm_size" {
  description = "VM size for the first O5 AVD session host."
  type        = string
  default     = "Standard_D2s_v4"
}

variable "session_host_admin_username" {
  description = "Local administrator username required by Azure VM creation."
  type        = string
  default     = "azureuser"
}

variable "session_host_image_publisher" {
  description = "Windows desktop image publisher."
  type        = string
  default     = "MicrosoftWindowsDesktop"
}

variable "session_host_image_offer" {
  description = "Windows desktop image offer."
  type        = string
  default     = "windows-11"
}

variable "session_host_image_sku" {
  description = "Windows 11 AVD image SKU."
  type        = string
  default     = "win11-24h2-avd"
}

variable "session_host_image_version" {
  description = "Windows desktop image version."
  type        = string
  default     = "latest"
}

variable "session_host_registration_expiration_date" {
  description = "Temporary AVD host pool registration token expiration date."
  type        = string
}

variable "session_host_admin_password_key_vault_name" {
  description = "Existing Key Vault containing the local admin password secret."
  type        = string
}

variable "session_host_admin_password_key_vault_resource_group" {
  description = "Resource group containing the existing Key Vault."
  type        = string
}

variable "session_host_admin_password_secret_name" {
  description = "Existing Key Vault secret name for the local admin password."
  type        = string
}
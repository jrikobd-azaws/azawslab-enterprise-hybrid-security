variable "management_ssh_public_key" {
  type        = string
  description = "SSH public key for the temporary Linux management host"
}
variable "enable_a2_awx" {
  description = "Controls creation of the A2 AWX automation control plane VM."
  type        = bool
  default     = false
}

variable "awx_vm_name" {
  description = "Name of the A2 AWX automation control plane VM."
  type        = string
  default     = "vm-dev-awx-01"
}

variable "awx_vm_size" {
  description = "Azure VM SKU for the A2 AWX VM. Must remain within approved policy."
  type        = string
  default     = "Standard_D2s_v4"

  validation {
    condition     = contains(["Standard_B2s", "Standard_D2s_v4"], var.awx_vm_size)
    error_message = "A2 AWX VM size must be one of the policy-approved AWX recovery SKUs: Standard_B2s or Standard_D2s_v4."
  }
}

variable "awx_admin_username" {
  description = "Admin username for the A2 AWX VM."
  type        = string
  default     = "azureuser"
}

variable "awx_ssh_public_key" {
  description = "Optional SSH public key for the A2 AWX VM. Defaults to management_ssh_public_key when null."
  type        = string
  default     = null
}

variable "awx_os_disk_size_gb" {
  description = "OS disk size in GB for the A2 AWX VM."
  type        = number
  default     = 64
}

variable "a2_key_vault_name" {
  description = "Shared Key Vault name for A2 runtime secrets."
  type        = string
  default     = "kvdevazawsne01"
}

variable "a2_key_vault_resource_group_name" {
  description = "Resource group containing the shared Key Vault for A2 runtime secrets."
  type        = string
  default     = "rg-dev-security-norwayeast"
}

variable "a2_key_vault_auth_model" {
  description = "Key Vault authorization model for AWX VM. Supported values: access_policy, rbac."
  type        = string
  default     = "access_policy"

  validation {
    condition     = contains(["access_policy", "rbac"], var.a2_key_vault_auth_model)
    error_message = "a2_key_vault_auth_model must be access_policy or rbac."
  }
}

variable "a2_key_vault_rbac_role_definition_name" {
  description = "Azure RBAC role used when a2_key_vault_auth_model is rbac."
  type        = string
  default     = "Key Vault Secrets User"
}


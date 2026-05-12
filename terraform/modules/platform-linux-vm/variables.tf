variable "vm_name" {
  description = "Azure Linux VM resource name."
  type        = string
}

variable "computer_name" {
  description = "Linux hostname. Defaults to a shortened VM name."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Resource group where the VM resources are created."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the VM network interface."
  type        = string
}

variable "network_interface_name" {
  description = "Optional NIC name. Defaults to nic-<vm_name>-01."
  type        = string
  default     = null
}

variable "private_ip_address_allocation" {
  description = "Private IP allocation mode."
  type        = string
  default     = "Dynamic"

  validation {
    condition     = contains(["Dynamic", "Static"], var.private_ip_address_allocation)
    error_message = "private_ip_address_allocation must be Dynamic or Static."
  }
}

variable "private_ip_address" {
  description = "Static private IP address when private_ip_address_allocation is Static."
  type        = string
  default     = null
}

variable "create_public_ip" {
  description = "Whether to create and attach a public IP."
  type        = bool
  default     = false
}

variable "public_ip_name" {
  description = "Optional public IP name."
  type        = string
  default     = null
}

variable "public_ip_allocation_method" {
  description = "Public IP allocation method."
  type        = string
  default     = "Static"
}

variable "public_ip_sku" {
  description = "Public IP SKU."
  type        = string
  default     = "Standard"
}

variable "vm_size" {
  description = "Azure VM SKU."
  type        = string
  default     = "Standard_B2als_v2"
}

variable "admin_username" {
  description = "Local Linux admin username."
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key for Linux admin access."
  type        = string

  validation {
    condition     = try(length(trimspace(var.admin_ssh_public_key)) > 0, false)
    error_message = "admin_ssh_public_key must not be empty."
  }
}

variable "identity_type" {
  description = "Optional managed identity type, for example SystemAssigned."
  type        = string
  default     = null
}

variable "identity_ids" {
  description = "Optional user-assigned identity IDs when identity_type includes UserAssigned."
  type        = list(string)
  default     = null
}

variable "custom_data" {
  description = "Optional base64-encoded custom data for cloud-init."
  type        = string
  default     = null
}

variable "os_disk_caching" {
  description = "OS disk caching mode."
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "OS disk storage account type."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB."
  type        = number
  default     = 64
}

variable "source_image_publisher" {
  description = "Linux image publisher."
  type        = string
  default     = "Canonical"
}

variable "source_image_offer" {
  description = "Linux image offer."
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_sku" {
  description = "Linux image SKU."
  type        = string
  default     = "22_04-lts-gen2"
}

variable "source_image_version" {
  description = "Linux image version."
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "Mandatory Azure tags."
  type        = map(string)

  validation {
    condition = alltrue([
      for tag_key in [
        "Environment",
        "Project",
        "Owner",
        "CostCenter",
        "DeploymentMethod"
      ] : contains(keys(var.tags), tag_key)
    ])
    error_message = "tags must include Environment, Project, Owner, CostCenter, and DeploymentMethod."
  }
}

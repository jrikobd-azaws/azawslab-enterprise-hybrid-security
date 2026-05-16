variable "enable_o5_avd" {
  description = "Controls deployment of the O5 AVD and FSLogix foundation."
  type        = bool
  default     = false
}

variable "location" {
  description = "Primary Azure region for the O5 AVD secure admin/dev workspace."
  type        = string
  default     = "northeurope"
}

variable "paired_location" {
  description = "Approved alternate Europe region for O5 backup, DR, and future AVD resiliency design."
  type        = string
  default     = "westeurope"
}

variable "common_tags" {
  description = "Release 2 mandatory common tags."
  type        = map(string)

  default = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

variable "resource_group_name" {
  description = "O5 AVD resource group name."
  type        = string
  default     = "rg-dev-avd-northeurope"
}

variable "avd_vnet_name" {
  description = "O5 AVD spoke VNet name."
  type        = string
  default     = "vnet-dev-northeurope-spoke-avd"
}

variable "avd_vnet_address_space" {
  description = "O5 AVD spoke VNet address space."
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "avd_subnet_name" {
  description = "O5 AVD session-host subnet name."
  type        = string
  default     = "snet-avd"
}

variable "avd_subnet_address_prefixes" {
  description = "O5 AVD session-host subnet prefixes."
  type        = list(string)
  default     = ["10.2.1.0/24"]
}

variable "private_endpoint_subnet_name" {
  description = "O5 private endpoint subnet name."
  type        = string
  default     = "snet-avd-private-endpoints"
}

variable "private_endpoint_subnet_address_prefixes" {
  description = "O5 private endpoint subnet prefixes."
  type        = list(string)
  default     = ["10.2.2.0/27"]
}

variable "route_table_name" {
  description = "O5 AVD route table name."
  type        = string
  default     = "rt-avd-to-hub-northeurope"
}

variable "azure_firewall_private_ip_address" {
  description = "Azure Firewall private IP address used as O5 AVD default egress next hop."
  type        = string
  default     = "10.0.1.4"
}

variable "host_pool_name" {
  description = "O5 AVD host pool name."
  type        = string
  default     = "vdpool-dev-northeurope"
}

variable "workspace_name" {
  description = "O5 AVD workspace name."
  type        = string
  default     = "vdws-dev-northeurope"
}

variable "desktop_app_group_name" {
  description = "O5 AVD desktop application group name."
  type        = string
  default     = "vdag-dev-northeurope"
}

variable "fslogix_storage_account_name" {
  description = "O5 FSLogix Azure Files storage account name."
  type        = string
  default     = "stdevavdfsneu01"
}

variable "fslogix_storage_replication_type" {
  description = "Replication type for O5 FSLogix storage."
  type        = string
  default     = "ZRS"
}

variable "fslogix_share_name" {
  description = "O5 FSLogix file share name."
  type        = string
  default     = "fslogix-profiles"
}

variable "fslogix_share_quota_gb" {
  description = "O5 FSLogix file share quota in GB."
  type        = number
  default     = 100
}
variable "enable_o5_o6_private_routes" {
  description = "Controls O5/O6 explicit private routes from the AVD subnet to Azure admin, HQ, and AWS trusted destinations."
  type        = bool
  default     = false
}

variable "o5_o6_azure_platform_admin_prefix" {
  description = "Azure platform/admin destination prefix reached from O5 AVD through Azure Firewall."
  type        = string
  default     = "10.10.0.0/16"
}

variable "o5_o6_hq_prefix" {
  description = "HQ destination prefix reached from O5 AVD through FortiGate."
  type        = string
  default     = "192.168.1.0/24"
}

variable "o5_o6_aws_trusted_prefix" {
  description = "AWS trusted destination prefix reached from O5 AVD through FortiGate."
  type        = string
  default     = "172.16.1.0/24"
}

variable "o5_o6_fortigate_private_ip_address" {
  description = "FortiGate private next-hop IP for O5/O6 HQ and AWS trusted private routes."
  type        = string
  default     = "10.0.3.4"
}

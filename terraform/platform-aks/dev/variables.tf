variable "enable_o4_private_aks" {
  description = "Controls deployment of the complete O4 private AKS platform stack."
  type        = bool
  default     = false
}

variable "location" {
  description = "Azure region for O4 private AKS platform resources."
  type        = string
  default     = "norwayeast"
}

variable "aks_resource_group_name" {
  description = "Resource group for O4 private AKS platform resources."
  type        = string
  default     = "rg-dev-aks-norwayeast"
}

variable "aks_node_resource_group_name" {
  description = "AKS-managed node resource group."
  type        = string
  default     = "rg-dev-aks-nodes-norwayeast"
}

variable "workload_resource_group_name" {
  description = "Existing workload spoke resource group."
  type        = string
  default     = "rg-dev-workload-norwayeast"
}

variable "workload_vnet_name" {
  description = "Existing workload spoke VNet."
  type        = string
  default     = "vnet-dev-norwayeast-spoke-workload"
}

variable "aks_subnet_name" {
  description = "O4 AKS node subnet name."
  type        = string
  default     = "snet-aks-nodes-dev-norwayeast"
}

variable "aks_subnet_prefixes" {
  description = "O4 AKS node subnet CIDR."
  type        = list(string)
  default     = ["10.10.2.0/24"]
}

variable "connectivity_resource_group_name" {
  description = "Existing connectivity resource group containing Azure Firewall."
  type        = string
  default     = "rg-connectivity-prod-norwayeast"
}

variable "azure_firewall_name" {
  description = "Existing Azure Firewall used for O4 AKS egress."
  type        = string
  default     = "afw-dev-norwayeast-01"
}

variable "aks_name" {
  description = "O4 private AKS cluster name."
  type        = string
  default     = "aks-dev-norwayeast-01"
}

variable "aks_dns_prefix_private_cluster" {
  description = "Private DNS prefix for the O4 private AKS cluster."
  type        = string
  default     = "aks-dev-ne-o4"
}

variable "kubernetes_version" {
  description = "Pinned AKS Kubernetes version validated in Norway East."
  type        = string
  default     = "1.34.6"
}

variable "aks_node_vm_size" {
  description = "O4 AKS system node pool VM size."
  type        = string
  default     = "Standard_D2s_v4"
}

variable "aks_system_node_count" {
  description = "O4 AKS system node count."
  type        = number
  default     = 1
}

variable "aks_admin_group_object_ids" {
  description = "Microsoft Entra group object IDs with AKS admin access."
  type        = list(string)
  default     = ["f2607c9e-74e3-4575-be31-696b23535bcc"]
}

variable "aks_app_operators_group_object_id" {
  description = "Microsoft Entra group object ID for future prod-workload namespace operator RBAC."
  type        = string
  default     = "5e4974b4-4d25-4e18-9f73-7f65557af0d1"
}

variable "aks_readers_group_object_id" {
  description = "Microsoft Entra group object ID for future read-only AKS/namespace validation RBAC."
  type        = string
  default     = "6a628503-dd45-4086-825e-7623ce525989"
}

variable "aks_identity_name" {
  description = "User-assigned managed identity for O4 AKS."
  type        = string
  default     = "id-aks-dev-norwayeast-01"
}

variable "acr_name" {
  description = "O4 Azure Container Registry name."
  type        = string
  default     = "acrdevazawsne01"
}

variable "acr_sku" {
  description = "O4 ACR SKU."
  type        = string
  default     = "Standard"
}

variable "monitor_workspace_name" {
  description = "Azure Monitor workspace for O4 managed Prometheus."
  type        = string
  default     = "amw-dev-aks-norwayeast-01"
}

variable "grafana_name" {
  description = "Azure Managed Grafana workspace for O4."
  type        = string
  default     = "amg-dev-aks-ne-01"
}

variable "grafana_major_version" {
  description = "Major version for Azure Managed Grafana. Version 11 is selected for provider compatibility and O4 stability."
  type        = string
  default     = "11"

  validation {
    condition     = contains(["11", "12"], var.grafana_major_version)
    error_message = "grafana_major_version must be 11 or 12."
  }
}
variable "aks_route_table_name" {
  description = "Route table for O4 AKS UDR egress through Azure Firewall."
  type        = string
  default     = "rt-aks-egress-dev-norwayeast"
}

variable "tags" {
  description = "Common Release 2 tags."
  type        = map(string)

  default = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
    Phase            = "O4"
  }
}
variable "enable_o5_avd_aks_dns_link" {
  description = "Controls whether O4 AKS private API DNS is linked to the O5 AVD VNet for private kubectl validation from AVD."
  type        = bool
  default     = false
}

variable "o5_avd_vnet_resource_group_name" {
  description = "Resource group containing the O5 AVD spoke VNet."
  type        = string
  default     = "rg-dev-avd-northeurope"
}

variable "o5_avd_vnet_name" {
  description = "O5 AVD spoke VNet that requires private DNS resolution for the O4 AKS API."
  type        = string
  default     = "vnet-dev-northeurope-spoke-avd"
}

variable "o5_aks_private_dns_zone_resource_group_name" {
  description = "Resource group containing the AKS system-managed private DNS zone."
  type        = string
  default     = "rg-dev-aks-nodes-norwayeast"
}

variable "o5_aks_private_dns_zone_name" {
  description = "AKS system-managed private DNS zone name for the O4 private AKS API."
  type        = string
  default     = "2dbfb1a5-7a41-46f9-9960-bf90f9702ca1.privatelink.norwayeast.azmk8s.io"
}

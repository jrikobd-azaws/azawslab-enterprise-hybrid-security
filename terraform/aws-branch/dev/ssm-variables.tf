variable "enable_o3b_ssm_parameters" {
  description = "Controls whether O3b non-secret AWS SSM Parameter Store values are managed by Terraform."
  type        = bool
  default     = false
}

variable "o3b_ssm_parameter_prefix" {
  description = "Hierarchical SSM Parameter Store prefix for O3b metadata."
  type        = string
  default     = "/azawslab/release2/o3b"
}

variable "azure_vpn_gateway_public_ip" {
  description = "Azure VPN Gateway public IP used for the O3b Cisco-to-Azure VPN target."
  type        = string
  default     = "20.100.50.9"
}

variable "azure_vpn_gateway_asn" {
  description = "Azure VPN Gateway BGP ASN for O3b/O3c transit."
  type        = number
  default     = 65515
}

variable "hq_vyos_bgp_asn" {
  description = "VyOS HQ/on-prem BGP ASN used in the O3b/O3c routing design."
  type        = number
  default     = 65001
}

variable "cisco_bgp_asn" {
  description = "Cisco Catalyst 8000V AWS branch BGP ASN."
  type        = number
  default     = 65002
}

variable "advertised_prefix_trusted" {
  description = "Trusted AWS subnet prefix intended to be advertised over BGP during O3b selective validation."
  type        = string
  default     = "172.16.1.0/24"
}

variable "advertised_prefix_dmz" {
  description = "DMZ AWS subnet prefix intentionally not advertised during first O3b selective BGP validation."
  type        = string
  default     = "172.16.2.0/24"
}

variable "advertise_trusted_prefix" {
  description = "Whether the trusted AWS subnet should be advertised during O3b selective BGP validation."
  type        = bool
  default     = true
}

variable "advertise_dmz_prefix" {
  description = "Whether the DMZ AWS subnet should be advertised during O3b selective BGP validation."
  type        = bool
  default     = false
}

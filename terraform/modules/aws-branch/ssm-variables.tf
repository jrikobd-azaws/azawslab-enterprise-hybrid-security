variable "enable_o3b_ssm_parameters" {
  description = "Controls whether O3b non-secret AWS SSM Parameter Store values are managed by Terraform."
  type        = bool
}

variable "o3b_ssm_parameter_prefix" {
  description = "Hierarchical SSM Parameter Store prefix for O3b metadata."
  type        = string
}

variable "azure_vpn_gateway_public_ip" {
  description = "Azure VPN Gateway public IP used for the O3b Cisco-to-Azure VPN target."
  type        = string
}

variable "azure_vpn_gateway_asn" {
  description = "Azure VPN Gateway BGP ASN for O3b/O3c transit."
  type        = number
}

variable "hq_vyos_bgp_asn" {
  description = "VyOS HQ/on-prem BGP ASN used in the O3b/O3c routing design."
  type        = number
}

variable "cisco_bgp_asn" {
  description = "Cisco Catalyst 8000V AWS branch BGP ASN."
  type        = number
}

variable "advertised_prefix_trusted" {
  description = "Trusted AWS subnet prefix intended to be advertised over BGP during O3b selective validation."
  type        = string
}

variable "advertised_prefix_dmz" {
  description = "DMZ AWS subnet prefix intentionally not advertised during first O3b selective BGP validation."
  type        = string
}

variable "advertise_trusted_prefix" {
  description = "Whether the trusted AWS subnet should be advertised during O3b selective BGP validation."
  type        = bool
}

variable "advertise_dmz_prefix" {
  description = "Whether the DMZ AWS subnet should be advertised during O3b selective BGP validation."
  type        = bool
}

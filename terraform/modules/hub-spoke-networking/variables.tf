variable "connectivity_resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "hub_address_space" {
  type = list(string)
}

variable "bastion_subnet_prefixes" {
  type = list(string)
}

variable "firewall_subnet_prefixes" {
  type = list(string)
}

variable "gateway_subnet_prefixes" {
  type = list(string)
}

variable "workload_spoke_vnet_id" {
  type = string
}

variable "workload_spoke_vnet_name" {
  type = string
}

variable "workload_spoke_resource_group_name" {
  type = string
}

variable "workload_subnet_id" {
  type = string
}

variable "hub_to_spoke_peering_name" {
  type = string
}

variable "spoke_to_hub_peering_name" {
  type = string
}

variable "workload_route_table_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "enable_azure_firewall" {
  description = "Controls whether the ephemeral Azure Firewall resources are deployed for validation."
  type        = bool
  default     = false
}

variable "azure_firewall_name" {
  description = "Name of the Azure Firewall instance."
  type        = string
  default     = "afw-dev-norwayeast-01"
}

variable "azure_firewall_public_ip_name" {
  description = "Name of the Azure Firewall public IP address."
  type        = string
  default     = "pip-azfw-norwayeast-01"
}

variable "azure_firewall_policy_name" {
  description = "Name of the Azure Firewall Policy."
  type        = string
  default     = "afwp-dev-norwayeast"
}

variable "azure_firewall_route_name" {
  description = "Name of the workload default route that sends internet-bound traffic to Azure Firewall."
  type        = string
  default     = "route-default-to-azure-firewall"
}

variable "enable_bastion" {
  description = "Controls whether the ephemeral Azure Bastion host is deployed for validation or operational access."
  type        = bool
  default     = false
}

variable "bastion_host_name" {
  description = "Name of the Azure Bastion host."
  type        = string
  default     = "bas-dev-norwayeast-01"
}

variable "bastion_public_ip_name" {
  description = "Name of the Azure Bastion public IP address."
  type        = string
  default     = "pip-bas-dev-norwayeast-01"
}

variable "enable_o1_fortigate_service_chain" {
  description = "Controls whether the O1 lab service-chain route steers HQ traffic from the workload subnet to the FortiGate trusted interface."
  type        = bool
  default     = false
}

variable "o1_service_chain_route_name" {
  description = "Name of the O1 workload route that steers HQ traffic to FortiGate for inspection validation."
  type        = string
  default     = "route-o1-hq-via-fortigate"
}

variable "o1_service_chain_hq_prefix" {
  description = "HQ/on-prem prefix steered to FortiGate during O1 service-chain validation."
  type        = string
  default     = "192.168.1.0/24"
}

variable "o1_service_chain_next_hop_ip" {
  description = "FortiGate trusted interface IP used as the Azure UDR next hop for O1 service-chain validation."
  type        = string
  default     = "10.0.3.36"
}

variable "enable_p5_gateway_ingress_fortigate" {
  description = "Controls whether GatewaySubnet ingress traffic to the workload subnet is steered through FortiGate port1 for symmetric HQ-to-Azure inspection."
  type        = bool
  default     = false
}

variable "p5_gateway_ingress_route_table_name" {
  description = "Name of the GatewaySubnet route table used for FortiGate ingress symmetry."
  type        = string
  default     = "rt-dev-gateway-ingress-fgt-norwayeast"
}

variable "p5_gateway_ingress_route_name" {
  description = "Name of the GatewaySubnet route steering workload subnet ingress traffic to FortiGate port1."
  type        = string
  default     = "route-snet-workload-via-fgt-port1"
}

variable "p5_gateway_ingress_workload_prefix" {
  description = "Workload subnet prefix steered from GatewaySubnet to FortiGate port1."
  type        = string
  default     = "10.10.0.0/24"
}

variable "p5_gateway_ingress_fortigate_port1_ip" {
  description = "FortiGate port1 IP used as the GatewaySubnet ingress next hop."
  type        = string
  default     = "10.0.3.4"
}
variable "enable_o5_avd_egress" {
  description = "Controls whether O5 Azure Virtual Desktop egress readiness rules are enabled in the Azure Firewall policy."
  type        = bool
  default     = false
}

variable "o5_avd_source_addresses" {
  description = "Source CIDR ranges for O5 AVD session host outbound egress through Azure Firewall."
  type        = list(string)
  default     = ["10.2.0.0/16"]
}
variable "enable_o5_o6_private_admin_transit" {
  description = "Controls O5/O6 private admin transit readiness for AVD to AWX, AKS API, management, and hybrid return path."
  type        = bool
  default     = false
}

variable "o5_gateway_ingress_avd_route_name" {
  description = "Name of the GatewaySubnet route steering O5 AVD return traffic through FortiGate port1."
  type        = string
  default     = "route-o5-avd-via-fgt-port1"
}

variable "o5_gateway_ingress_avd_prefix" {
  description = "O5 AVD CIDR that must return through FortiGate from VPN/HQ/AWS paths."
  type        = string
  default     = "10.2.0.0/16"
}

variable "o5_o6_admin_source_addresses" {
  description = "Approved O5/O6 private admin source CIDRs."
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "o5_o6_awx_private_ip" {
  description = "AWX private IP reachable from O5 AVD."
  type        = string
  default     = "10.10.1.5"
}

variable "o5_o6_awx_nodeport_ports" {
  description = "AWX private UI ports reachable from O5 AVD."
  type        = list(string)
  default     = ["32625"]
}

variable "o5_o6_mgmt_private_ip" {
  description = "Management/Ansible VM private IP reachable from O5 AVD."
  type        = string
  default     = "10.10.1.4"
}

variable "o5_o6_mgmt_ssh_ports" {
  description = "Management/Ansible VM private SSH ports reachable from O5 AVD."
  type        = list(string)
  default     = ["22"]
}

variable "o5_o6_aks_api_private_ip" {
  description = "O4 private AKS API private IP reachable from O5 AVD."
  type        = string
  default     = "10.10.2.4"
}

variable "o5_o6_aks_api_ports" {
  description = "O4 private AKS API ports reachable from O5 AVD."
  type        = list(string)
  default     = ["443"]
}
variable "enable_o5_avd_toolchain_egress" {
  description = "Controls O5 AVD approved admin/dev toolchain egress through Azure Firewall."
  type        = bool
  default     = false
}

variable "o5_avd_toolchain_source_addresses" {
  description = "Source CIDR ranges allowed to use O5 AVD approved admin/dev toolchain egress."
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "o5_avd_toolchain_microsoft_fqdns" {
  description = "Microsoft and VS Code FQDNs required for approved O5 AVD toolchain bootstrap and admin use."
  type        = list(string)
  default = [
    "aka.ms",
    "go.microsoft.com",
    "download.microsoft.com",
    "download.visualstudio.microsoft.com",
    "update.code.visualstudio.com",
    "code.visualstudio.com",
    "vscode.download.prss.microsoft.com",
    "packages.microsoft.com",
    "azcliprod.blob.core.windows.net",
    "learn.microsoft.com",
    "docs.microsoft.com",
    "portal.azure.com",
    "graph.microsoft.com"
  ]
}

variable "o5_avd_toolchain_github_fqdns" {
  description = "GitHub FQDNs required for approved O5 AVD toolchain release downloads."
  type        = list(string)
  default = [
    "github.com",
    "api.github.com",
    "objects.githubusercontent.com",
    "github-releases.githubusercontent.com",
    "*.githubusercontent.com"
  ]
}

variable "o5_avd_toolchain_vendor_fqdns" {
  description = "Approved vendor FQDNs required for kubectl, Helm, Terraform, AWS CLI, and related admin tooling."
  type        = list(string)
  default = [
    "dl.k8s.io",
    "cdn.dl.k8s.io",
    "get.helm.sh",
    "releases.hashicorp.com",
    "registry.terraform.io",
    "awscli.amazonaws.com"
  ]
}

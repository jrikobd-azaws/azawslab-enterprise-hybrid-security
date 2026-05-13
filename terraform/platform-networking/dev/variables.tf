variable "enable_azure_firewall" {
  description = "Controls whether Azure Firewall is enabled for O4 private AKS and cloud egress validation."
  type        = bool
  default     = false
}
variable "enable_o1_fortigate_service_chain" {
  description = "Controls whether O1 service-chain UDR is enabled for workload-to-HQ traffic via FortiGate."
  type        = bool
  default     = false
}

variable "o1_service_chain_route_name" {
  description = "Name of the O1 workload route that steers HQ traffic to FortiGate."
  type        = string
  default     = "route-o1-hq-via-fortigate"
}

variable "o1_service_chain_hq_prefix" {
  description = "HQ/on-prem prefix steered to FortiGate during O1 service-chain validation."
  type        = string
  default     = "192.168.1.0/24"
}

variable "o1_service_chain_next_hop_ip" {
  description = "FortiGate trusted interface IP used as the Azure UDR next hop."
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

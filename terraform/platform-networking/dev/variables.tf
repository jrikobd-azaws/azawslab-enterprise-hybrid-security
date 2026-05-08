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

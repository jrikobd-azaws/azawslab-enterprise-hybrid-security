variable "enable_p5_fortigate" {
  type    = bool
  default = false
  description = "Enable FortiGate VM deployment"
}

variable "enable_p5_vpn" {
  type    = bool
  default = false
  description = "Enable VPN Gateway + Connection deployment"
}

variable "vpn_psk" {
  type    = string
  default = ""
  description = "IPSec pre-shared key for VyOS lab"
}

variable "vpn_peer_dns" {
  type    = string
  default = ""
  description = "Public DNS of VyOS lab (vyos01.hq.azawslab.co.uk)"
}

# -----------------------------
# FortiGate VM (Hub Subnet)
# -----------------------------
resource "azurerm_linux_virtual_machine" "fortigate_vm" {
  count               = var.enable_p5_fortigate ? 1 : 0
  name                = "fg-az-hub01"
  resource_group_name = module.hub_spoke_networking.hub_rg_name
  location            = module.hub_spoke_networking.hub_location
  size                = "Standard_B2s"
  admin_username      = "fortiadmin"
  admin_password      = "CHANGE_ME_SECURE"
  network_interface_ids = [
    azurerm_network_interface.fortigate_nic[0].id
  ]
}

resource "azurerm_network_interface" "fortigate_nic" {
  count               = var.enable_p5_fortigate ? 1 : 0
  name                = "nic-fg-hub01"
  location            = module.hub_spoke_networking.hub_location
  resource_group_name = module.hub_spoke_networking.hub_rg_name
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.hub_spoke_networking.hub_firewall_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# -----------------------------
# VPN Gateway (Hub)
# -----------------------------
resource "azurerm_virtual_network_gateway" "hub_vpn_gw" {
  count                = var.enable_p5_vpn ? 1 : 0
  name                 = "hub-vpn-gw"
  location             = module.hub_spoke_networking.hub_location
  resource_group_name  = module.hub_spoke_networking.hub_rg_name
  type                 = "Vpn"
  vpn_type             = "RouteBased"
  active_active        = false
  sku                  = "VpnGw1"
  ip_configuration {
    name                = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.vpn_gw_pub[0].id
    subnet_id           = module.hub_spoke_networking.gateway_subnet_id
  }
}

resource "azurerm_public_ip" "vpn_gw_pub" {
  count               = var.enable_p5_vpn ? 1 : 0
  name                = "vpn-gw-pub"
  location            = module.hub_spoke_networking.hub_location
  resource_group_name = module.hub_spoke_networking.hub_rg_name
  allocation_method   = "Dynamic"
}

# -----------------------------
# Local Network Gateway (VyOS)
# -----------------------------
resource "azurerm_local_network_gateway" "vyos_peer" {
  count               = var.enable_p5_vpn ? 1 : 0
  name                = "vyos-lng"
  location            = module.hub_spoke_networking.hub_location
  resource_group_name = module.hub_spoke_networking.hub_rg_name
  gateway_address     = var.vpn_peer_dns
  address_space       = ["192.168.1.0/24"]
}

# -----------------------------
# VPN Connection
# -----------------------------
resource "azurerm_virtual_network_gateway_connection" "vpn_to_vyos" {
  count                        = var.enable_p5_vpn ? 1 : 0
  name                         = "hub-to-vyos-vpn"
  resource_group_name           = module.hub_spoke_networking.hub_rg_name
  virtual_network_gateway_id    = azurerm_virtual_network_gateway.hub_vpn_gw[0].id
  local_network_gateway_id      = azurerm_local_network_gateway.vyos_peer[0].id
  type                         = "IPsec"
  shared_key                   = var.vpn_psk
}

# -----------------------------
# Route Table update for lab subnet
# -----------------------------
resource "azurerm_route" "lab_route" {
  count               = var.enable_p5_vpn ? 1 : 0
  name                = "rt-lab-to-vpn"
  resource_group_name = module.hub_spoke_networking.hub_rg_name
  route_table_name    = module.hub_spoke_networking.hub_route_table_name
  address_prefix      = "192.168.1.0/24"
  next_hop_type       = "VirtualNetworkGateway"
}

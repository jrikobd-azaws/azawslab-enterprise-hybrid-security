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

resource "azurerm_linux_virtual_machine" "fortigate_vm" {
  count               = var.enable_p5_fortigate ? 1 : 0
  name                = "fg-az-hub01"
  resource_group_name = "rg-platform-hub-norwayeast"
  location            = "norwayeast"
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
  location            = "norwayeast"
  resource_group_name = "rg-platform-hub-norwayeast"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.hub_firewall.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_network_gateway" "hub_vpn_gw" {
  count                = var.enable_p5_vpn ? 1 : 0
  name                 = "hub-vpn-gw"
  location             = "norwayeast"
  resource_group_name  = "rg-platform-hub-norwayeast"
  type                 = "Vpn"
  vpn_type             = "RouteBased"
  active_active        = false
  sku                  = "VpnGw1"
  ip_configuration {
    name                = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.vpn_gw_pub[0].id
    subnet_id           = azurerm_subnet.gateway.id
  }
}

resource "azurerm_public_ip" "vpn_gw_pub" {
  count               = var.enable_p5_vpn ? 1 : 0
  name                = "vpn-gw-pub"
  location            = "norwayeast"
  resource_group_name = "rg-platform-hub-norwayeast"
  allocation_method   = "Dynamic"
}

resource "azurerm_local_network_gateway" "vyos_peer" {
  count               = var.enable_p5_vpn ? 1 : 0
  name                = "vyos-lng"
  location            = "norwayeast"
  resource_group_name = "rg-platform-hub-norwayeast"
  gateway_address     = var.vpn_peer_dns
  address_space       = ["192.168.1.0/24"]
}

resource "azurerm_virtual_network_gateway_connection" "vpn_to_vyos" {
  count                        = var.enable_p5_vpn ? 1 : 0
  name                         = "hub-to-vyos-vpn"
  resource_group_name           = "rg-platform-hub-norwayeast"
  virtual_network_gateway_id    = azurerm_virtual_network_gateway.hub_vpn_gw[0].id
  local_network_gateway_id      = azurerm_local_network_gateway.vyos_peer[0].id
  type                         = "IPsec"
  shared_key                   = var.vpn_psk
}

resource "azurerm_route" "lab_route" {
  count               = var.enable_p5_vpn ? 1 : 0
  name                = "rt-lab-to-vpn"
  resource_group_name = "rg-platform-hub-norwayeast"
  route_table_name    = azurerm_route_table.hub_rt.name
  address_prefix      = "192.168.1.0/24"
  next_hop_type       = "VirtualNetworkGateway"
}

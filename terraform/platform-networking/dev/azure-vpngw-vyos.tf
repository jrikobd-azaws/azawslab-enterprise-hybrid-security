# -----------------------------------------------------------------------------
# O3a / P5 Fallback - Azure VPN Gateway <-> VyOS IPSec
#
# Purpose:
# - Provide lab-safe encrypted hybrid connectivity when FortiGate BYOL permanent
#   evaluation mode cannot negotiate modern AES/SHA IPSec with VyOS.
#
# This fallback does not replace the FortiGate Stage 1 deployment. FortiGate
# remains documented as a deployed Azure NVA milestone.
# -----------------------------------------------------------------------------

variable "enable_o3a_azure_vpngw_vyos" {
  type        = bool
  default     = false
  description = "Enable Azure VPN Gateway to VyOS IPSec fallback connectivity."
}

variable "o3a_azure_vpngw_sku" {
  type        = string
  default     = "VpnGw1AZ"
  description = "Azure VPN Gateway SKU for O3a lab fallback connectivity."
}

variable "o3a_vyos_peer_fqdn_secret_name" {
  type        = string
  default     = "p5-vyos-peer-fqdn"
  description = "Key Vault secret name containing the VyOS DDNS/FQDN endpoint."
}

variable "o3a_vyos_ipsec_psk_secret_name" {
  type        = string
  default     = "p5-vyos-ipsec-psk"
  description = "Key Vault secret name containing the Azure VPN Gateway to VyOS IPSec PSK."
}

data "azurerm_key_vault" "o3a_shared" {
  count               = var.enable_o3a_azure_vpngw_vyos ? 1 : 0
  name                = var.p5_key_vault_name
  resource_group_name = var.p5_key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "o3a_vyos_peer_fqdn" {
  count        = var.enable_o3a_azure_vpngw_vyos ? 1 : 0
  name         = var.o3a_vyos_peer_fqdn_secret_name
  key_vault_id = data.azurerm_key_vault.o3a_shared[0].id
}

data "azurerm_key_vault_secret" "o3a_vyos_ipsec_psk" {
  count        = var.enable_o3a_azure_vpngw_vyos ? 1 : 0
  name         = var.o3a_vyos_ipsec_psk_secret_name
  key_vault_id = data.azurerm_key_vault.o3a_shared[0].id
}

data "azurerm_subnet" "o3a_gateway_subnet" {
  count                = var.enable_o3a_azure_vpngw_vyos ? 1 : 0
  name                 = "GatewaySubnet"
  virtual_network_name = data.azurerm_virtual_network.p5_hub.name
  resource_group_name  = data.azurerm_resource_group.p5_connectivity.name
}

locals {
  o3a_vyos_peer_fqdn = var.enable_o3a_azure_vpngw_vyos ? data.azurerm_key_vault_secret.o3a_vyos_peer_fqdn[0].value : null
  o3a_vyos_ipsec_psk = var.enable_o3a_azure_vpngw_vyos ? data.azurerm_key_vault_secret.o3a_vyos_ipsec_psk[0].value : null

  o3a_vpngw_tags = merge(var.p5_fortigate_tags, {
    Component = "AzureVPNGateway-VyOS-IPSec"
    Phase     = "O3a"
    LabDelta  = "FortiGateTrialCryptoFallback"
  })
}

resource "azurerm_public_ip" "o3a_vpngw" {
  count               = var.enable_o3a_azure_vpngw_vyos ? 1 : 0
  name                = "pip-vpngw-vyos-norwayeast-01"
  location            = var.p5_hub_location
  resource_group_name = data.azurerm_resource_group.p5_connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = local.o3a_vpngw_tags
}

resource "azurerm_virtual_network_gateway" "o3a_vpngw" {
  count               = var.enable_o3a_azure_vpngw_vyos ? 1 : 0
  name                = "vpngw-dev-vyos-norwayeast-01"
  location            = var.p5_hub_location
  resource_group_name = data.azurerm_resource_group.p5_connectivity.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = var.o3a_azure_vpngw_sku

  active_active = false
  bgp_enabled   = false

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.o3a_vpngw[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.o3a_gateway_subnet[0].id
  }

  tags = local.o3a_vpngw_tags
}

resource "azurerm_local_network_gateway" "o3a_vyos" {
  count               = var.enable_o3a_azure_vpngw_vyos ? 1 : 0
  name                = "lngw-dev-vyos-norwayeast-01"
  location            = var.p5_hub_location
  resource_group_name = data.azurerm_resource_group.p5_connectivity.name

  gateway_fqdn  = local.o3a_vyos_peer_fqdn
  address_space = [var.o3a_hq_lab_prefix]

  tags = local.o3a_vpngw_tags
}

resource "azurerm_virtual_network_gateway_connection" "o3a_vpngw_to_vyos" {
  count               = var.enable_o3a_azure_vpngw_vyos ? 1 : 0
  name                = "vcn-dev-vpngw-to-vyos"
  location            = var.p5_hub_location
  resource_group_name = data.azurerm_resource_group.p5_connectivity.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.o3a_vpngw[0].id
  local_network_gateway_id   = azurerm_local_network_gateway.o3a_vyos[0].id
  shared_key                 = local.o3a_vyos_ipsec_psk
  connection_protocol        = "IKEv2"

  use_policy_based_traffic_selectors = false

  ipsec_policy {
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS14"
    sa_datasize      = 102400000
    sa_lifetime      = 3600
  }

  lifecycle {
    precondition {
      condition     = local.o3a_vyos_peer_fqdn != null && length(local.o3a_vyos_peer_fqdn) > 0
      error_message = "VyOS peer FQDN must be supplied from Key Vault when Azure VPN Gateway fallback is enabled."
    }

    precondition {
      condition     = local.o3a_vyos_ipsec_psk != null && length(local.o3a_vyos_ipsec_psk) >= 16
      error_message = "VyOS IPSec PSK must be supplied from Key Vault and must be at least 16 characters."
    }
  }

  tags = local.o3a_vpngw_tags
}




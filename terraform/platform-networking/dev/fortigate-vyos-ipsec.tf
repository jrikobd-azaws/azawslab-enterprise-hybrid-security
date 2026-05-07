# -----------------------------------------------------------------------------
# O3a / P5 Extension - FortiGate <-> VyOS IPSec + BGP Hybrid Connectivity
#
# Stage 1 scope:
# - Deploy FortiGate Azure NVA foundation only.
# - No IPSec tunnel configuration yet.
# - No BGP configuration yet.
# - No route-table steering yet.
#
# Correct design:
# - Azure edge: FortiGate NVA
# - On-prem edge: VyOS on Hyper-V
# - Future tunnel: IPSec
# - Future dynamic routing: BGP
#
# This phase does not use Azure VPN Gateway or Local Network Gateway.
# -----------------------------------------------------------------------------

variable "enable_p5_fortigate" {
  type        = bool
  default     = false
  description = "Enable FortiGate PAYG Gen2 VM foundation deployment for O3a/P5 hybrid connectivity."
}

variable "enable_o3a_fortigate_vyos_ipsec" {
  type        = bool
  default     = false
  description = "Reserved future flag for FortiGate-to-VyOS IPSec/BGP configuration. Must remain false until the FortiGate VM is deployed and reachable."

  validation {
    condition     = var.enable_o3a_fortigate_vyos_ipsec == false
    error_message = "O3a FortiGate-to-VyOS IPSec/BGP configuration is intentionally blocked until FortiGate Stage 1 is complete."
  }
}

variable "p5_fortigate_vm_size" {
  type        = string
  default     = "Standard_D2as_v5"
  description = "Azure VM size for the FortiGate PAYG Gen2 VM."
}

variable "p5_hub_resource_group_name" {
  type        = string
  default     = "rg-connectivity-prod-norwayeast"
  description = "Existing connectivity resource group containing the hub VNet."
}

variable "p5_hub_location" {
  type        = string
  default     = "norwayeast"
  description = "Azure region for existing hub networking and FortiGate resources."
}

variable "p5_fortigate_admin_username" {
  type        = string
  default     = "fortiadmin"
  description = "FortiGate admin username configured on the Azure VM."
}

variable "p5_use_key_vault_for_fortigate_admin" {
  type        = bool
  default     = true
  description = "When true, read the FortiGate admin password from the existing shared Key Vault."
}

variable "p5_key_vault_name" {
  type        = string
  default     = "kvdevazawsne01"
  description = "Existing shared Key Vault name owned by terraform/platform-shared/dev."
}

variable "p5_key_vault_resource_group_name" {
  type        = string
  default     = "rg-dev-security-norwayeast"
  description = "Resource group containing the existing shared Key Vault."
}

variable "p5_fortigate_admin_secret_name" {
  type        = string
  default     = "p5-fortigate-admin-password"
  description = "Key Vault secret name for the FortiGate admin password."
}

variable "p5_fortigate_mgmt_source_cidr_secret_name" {
  type        = string
  default     = "p5-fortigate-mgmt-source-cidr"
  description = "Key Vault secret name containing the allowed source CIDR for FortiGate management access."
}

variable "p5_fortigate_admin_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "Fallback FortiGate admin password. Prefer the existing Azure Key Vault secret path."
}

variable "p5_fortigate_hub_vnet_name" {
  type        = string
  default     = "vnet-dev-norwayeast-hub"
  description = "Existing hub VNet name."
}

variable "p5_fortigate_untrusted_subnet_prefixes" {
  type        = list(string)
  default     = ["10.0.3.0/27"]
  description = "Address prefix for the FortiGate untrusted/public-facing subnet."
}

variable "p5_fortigate_trusted_subnet_prefixes" {
  type        = list(string)
  default     = ["10.0.3.32/27"]
  description = "Address prefix for the FortiGate trusted/private-facing subnet."
}

variable "p5_fortigate_mgmt_source_cidrs" {
  type        = list(string)
  default     = []
  description = "Source CIDRs allowed to manage FortiGate over SSH/HTTPS. Must be supplied when enable_p5_fortigate=true."
}

variable "p5_vyos_public_source_cidrs" {
  type        = list(string)
  default     = []
  description = "Optional VyOS public source CIDR(s) for future IPSec UDP 500/4500 allowance."
}

variable "o3a_vyos_peer_fqdn" {
  type        = string
  default     = "vyos01.hq.azawslab.co.uk"
  description = "Public FQDN for the VyOS peer endpoint."
}

variable "o3a_hq_lab_prefix" {
  type        = string
  default     = "192.168.1.0/24"
  description = "HQ Hyper-V lab prefix advertised by VyOS in the future IPSec/BGP phase."
}

variable "o3a_fortigate_asn" {
  type        = number
  default     = 65515
  description = "Future BGP ASN for the Azure FortiGate transit hub."
}

variable "o3a_vyos_asn" {
  type        = number
  default     = 65001
  description = "Future BGP ASN for the HQ VyOS edge."
}

variable "p5_fortigate_enable_accelerated_networking" {
  type        = bool
  default     = true
  description = "Enable accelerated networking on FortiGate NICs where supported by the chosen VM size."
}

variable "p5_fortigate_tags" {
  type        = map(string)
  description = "Tags for FortiGate/O3a hybrid resources."

  default = {
    Environment = "dev"
    Project     = "Azawslab-Release2"
    Owner       = "HASHIBUR-RAHMAN"
    CostCenter  = "Lab"
    Phase       = "O3a"
    Component   = "FortiGate-VyOS-IPSec-BGP"
    Lifecycle   = "Ephemeral"
  }
}

data "azurerm_key_vault" "p5_shared" {
  count               = var.enable_p5_fortigate && var.p5_use_key_vault_for_fortigate_admin ? 1 : 0
  name                = var.p5_key_vault_name
  resource_group_name = var.p5_key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "p5_fortigate_admin_password" {
  count        = var.enable_p5_fortigate && var.p5_use_key_vault_for_fortigate_admin ? 1 : 0
  name         = var.p5_fortigate_admin_secret_name
  key_vault_id = data.azurerm_key_vault.p5_shared[0].id
}

data "azurerm_key_vault_secret" "p5_fortigate_mgmt_source_cidr" {
  count        = var.enable_p5_fortigate && var.p5_use_key_vault_for_fortigate_admin ? 1 : 0
  name         = var.p5_fortigate_mgmt_source_cidr_secret_name
  key_vault_id = data.azurerm_key_vault.p5_shared[0].id
}

locals {
  p5_fortigate_admin_password   = var.enable_p5_fortigate && var.p5_use_key_vault_for_fortigate_admin ? data.azurerm_key_vault_secret.p5_fortigate_admin_password[0].value : var.p5_fortigate_admin_password
  p5_fortigate_mgmt_source_cidr = var.enable_p5_fortigate && var.p5_use_key_vault_for_fortigate_admin ? data.azurerm_key_vault_secret.p5_fortigate_mgmt_source_cidr[0].value : null
}

# -----------------------------------------------------------------------------
# FortiGate dedicated subnets
# -----------------------------------------------------------------------------

resource "azurerm_subnet" "fortigate_untrusted" {
  count                = var.enable_p5_fortigate ? 1 : 0
  name                 = "snet-fortigate-untrusted"
  resource_group_name  = data.azurerm_resource_group.p5_connectivity.name
  virtual_network_name = data.azurerm_virtual_network.p5_hub.name
  address_prefixes     = var.p5_fortigate_untrusted_subnet_prefixes
}

resource "azurerm_subnet" "fortigate_trusted" {
  count                = var.enable_p5_fortigate ? 1 : 0
  name                 = "snet-fortigate-trusted"
  resource_group_name  = data.azurerm_resource_group.p5_connectivity.name
  virtual_network_name = data.azurerm_virtual_network.p5_hub.name
  address_prefixes     = var.p5_fortigate_trusted_subnet_prefixes
}

# -----------------------------------------------------------------------------
# Public IP and NSG
# -----------------------------------------------------------------------------

resource "azurerm_public_ip" "fortigate_untrusted" {
  count               = var.enable_p5_fortigate ? 1 : 0
  name                = "pip-fortigate-norwayeast-01"
  location            = var.p5_hub_location
  resource_group_name = data.azurerm_resource_group.p5_connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.p5_fortigate_tags
}

resource "azurerm_network_security_group" "fortigate_untrusted" {
  count               = var.enable_p5_fortigate ? 1 : 0
  name                = "nsg-fortigate-untrusted-inbound"
  location            = var.p5_hub_location
  resource_group_name = data.azurerm_resource_group.p5_connectivity.name
  tags                = var.p5_fortigate_tags
}

resource "azurerm_network_security_rule" "fortigate_mgmt" {
  count                       = var.enable_p5_fortigate ? 1 : 0
  name                        = "Allow-FortiGate-Mgmt-SSH-HTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "443"]
  source_address_prefixes     = [local.p5_fortigate_mgmt_source_cidr]
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.p5_connectivity.name
  network_security_group_name = azurerm_network_security_group.fortigate_untrusted[0].name
}

resource "azurerm_network_security_rule" "fortigate_ipsec_from_vyos" {
  count                       = var.enable_p5_fortigate && length(var.p5_vyos_public_source_cidrs) > 0 ? 1 : 0
  name                        = "Allow-VyOS-IPSec-IKE-NATT"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_ranges     = ["500", "4500"]
  source_address_prefixes     = var.p5_vyos_public_source_cidrs
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.p5_connectivity.name
  network_security_group_name = azurerm_network_security_group.fortigate_untrusted[0].name
}

resource "azurerm_subnet_network_security_group_association" "fortigate_untrusted" {
  count                     = var.enable_p5_fortigate ? 1 : 0
  subnet_id                 = azurerm_subnet.fortigate_untrusted[0].id
  network_security_group_id = azurerm_network_security_group.fortigate_untrusted[0].id
}

# -----------------------------------------------------------------------------
# FortiGate NICs
# -----------------------------------------------------------------------------

resource "azurerm_network_interface" "fortigate_untrusted" {
  count                          = var.enable_p5_fortigate ? 1 : 0
  name                           = "nic-vm-dev-fortigate-01-untrusted"
  location                       = var.p5_hub_location
  resource_group_name            = data.azurerm_resource_group.p5_connectivity.name
  accelerated_networking_enabled = var.p5_fortigate_enable_accelerated_networking
  ip_forwarding_enabled          = true
  tags                           = var.p5_fortigate_tags

  ip_configuration {
    name                          = "ipconfig-untrusted"
    subnet_id                     = azurerm_subnet.fortigate_untrusted[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.fortigate_untrusted[0].id
  }
}

resource "azurerm_network_interface" "fortigate_trusted" {
  count                          = var.enable_p5_fortigate ? 1 : 0
  name                           = "nic-vm-dev-fortigate-01-trusted"
  location                       = var.p5_hub_location
  resource_group_name            = data.azurerm_resource_group.p5_connectivity.name
  accelerated_networking_enabled = var.p5_fortigate_enable_accelerated_networking
  ip_forwarding_enabled          = true
  tags                           = var.p5_fortigate_tags

  ip_configuration {
    name                          = "ipconfig-trusted"
    subnet_id                     = azurerm_subnet.fortigate_trusted[0].id
    private_ip_address_allocation = "Dynamic"
  }
}

# -----------------------------------------------------------------------------
# FortiGate PAYG Gen2 VM
# -----------------------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "fortigate" {
  count               = var.enable_p5_fortigate ? 1 : 0
  name                = "vm-dev-fortigate-01"
  computer_name       = "vm-dev-fgt-01"
  location            = var.p5_hub_location
  resource_group_name = data.azurerm_resource_group.p5_connectivity.name
  size                = var.p5_fortigate_vm_size

  admin_username                  = var.p5_fortigate_admin_username
  admin_password                  = local.p5_fortigate_admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.fortigate_untrusted[0].id,
    azurerm_network_interface.fortigate_trusted[0].id
  ]

  plan {
    publisher = "fortinet"
    product   = "fortinet_fortigate-vm_v5"
    name      = "fortinet_fg-vm_payg_2023_g2"
  }

  source_image_reference {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = "fortinet_fg-vm_payg_2023_g2"
    version   = "7.6.5"
  }

  os_disk {
    name                 = "disk-vm-dev-fortigate-01-os-01"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {}

  lifecycle {
    precondition {
      condition     = local.p5_fortigate_mgmt_source_cidr != null && length(local.p5_fortigate_mgmt_source_cidr) > 0
      error_message = "p5_fortigate_mgmt_source_cidrs must be supplied when enable_p5_fortigate=true. Do not expose FortiGate management to 0.0.0.0/0."
    }

    precondition {
      condition     = local.p5_fortigate_admin_password != null && length(local.p5_fortigate_admin_password) >= 12
      error_message = "FortiGate admin password must be supplied from Key Vault or a sensitive GitHub Actions variable and must be at least 12 characters."
    }
  }

  tags = var.p5_fortigate_tags
}





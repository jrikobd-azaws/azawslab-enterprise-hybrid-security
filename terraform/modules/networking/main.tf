resource "azurerm_resource_group" "networking" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "workload" {
  name                = var.vnet_name
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_network_security_group" "management" {
  count = var.management_subnet_name != null && var.management_subnet_prefixes != null ? 1 : 0

  name                = "nsg-mgmt-inbound"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  tags                = var.tags

  security_rule {
    name                       = "allow-ssh-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "workload" {
  name                 = var.workload_subnet_name
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.workload.name
  address_prefixes     = var.workload_subnet_prefixes
}

resource "azurerm_subnet" "management" {
  count = var.management_subnet_name != null && var.management_subnet_prefixes != null ? 1 : 0

  name                 = var.management_subnet_name
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.workload.name
  address_prefixes     = var.management_subnet_prefixes
}

resource "azurerm_subnet_network_security_group_association" "management" {
  count = var.management_subnet_name != null && var.management_subnet_prefixes != null ? 1 : 0

  subnet_id                 = azurerm_subnet.management[0].id
  network_security_group_id = azurerm_network_security_group.management[0].id
}

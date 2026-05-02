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

resource "azurerm_subnet" "workload" {
  name                 = var.workload_subnet_name
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.workload.name
  address_prefixes     = var.workload_subnet_prefixes
}

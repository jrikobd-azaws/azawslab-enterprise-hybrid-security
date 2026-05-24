resource "azurerm_resource_group" "this" {
  count = var.enabled ? 1 : 0

  name     = var.resource_group_name
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_virtual_network" "avd" {
  count = var.enabled ? 1 : 0

  name                = var.avd_vnet_name
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  address_space       = var.avd_vnet_address_space
  tags                = var.common_tags
}

resource "azurerm_subnet" "avd" {
  count = var.enabled ? 1 : 0

  name                 = var.avd_subnet_name
  resource_group_name  = azurerm_resource_group.this[0].name
  virtual_network_name = azurerm_virtual_network.avd[0].name
  address_prefixes     = var.avd_subnet_address_prefixes
}

resource "azurerm_subnet" "private_endpoints" {
  count = var.enabled ? 1 : 0

  name                 = var.private_endpoint_subnet_name
  resource_group_name  = azurerm_resource_group.this[0].name
  virtual_network_name = azurerm_virtual_network.avd[0].name
  address_prefixes     = var.private_endpoint_subnet_prefixes
}

resource "azurerm_route_table" "avd" {
  count = var.enabled ? 1 : 0

  name                = var.route_table_name
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  tags                = var.common_tags
}

resource "azurerm_route" "default_to_azure_firewall" {
  count = var.enabled ? 1 : 0

  name                   = "route-default-to-azure-firewall"
  resource_group_name    = azurerm_resource_group.this[0].name
  route_table_name       = azurerm_route_table.avd[0].name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.azure_firewall_private_ip_address
}

resource "azurerm_subnet_route_table_association" "avd" {
  count = var.enabled ? 1 : 0

  subnet_id      = azurerm_subnet.avd[0].id
  route_table_id = azurerm_route_table.avd[0].id
}

resource "azurerm_virtual_desktop_host_pool" "this" {
  count = var.enabled ? 1 : 0

  name                             = var.host_pool_name
  location                         = azurerm_resource_group.this[0].location
  resource_group_name              = azurerm_resource_group.this[0].name
  friendly_name                    = "Release 2 O5 secure admin/dev host pool"
  description                      = "Personal Azure Virtual Desktop host pool for the Release 2 O5 secure admin/dev workspace."
  type                             = "Personal"
  personal_desktop_assignment_type = "Automatic"
  load_balancer_type               = "Persistent"
  preferred_app_group_type         = "Desktop"
  custom_rdp_properties            = "enablerdsaadauth:i:1;targetisaadjoined:i:1;"
  validate_environment             = false
  start_vm_on_connect              = false
  tags                             = var.common_tags
}

resource "azurerm_virtual_desktop_workspace" "this" {
  count = var.enabled ? 1 : 0

  name                = var.workspace_name
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  friendly_name       = "Release 2 O5 Secure Admin/Dev Workspace"
  description         = "Azure Virtual Desktop workspace for Release 2 secure admin and developer operations."
  tags                = var.common_tags
}

resource "azurerm_virtual_desktop_application_group" "desktop" {
  count = var.enabled ? 1 : 0

  name                = var.desktop_app_group_name
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.this[0].id
  friendly_name       = "Release 2 O5 Desktop"
  description         = "Desktop application group for the O5 secure admin/dev workspace."
  tags                = var.common_tags
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "desktop" {
  count = var.enabled ? 1 : 0

  workspace_id         = azurerm_virtual_desktop_workspace.this[0].id
  application_group_id = azurerm_virtual_desktop_application_group.desktop[0].id
}

resource "azurerm_storage_account" "fslogix" {
  count = var.enabled ? 1 : 0

  name                            = var.fslogix_storage_account_name
  resource_group_name             = azurerm_resource_group.this[0].name
  location                        = azurerm_resource_group.this[0].location
  account_tier                    = "Standard"
  account_replication_type        = var.fslogix_storage_replication_type
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  public_network_access_enabled   = false
  tags                            = var.common_tags

  azure_files_authentication {
    directory_type                 = "AADKERB"
    default_share_level_permission = "StorageFileDataSmbShareContributor"
  }
}

resource "azurerm_storage_share" "fslogix_profiles" {
  count = var.enabled ? 1 : 0

  name               = var.fslogix_share_name
  storage_account_id = azurerm_storage_account.fslogix[0].id
  quota              = var.fslogix_share_quota_gb
  enabled_protocol   = "SMB"
}

resource "azurerm_private_dns_zone" "file" {
  count = var.enabled ? 1 : 0

  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.this[0].name
  tags                = var.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "file_to_avd" {
  count = var.enabled ? 1 : 0

  name                  = "pdnslink-file-to-avd"
  resource_group_name   = azurerm_resource_group.this[0].name
  private_dns_zone_name = azurerm_private_dns_zone.file[0].name
  virtual_network_id    = azurerm_virtual_network.avd[0].id
  registration_enabled  = false
  tags                  = var.common_tags
}

resource "azurerm_private_endpoint" "fslogix_file" {
  count = var.enabled ? 1 : 0

  name                = "pe-${var.fslogix_storage_account_name}-file"
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  subnet_id           = azurerm_subnet.private_endpoints[0].id
  tags                = var.common_tags

  private_service_connection {
    name                           = "psc-${var.fslogix_storage_account_name}-file"
    private_connection_resource_id = azurerm_storage_account.fslogix[0].id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "pdzg-file"
    private_dns_zone_ids = [azurerm_private_dns_zone.file[0].id]
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.file_to_avd
  ]
}

resource "azurerm_route" "o5_o6_azure_platform_admin_to_azure_firewall" {
  count = var.enabled && var.enable_o5_o6_private_routes ? 1 : 0

  name                   = "route-o5-o6-azure-platform-admin-to-azfw"
  resource_group_name    = azurerm_resource_group.this[0].name
  route_table_name       = azurerm_route_table.avd[0].name
  address_prefix         = var.o5_o6_azure_platform_admin_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.azure_firewall_private_ip_address
}

resource "azurerm_route" "o5_o6_hq_to_fortigate" {
  count = var.enabled && var.enable_o5_o6_private_routes ? 1 : 0

  name                   = "route-o5-o6-hq-to-fortigate"
  resource_group_name    = azurerm_resource_group.this[0].name
  route_table_name       = azurerm_route_table.avd[0].name
  address_prefix         = var.o5_o6_hq_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.o5_o6_fortigate_private_ip_address
}

resource "azurerm_route" "o5_o6_aws_trusted_to_fortigate" {
  count = var.enabled && var.enable_o5_o6_private_routes ? 1 : 0

  name                   = "route-o5-o6-aws-trusted-to-fortigate"
  resource_group_name    = azurerm_resource_group.this[0].name
  route_table_name       = azurerm_route_table.avd[0].name
  address_prefix         = var.o5_o6_aws_trusted_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.o5_o6_fortigate_private_ip_address
}

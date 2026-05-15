module "avd_secure_workspace" {
  source = "../../modules/avd-secure-workspace"

  enabled = var.enable_o5_avd

  enable_session_host                                  = var.enable_o5_session_host
  session_host_name                                    = var.o5_session_host_name
  session_host_nic_name                                = var.o5_session_host_nic_name
  session_host_vm_size                                 = var.o5_session_host_vm_size
  session_host_admin_username                          = var.o5_session_host_admin_username
  session_host_image_publisher                         = var.o5_session_host_image_publisher
  session_host_image_offer                             = var.o5_session_host_image_offer
  session_host_image_sku                               = var.o5_session_host_image_sku
  session_host_image_version                           = var.o5_session_host_image_version
  session_host_registration_expiration_date            = var.o5_session_host_registration_expiration_date
  session_host_admin_password_key_vault_name           = var.o5_session_host_admin_password_key_vault_name
  session_host_admin_password_key_vault_resource_group = var.o5_session_host_admin_password_key_vault_resource_group_name
  session_host_admin_password_secret_name              = var.o5_session_host_admin_password_secret_name

  location                          = var.location
  paired_location                   = var.paired_location
  common_tags                       = var.common_tags
  resource_group_name               = var.resource_group_name
  avd_vnet_name                     = var.avd_vnet_name
  avd_vnet_address_space            = var.avd_vnet_address_space
  avd_subnet_name                   = var.avd_subnet_name
  avd_subnet_address_prefixes       = var.avd_subnet_address_prefixes
  private_endpoint_subnet_name      = var.private_endpoint_subnet_name
  private_endpoint_subnet_prefixes  = var.private_endpoint_subnet_address_prefixes
  route_table_name                  = var.route_table_name
  azure_firewall_private_ip_address = var.azure_firewall_private_ip_address
  host_pool_name                    = var.host_pool_name
  workspace_name                    = var.workspace_name
  desktop_app_group_name            = var.desktop_app_group_name
  fslogix_storage_account_name      = var.fslogix_storage_account_name
  fslogix_storage_replication_type  = var.fslogix_storage_replication_type
  fslogix_share_name                = var.fslogix_share_name
  fslogix_share_quota_gb            = var.fslogix_share_quota_gb
}
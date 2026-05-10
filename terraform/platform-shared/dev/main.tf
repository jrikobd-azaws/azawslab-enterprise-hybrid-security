
data "azurerm_virtual_network" "workload_spoke" {
  name                = "vnet-dev-norwayeast-spoke-workload"
  resource_group_name = "rg-dev-workload-norwayeast"
}

data "azurerm_subnet" "management" {
  name                 = "snet-mgmt"
  virtual_network_name = data.azurerm_virtual_network.workload_spoke.name
  resource_group_name  = data.azurerm_virtual_network.workload_spoke.resource_group_name
}
locals {
  common_tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }

  p9b_tags = merge(local.common_tags, {
    Phase   = "P9b"
    Service = "Backup"
  })
}
module "security" {
  source = "../../modules/security"

  resource_group_name = "rg-dev-security-norwayeast"
  location            = "norwayeast"

  key_vault_secret_admin_object_ids = [
    "a2fb5bd2-9920-4b0c-8b8b-b96560b13473", # hashib
    "6b8005f6-bb12-45d1-8ad2-3a8aae8c5a8d", # admin-lab
    "f0c31d32-a72f-4b16-8643-c3f19900da29"  # sp-terraform-gh
  ]

  defender_security_contact_name  = "default"
  defender_security_contact_email = "admin-lab@entra.azawslab.co.uk"

  defender_for_servers_pricing_tier = "Standard"
  defender_for_servers_subplan      = "P1"

  enable_key_vault_private_endpoint    = var.enable_key_vault_private_endpoint
  key_vault_private_endpoint_name      = var.key_vault_private_endpoint_name
  key_vault_private_dns_zone_name      = var.key_vault_private_dns_zone_name
  key_vault_private_dns_link_name      = var.key_vault_private_dns_link_name
  key_vault_private_endpoint_subnet_id = data.azurerm_subnet.management.id
  key_vault_private_dns_vnet_id        = data.azurerm_virtual_network.workload_spoke.id
}


import {
  to = module.security.azurerm_key_vault_access_policy.principals["a2fb5bd2-9920-4b0c-8b8b-b96560b13473"]
  id = "/subscriptions/8d99637c-13e7-417c-b334-b586d0ddc3d6/resourceGroups/rg-dev-security-norwayeast/providers/Microsoft.KeyVault/vaults/kvdevazawsne01/objectId/a2fb5bd2-9920-4b0c-8b8b-b96560b13473"
}

import {
  to = module.security.azurerm_key_vault_access_policy.principals["6b8005f6-bb12-45d1-8ad2-3a8aae8c5a8d"]
  id = "/subscriptions/8d99637c-13e7-417c-b334-b586d0ddc3d6/resourceGroups/rg-dev-security-norwayeast/providers/Microsoft.KeyVault/vaults/kvdevazawsne01/objectId/6b8005f6-bb12-45d1-8ad2-3a8aae8c5a8d"
}

import {
  to = module.security.azurerm_key_vault_access_policy.principals["f0c31d32-a72f-4b16-8643-c3f19900da29"]
  id = "/subscriptions/8d99637c-13e7-417c-b334-b586d0ddc3d6/resourceGroups/rg-dev-security-norwayeast/providers/Microsoft.KeyVault/vaults/kvdevazawsne01/objectId/f0c31d32-a72f-4b16-8643-c3f19900da29"
}




module "monitoring" {
  source = "../../modules/monitoring"

  enable_sentinel = true

  enable_monitor_alerts        = true
  monitor_action_group_email   = "admin-lab@entra.azawslab.co.uk"
  monitor_alert_target_vm_id   = "/subscriptions/8d99637c-13e7-417c-b334-b586d0ddc3d6/resourceGroups/rg-dev-workload-norwayeast/providers/Microsoft.Compute/virtualMachines/vm-dev-client-01"
  resource_group_name          = "rg-dev-monitoring-norwayeast"
  location                     = "norwayeast"
  log_analytics_workspace_name = "law-dev-platform-norwayeast"

  tags = {
    Environment = "dev"
    Project     = "azawslab"
    Owner       = "platform"
    CostCenter  = "lab"
    Phase       = "P8"
  }
}






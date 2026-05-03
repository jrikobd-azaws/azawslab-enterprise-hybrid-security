module "security" {
  source = "../../modules/security"

  resource_group_name = "rg-dev-security-norwayeast"
  location            = "norwayeast"

  key_vault_secret_admin_object_ids = [
    "a2fb5bd2-9920-4b0c-8b8b-b96560b13473", # hashib
    "6b8005f6-bb12-45d1-8ad2-3a8aae8c5a8d", # admin-lab
    "f0c31d32-a72f-4b16-8643-c3f19900da29"  # sp-terraform-gh
  ]
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


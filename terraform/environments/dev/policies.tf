# Phase P1 policy scaffold
# This file holds Azure Policy assignments for:
# - allowed locations
# - allowed resource group locations
# - allowed VM SKUs
# - mandatory tags

data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "pa-loc-prod-uks"
  display_name         = "pa-loc-prod-uks"
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["uksouth"]
    }
  })
}

data "azurerm_policy_definition" "allowed_rg_locations" {
  display_name = "Allowed locations for resource groups"
}

resource "azurerm_management_group_policy_assignment" "allowed_rg_locations" {
  name                 = "pa-rgloc-uks"
  display_name         = "pa-rgloc-uks"
  policy_definition_id = data.azurerm_policy_definition.allowed_rg_locations.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["uksouth"]
    }
  })
}

data "azurerm_policy_definition" "allowed_vm_skus" {
  display_name = "Allowed virtual machine size SKUs"
}

resource "azurerm_management_group_policy_assignment" "allowed_vm_skus" {
  name                 = "pa-vmsku-prod"
  display_name         = "pa-vmsku-prod"
  policy_definition_id = data.azurerm_policy_definition.allowed_vm_skus.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    listOfAllowedSKUs = {
      value = [
        "Standard_B1s",
        "Standard_B2s"
      ]
    }
  })
}

data "azurerm_policy_definition" "require_tag_value" {
  display_name = "Require a tag on resources"
}

resource "azurerm_management_group_policy_assignment" "require_tag_environment" {
  name                 = "pa-tag-env"
  display_name         = "pa-tag-env"
  policy_definition_id = data.azurerm_policy_definition.require_tag_value.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "require_tag_project" {
  name                 = "pa-tag-proj"
  display_name         = "pa-tag-proj"
  policy_definition_id = data.azurerm_policy_definition.require_tag_value.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    tagName = {
      value = "Project"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "require_tag_owner" {
  name                 = "pa-tag-own"
  display_name         = "pa-tag-own"
  policy_definition_id = data.azurerm_policy_definition.require_tag_value.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    tagName = {
      value = "Owner"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "require_tag_costcenter" {
  name                 = "pa-tag-cost"
  display_name         = "pa-tag-cost"
  policy_definition_id = data.azurerm_policy_definition.require_tag_value.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    tagName = {
      value = "CostCenter"
    }
  })
}

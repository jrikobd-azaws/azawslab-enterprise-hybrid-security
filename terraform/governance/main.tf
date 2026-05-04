data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "pa-loc-prod-norwayeast"
  display_name         = "pa-loc-prod-norwayeast"
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["norwayeast"]
    }
  })
}

data "azurerm_policy_definition" "allowed_rg_locations" {
  display_name = "Allowed locations for resource groups"
}

resource "azurerm_management_group_policy_assignment" "allowed_rg_locations" {
  name                 = "pa-rgloc-prod-norwayeast"
  display_name         = "pa-rgloc-prod-norwayeast"
  policy_definition_id = data.azurerm_policy_definition.allowed_rg_locations.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["norwayeast"]
    }
  })
}

data "azurerm_policy_definition" "allowed_vm_skus" {
  display_name = "Allowed virtual machine size SKUs"
}

resource "azurerm_management_group_policy_assignment" "allowed_vm_skus" {
  name                 = "pa-vmsku-prod-b2alsv2"
  display_name         = "pa-vmsku-prod-b2alsv2"
  policy_definition_id = data.azurerm_policy_definition.allowed_vm_skus.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    listOfAllowedSKUs = {
      value = [
        "Standard_B2als_v2"
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

data "azurerm_policy_definition" "require_tag_on_resource_groups" {
  display_name = "Require a tag on resource groups"
}

resource "azurerm_management_group_policy_assignment" "require_rg_tag_environment" {
  name                 = "pa-rgtag-env"
  display_name         = "pa-rgtag-env"
  policy_definition_id = data.azurerm_policy_definition.require_tag_on_resource_groups.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "require_rg_tag_project" {
  name                 = "pa-rgtag-proj"
  display_name         = "pa-rgtag-proj"
  policy_definition_id = data.azurerm_policy_definition.require_tag_on_resource_groups.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    tagName = {
      value = "Project"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "require_rg_tag_owner" {
  name                 = "pa-rgtag-own"
  display_name         = "pa-rgtag-own"
  policy_definition_id = data.azurerm_policy_definition.require_tag_on_resource_groups.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    tagName = {
      value = "Owner"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "require_rg_tag_costcenter" {
  name                 = "pa-rgtag-cost"
  display_name         = "pa-rgtag-cost"
  policy_definition_id = data.azurerm_policy_definition.require_tag_on_resource_groups.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-landingzones-prod-global"

  parameters = jsonencode({
    tagName = {
      value = "CostCenter"
    }
  })
}

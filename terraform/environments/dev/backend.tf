terraform {
  backend "azurerm" {
    resource_group_name  = "rg-dev-terraformstate-uksouth"
    storage_account_name = "stdevtfstateazaws01"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

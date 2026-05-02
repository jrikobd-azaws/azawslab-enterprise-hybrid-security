terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-dev-terraformstate-norwayeast"
    storage_account_name = "stdevtfstatene01"
    container_name       = "tfstate"
    key                  = "governance.tfstate"
  }
}

provider "azurerm" {
  features {}
}


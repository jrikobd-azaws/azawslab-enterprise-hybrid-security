terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-dev-terraformstate-norwayeast"
    storage_account_name = "stdevtfstatene01"
    container_name       = "tfstate"
    key                  = "aws-branch-dev.tfstate"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

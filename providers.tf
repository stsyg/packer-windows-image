terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.10.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~>2.23.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "infra-storage-rg"
    storage_account_name = "infrastoraged103"
    container_name       = "infrastoragetfstate"
    key                  = "lab.packerwindowsimage.tfstate"
  }
}

provider "azurerm" {
  features {}
}
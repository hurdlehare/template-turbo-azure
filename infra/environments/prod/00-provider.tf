terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "rg-tfstate-prod-XXX"
  #   storage_account_name = "sttfstateXXX"
  #   container_name       = "stg-tfstate-prod-XXX"
  #   key                  = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}
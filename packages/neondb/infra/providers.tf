terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    neon = {
      source  = "kislerdm/neon"
      version = ">= 0.9.0"
    }
  }
}

provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "neon" {}

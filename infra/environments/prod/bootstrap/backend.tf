terraform {
  required_version = "~> 1.10.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }

  backend "local" {
    # local state for bootstrapping
    path = "terraform.tfstate"
  }
}

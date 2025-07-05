terraform {
  backend "azurerm" {
    resource_group_name  = "" # Resource Group containing your Terraform state backend
    storage_account_name = "" # Storage Account within the Resource Group
    container_name       = "" # Container within the Storage Account
    key                  = "" # Key for the Terraform state file in the container
  }
}
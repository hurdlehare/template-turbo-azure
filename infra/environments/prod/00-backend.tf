# Backend infrastructure to manage Terraform state
resource "random_string" "resource_id_tfstate" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg_tfstate" {
  name     = "${local.prefixes.resourcegroup}-tfstate-${var.environment}-${random_string.resource_id_tfstate.result}"
  location = var.azure_region
}

resource "azurerm_storage_account" "st_tfstate" {
  name                            = "${local.prefixes.storageaccount}tfstate${random_string.resource_id_tfstate.result}"
  resource_group_name             = azurerm_resource_group.rg_tfstate.name
  location                        = azurerm_resource_group.rg_tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_account_network_rules" "st_tfstate_network_rules" {
  storage_account_id = azurerm_storage_account.st_tfstate.id
  default_action     = "Deny"
  bypass             = ["AzureServices"]
  ip_rules = [
    "" # Your IPv4 address here
  ]
}

resource "azurerm_storage_container" "stg_tfstate" {
  name                  = "${local.prefixes.storageContainer}-tfstate-${var.environment}-${random_string.resource_id_tfstate.result}"
  storage_account_id    = azurerm_storage_account.st_tfstate.id
  container_access_type = "private"
}
provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

module "tags" {
  source = "../modules/tags"

  application = var.application
  environment = var.environment

  business_criticality = ""
  business_unit        = ""
  created_by           = ""
  data_sensitivity     = ""
  github_owner         = ""
  github_repository    = ""
  maintainer_email     = ""
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-${var.application}-${var.environment_short}-${var.location_short}-${random_string.suffix.result}"
  location = var.location

  tags = module.tags.common_tags
}

resource "azurerm_storage_account" "tfstate" {
  name                = "st${var.application}${var.environment_short}${var.location_short}${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location

  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = var.ip_rules
  }

  tags = module.tags.common_tags
}

resource "azurerm_storage_container" "tfstate" {
  for_each              = toset(var.environment_shorts)
  name                  = "tfstate-${each.value}"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "tfstate" {
  for_each             = var.environment_principals
  scope                = azurerm_storage_container.tfstate[each.key].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

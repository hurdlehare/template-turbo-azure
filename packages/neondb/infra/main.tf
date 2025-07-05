resource "neon_project" "example" {
  name   = ""
  org_id = ""
}

# ============================ BRANCHES ======================================

resource "neon_branch" "production" {
  project_id = neon_project.example.id
  name       = "production"
}

resource "neon_branch" "development" {
  project_id = neon_project.example.id
  parent_id  = neon_branch.production.id
  name       = "development"
}

# ============================ COMPUTES ======================================

# A compute is a virtualized service that runs applications. In Neon, a compute runs Postgres.
# NOTE: `endpoints` are now referred to as `computes` by Neon: https://neon.com/docs/manage/computes
resource "neon_endpoint" "production" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.production.id

  # Defaults (as of 2025-07-05)
  autoscaling_limit_min_cu = 1
  autoscaling_limit_max_cu = 2
  suspend_timeout_seconds  = 0
}

resource "neon_endpoint" "development" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.development.id

  # Defaults (as of 2025-07-05)
  autoscaling_limit_min_cu = 0.25
  autoscaling_limit_max_cu = 1
  suspend_timeout_seconds  = 0
}

# ============================ ROLES ======================================
# Default roles created by Neon Auth (as of 2025-07-05)
# -------------------------- production -----------------------------------

resource "neon_role" "production_anonymous" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.production.id
  name       = "anonymous"
}

resource "neon_role" "production_authenticated" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.production.id
  name       = "authenticated"
}

resource "neon_role" "production_neondb_owner" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.production.id
  name       = "neondb_owner"
}

# -------------------------- development -----------------------------------

resource "neon_role" "development_anonymous" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.development.id
  name       = "anonymous"
}

resource "neon_role" "development_authenticated" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.development.id
  name       = "authenticated"
}

resource "neon_role" "development_authenticator" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.development.id
  name       = "authenticator"
}

resource "neon_role" "development_neondb_owner" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.development.id
  name       = "neondb_owner"
}

# ============================ DATABASES ======================================

resource "neon_database" "production_neondb" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.production.id
  owner_name = "neondb_owner"
  name       = "neondb"
}

resource "neon_database" "development_neondb" {
  project_id = neon_project.example.id
  branch_id  = neon_branch.development.id
  owner_name = "neondb_owner"
  name       = "neondb"
}

# ============================ KEY VAULT ======================================

module "tags" {
  source = "../../../infra/modules/tags"

  application = var.application
  environment = var.environment

  business_criticality = "BusinessUnitCritical"
  business_unit        = "Engineering"
  created_by           = ""
  data_sensitivity     = "HighlyConfidential"
  github_owner         = ""
  github_repository    = ""
  maintainer_email     = ""
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

# Consider a separate resource group for development environments
resource "azurerm_resource_group" "neon" {
  name     = "rg-${var.application}-${var.environment_short}-${var.location_short}-${random_string.suffix.result}"
  location = var.location

  tags = module.tags.common_tags
}

# Consider a separate key vault for development environments
module "key_vault" {
  source = "Azure/avm-res-keyvault-vault/azurerm"

  name                = "kv${var.application}${var.environment_short}${var.location_short}${random_string.suffix.result}"
  location            = azurerm_resource_group.neon.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  resource_group_name = azurerm_resource_group.neon.name

  sku_name                        = "standard"
  enable_telemetry                = false
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  public_network_access_enabled   = true
  purge_protection_enabled        = true
  soft_delete_retention_days      = 90

  network_acls = {
    bypass   = "AzureServices"
    ip_rules = ["${data.http.ip.response_body}/32"]
  }

  role_assignments = {
    deployment_user_kv_admin = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  tags = module.tags.common_tags
}

# ============================ PRINCIPALS ======================================

# Jobs need to WRITE to the Neon Postgres, so they need Key Vault access
# to grab the Neon connection info for dbdatawriter
resource "azuread_application" "jobs" {
  display_name = "Example Jobs"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "jobs" {
  client_id                    = azuread_application.jobs.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "jobs" {
  scope                = module.key_vault.resource_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.jobs.object_id
}

# APIs need to READ from the Neon Postgres, so they need Key Vault access
# to grab the Neon connection info for dbdatareader
resource "azuread_application" "api" {
  display_name = "Example API"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "api" {
  client_id                    = azuread_application.api.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "api" {
  scope                = module.key_vault.resource_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.api.object_id
}

# ============================ SECRETS ======================================

# --------------------------- production ------------------------------------

resource "azurerm_key_vault_secret" "neon_production_anonymous" {
  name = "neon-production-anonymous-connection"
  value = jsonencode({
    host     = neon_endpoint.production.host
    user     = neon_role.production_anonymous.name
    password = neon_role.production_anonymous.password
    dbname   = neon_database.production_neondb.name
  })
  key_vault_id = module.key_vault.resource_id
}
resource "azurerm_key_vault_secret" "neon_production_authenticated" {
  name = "neon-production-authenticated-connection"
  value = jsonencode({
    host     = neon_endpoint.production.host
    user     = neon_role.production_authenticated.name
    password = neon_role.production_authenticated.password
    dbname   = neon_database.production_neondb.name
  })
  key_vault_id = module.key_vault.resource_id
}
resource "azurerm_key_vault_secret" "neon_production_neondb_owner" {
  name = "neon-production-neondb-owner-connection"
  value = jsonencode({
    host     = neon_endpoint.production.host
    user     = neon_role.production_neondb_owner.name
    password = neon_role.production_neondb_owner.password
    dbname   = neon_database.production_neondb.name
  })
  key_vault_id = module.key_vault.resource_id
}

# -------------------------- development -----------------------------------
# Consider a separate resource group & key vault for development environments

resource "azurerm_key_vault_secret" "neon_development_anonymous" {
  name = "neon-development-anonymous-connection"
  value = jsonencode({
    host     = neon_endpoint.development.host
    user     = neon_role.development_anonymous.name
    password = neon_role.development_anonymous.password
    dbname   = neon_database.development_neondb.name
  })
  key_vault_id = module.key_vault.resource_id
}
resource "azurerm_key_vault_secret" "neon_development_authenticated" {
  name = "neon-development-authenticated-connection"
  value = jsonencode({
    host     = neon_endpoint.development.host
    user     = neon_role.development_authenticated.name
    password = neon_role.development_authenticated.password
    dbname   = neon_database.development_neondb.name
  })
  key_vault_id = module.key_vault.resource_id
}
resource "azurerm_key_vault_secret" "neon_development_authenticator" {
  name = "neon-development-authenticator-connection"
  value = jsonencode({
    host     = neon_endpoint.development.host
    user     = neon_role.development_authenticator.name
    password = neon_role.development_authenticator.password
    dbname   = neon_database.development_neondb.name
  })
  key_vault_id = module.key_vault.resource_id
}
resource "azurerm_key_vault_secret" "neon_development_neondb_owner" {
  name = "neon-development-neondb-owner-connection"
  value = jsonencode({
    host     = neon_endpoint.development.host
    user     = neon_role.development_neondb_owner.name
    password = neon_role.development_neondb_owner.password
    dbname   = neon_database.development_neondb.name
  })
  key_vault_id = module.key_vault.resource_id
}

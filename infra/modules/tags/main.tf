terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.1"
    }
  }
}

resource "time_static" "current_datetime" {}

locals {
  common = merge(
    var.default_tags,
    {
      Application         = var.application
      BusinessCriticality = var.business_criticality
      BusinessUnit        = var.business_unit
      CreatedBy           = var.created_by
      DataSensitivity     = var.data_sensitivity
      Environment         = var.environment
      GithubOwner         = var.github_owner
      GithubRepository    = var.github_repository
      MaintainerEmail     = var.maintainer_email

      CreatedAt = time_static.current_datetime.rfc3339
    }
  )
}

output "common_tags" {
  value = local.common
}
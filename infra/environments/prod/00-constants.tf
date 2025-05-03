locals {
  # `tags` describe WHERE to look, WHO to contact, and WHEN to act 
  # 
  # `"GitHubOrganization"` GitHub organization containing the repository containing the resource's IaC
  # `"GitRepository"`      GitHub repository containing the resource's IaC
  # `"Owner"`              company contact for this resource
  # `"Maintainer"`         developer contact for this resource
  tags = {
    "GitHubOrganization" = "",
    "GitRepository"      = ""
    "Owner"              = "",
    "Maintainer"         = "",
  }
  # `groups` are logical groupings of resources that are deployed together
  # 
  # `"ApplicationPackage"` is the name of the app in the monorepo (if applicable)
  # `"StartDate"`          is the date the resource was created
  # `"EndDate"`            is the date the resource should be destroyed (if applicable)
  groups = {
    "web" = {
      name = "web"
      tags = merge(local.tags, {
        "StartDate" = "",
        "EndDate"   = ""
      })
    }
    "func" = {
      name = "func"
      tags = merge(local.tags, {
        "ApplicationPackage" = "func-app",
        "StartDate"          = "",
        "EndDate"            = ""
      })
    }
  }
  # `slots` are deployment slots for app services
  # 
  # `"Environment"` is the `NODE_ENV`, `PYTHON_ENV`, etc. for the resource
  # `"GitBranch"`   is the branch that is connected to the slot via CD
  slots = {
    "staging" = {
      name = "staging"
      tags = merge(local.tags, {
        "Environment" = "staging",
        "GitBranch"   = "staging"
      })
    }
    # NOTE: This is not the same as the `production` environment and we don't
    # use a `main` slot for all resources.
    #
    # Azure's best practices suggest connecting CD on the `main` branch to
    # a slot like this and swapping it to production - this allows for quick
    # rollbacks and ensures the resource is prepped for current load
    "main" = {
      name = "main"
      tags = merge(local.tags, {
        "Environment" = "production",
        "GitBranch"   = "main"
      })
    }
    # Because production may not necessarily use continuous deployment on the main
    # branch, we can't assign "GitBranch" to "main" here - we should do so in the
    # specific resource.
    "production" = {
      name = "production"
      tags = merge(local.tags, {
        "Environment" = "production"
      })
    }
  }
}
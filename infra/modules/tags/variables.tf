variable "default_tags" {
  description = "Default, organization-wide tags"
  type        = map(string)

  default = {
    Project = "Example"
  }
}

variable "application" {
  description = "Logical application name"
  type        = string
}

variable "business_criticality" {
  description = "Importance of the application to the business (Low, Medium, High, BusinessUnitCritical, MissionCritical)"
  type        = string

  validation {
    condition     = contains(["Low", "Medium", "High", "BusinessUnitCritical", "MissionCritical"], var.business_criticality)
    error_message = "Must be one of: Low, Medium, High, BusinessUnitCritical, MissionCritical"
  }
}

variable "business_unit" {
  description = "Business unit responsible for the application (Engineering, Finance, HumanResources, Legal, Marketing, Sales)"
  type        = string

  validation {
    condition     = contains(["Engineering", "Finance", "HumanResources", "Legal", "Marketing", "Sales"], var.business_unit)
    error_message = "Must be one of: Engineering, Finance, HumanResources, Legal, Marketing, Sales"
  }
}

variable "created_by" {
  description = "Creator of the resource (GitHub handle or CI/CD identifier)"
  type        = string
}

variable "data_sensitivity" {
  description = "Data sensitivity level (Public, Internal, Confidential, HighlyConfidential)"
  type        = string

  validation {
    condition     = contains(["Public", "Internal", "Confidential", "HighlyConfidential"], var.data_sensitivity)
    error_message = "Must be one of: Public, Internal, Confidential, HighlyConfidential"
  }
}

variable "environment" {
  description = "Environment deployed (Production, Staging, Development)"
  type        = string

  validation {
    condition     = contains(["Production", "Staging", "Development"], var.environment)
    error_message = "Must be one of: Production, Staging, Development"
  }
}

variable "github_owner" {
  description = "Github owner/organization name"
  type        = string
  # validation {
  #   condition     = can(regex("^(?!-)(?!.*--)[A-Za-z0-9-]{1,39}$", var.github_owner))
  #   error_message = "GitHub handles must be <=39 alphanumeric or non-consecutive, non-prefix hyphen characters."
  # }
}

variable "github_repository" {
  description = "Github repository name"
  type        = string

  # validation {
  #   condition     = can(regex("^[A-Za-z0-9._-]{1,100}$", var.github_repository))
  #   error_message = "GitHub repository names must be <=100 alphanumeric, hyphen, or underscore code points."
  # }
}

variable "maintainer_email" {
  description = "Email address of the maintainer"
  type        = string
  sensitive   = true
}

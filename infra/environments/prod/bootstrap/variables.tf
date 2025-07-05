variable "application" {
  type        = string
  description = "The name segment for the application or workload"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.application))
    error_message = "The name segment for the application must only contain lowercase letters and numbers"
  }
  validation {
    condition     = length(var.application) <= 8
    error_message = "The name segment for the application must be 8 characters or less"
  }
}

variable "environment" {
  description = "Environment deployed (Production, Staging, Development)"
  type        = string
  default     = "Production"

  validation {
    condition     = contains(["Production", "Staging", "Development"], var.environment)
    error_message = "Must be one of: Production, Staging, Development"
  }
}

variable "environment_short" {
  description = "Shortened environment name for state resources (dev, stage, prod)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment_short)
    error_message = "Must be one of: dev, stage, prod"
  }
}

variable "environment_shorts" {
  description = "Which envs to create containers for"
  type        = list(string)
  default     = ["dev", "stage", "prod"]
}

variable "environment_principals" {
  description = "Map of environment → Service Principal Object ID for state access"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "Azure region for state resources"
  type        = string
  default     = "West US 2"
}

variable "location_short" {
  description = "Shortened Azure region for state resources"
  type        = string
  default     = "wus2"
}

variable "ip_rules" {
  description = "List of IP rules to allow access to the storage account"
  type        = list(string)
  default     = []
  sensitive   = true
}
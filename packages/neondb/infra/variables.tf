variable "application" {
  type        = string
  description = "The name segment for the application or workload"
  default     = "example"

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
  description = "Shortened environment name for resources (dev, stage, prod)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment_short)
    error_message = "Must be one of: dev, stage, prod"
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "West US 2"
}

variable "location_short" {
  description = "Shortened Azure region for resources"
  type        = string
  default     = "wus2"
}

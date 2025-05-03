# === Defaults ===
variable "environment" {
  description = "Name of host environment"
  type        = string
}

variable "azure_region" {
  description = "Azure location/region"
  type        = string
  default     = ""
}

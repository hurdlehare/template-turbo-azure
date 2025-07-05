output "storage_account_name" {
  description = "Name of the Storage Account for Terraform state"
  value       = azurerm_storage_account.tfstate.name
}

output "container_names" {
  description = "Map of environment → container name"
  value       = { for k, c in azurerm_storage_container.tfstate : k => c.name }
}

output "container_ids" {
  description = "Map of environment → container resource ID"
  value       = { for k, c in azurerm_storage_container.tfstate : k => c.id }
}

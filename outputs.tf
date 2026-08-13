output "id" {
  description = "The ID of the Cognitive Account"
  value       = azurerm_cognitive_account.cognitive_account.id
}

output "endpoint" {
  description = "The base endpoint URL of the Cognitive Account"
  value       = azurerm_cognitive_account.cognitive_account.endpoint
}

output "custom_subdomain_name" {
  description = "The subdomain name used for Entra ID token-based authentication, required for Private Endpoint attachment"
  value       = azurerm_cognitive_account.cognitive_account.custom_subdomain_name
}

output "identity" {
  description = "The identity block with principal and tenant IDs"
  value       = try(azurerm_cognitive_account.cognitive_account.identity, null)
}
output "primary_access_key" {
  description = "Primary access key"
  value       = azurerm_cognitive_account.cognitive_account.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "Secondary access key"
  value       = azurerm_cognitive_account.cognitive_account.secondary_access_key
  sensitive   = true
}

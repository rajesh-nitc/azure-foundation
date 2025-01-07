output "terraform_sp_client_id" {
  value       = azuread_application.terraform.client_id
  description = "ARM_CLIENT_ID"
  sensitive   = false
}

# Get it from tf state file
output "terraform_sp_secret" {
  value       = azuread_application_password.terraform.value
  description = "ARM_CLIENT_SECRET"
  sensitive   = true
}

output "default_subscription_id" {
  value       = var.default_subscription_id
  description = "ARM_SUBSCRIPTION_ID"
  sensitive   = false
}

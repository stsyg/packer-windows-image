output "packer_artifacts_resource_group" {
  value     = azurerm_resource_group.packer_sig.name
}

output "packer_build_resource_group" {
  value     = azurerm_resource_group.packer_build.name
}

# output "packer_client_id" {
#   value     = azuread_application.this.application_id
#   sensitive = true
# }

# output "packer_client_secret" {
#   value     = azuread_service_principal_password.this.value
#   sensitive = true
# }

# output "packer_subscription_id" {
#   value     = data.azurerm_subscription.this.subscription_id
#   sensitive = true
# }

# output "packer_tenant_id" {
#   value     = data.azurerm_subscription.this.tenant_id
#   sensitive = true
# }
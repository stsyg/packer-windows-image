# Create resource group used to deploy final image
resource "azurerm_resource_group" "packer_artifacts" {
  name     = "packer-artifacts-rg"
  location = canadacentral
}

# Create resource group used during the image build
resource "azurerm_resource_group" "packer_build" {
  name     = "packer-build-rg"
  location = canadacentral
}

# Register applicaiton within Azure Active Directory
resource "azuread_application" "packer" {
  display_name = "packer-sp-app"
}

# Create service principal associated with an application within Azure Active Directory
resource "azuread_service_principal" "packer" {
  application_id = azuread_application.packer.application_id
}

# Create password credential associated with a service principal within Azure Active Directory
resource "azuread_service_principal_password" "packer" {
  service_principal_id = azuread_service_principal.packer.id
}

# Fetch information about current subscription
data "azurerm_subscription" "subscription" {}

# Assign RBAC Reader role to previously created Azure SPN with the scope to the subscription
resource "azurerm_role_assignment" "subscription_reader" {
  scope                = data.azurerm_subscription.subscription.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.packer.id
}

# Assign RBAC Contributor role to previously created Azure SPN with the scope to first RG
resource "azurerm_role_assignment" "packer_build_contributor" {
  scope                = azurerm_resource_group.packer_build.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.packer.id
}

# Assign RBAC Contributor role to previously created Azure SPN  with the scope to second RG
resource "azurerm_role_assignment" "packer_artifacts_contributor" {
  scope                = azurerm_resource_group.packer_artifacts.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.packer.id
}
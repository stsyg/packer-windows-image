# Terraform Cloud configuration
terraform {
        backend "remote" {
            organization = "The38Dev"
            workspaces {
                name = "packer-windows-image"
            }
        }
}

# Create resource group used to deploy final image
resource "azurerm_resource_group" "packer_artifacts" {
  location = var.deploy_location
  name     = var.rg_artifacts
    tags = {
    environment = "Dev"
    app         = "Packer Image Builder"
    provisioner = "Terraform"
  }
}

# Create resource group used during the image build
resource "azurerm_resource_group" "packer_build" {
  location = var.deploy_location
  name     = var.rg_build
    tags = {
    environment = "Dev"
    app         = "Packer Image Builder"
    provisioner = "Terraform"
  }
}

# # Register applicaiton within Azure Active Directory
# resource "azuread_application" "packer" {
#   display_name = "packer-sp-app"
# }

data "azuread_client_config" "current" {}

resource "azuread_application" "packer" {
  display_name = "packer-sp-app"
  owners       = [data.azuread_client_config.current.object_id]
}

# Create service principal associated with an application within Azure Active Directory
# resource "azuread_service_principal" "packer" {
#   application_id = azuread_application.packer.application_id
# }

resource "azuread_service_principal" "packer" {
  application_id               = azuread_application.packer.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
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

# Retrieve details of the GitHub repository using a search query
# https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repositories
data "github_repository" "packer_windows_image" {
  full_name = "stsyg/packer-windows-image"
}

# Create and manage GitHub Actions secrets within your GitHub repositories
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret
resource "github_actions_secret" "packer_client_id" {
  repository      = data.github_repository.packer_windows_image.name
  secret_name     = "PACKER_CLIENT_ID"
  plaintext_value = azuread_application.packer.application_id
}

resource "github_actions_secret" "packer_client_secret" {
  repository      = data.github_repository.packer_windows_image.name
  secret_name     = "PACKER_CLIENT_SECRET"
  plaintext_value = azuread_service_principal_password.packer.value
}

resource "github_actions_secret" "packer_subscription_id" {
  repository      = data.github_repository.packer_windows_image.name
  secret_name     = "PACKER_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_subscription.subscription.subscription_id
}

resource "github_actions_secret" "packer_tenant_id" {
  repository      = data.github_repository.packer_windows_image.name
  secret_name     = "PACKER_TENANT_ID"
  plaintext_value = data.azurerm_subscription.subscription.tenant_id
}

# Export Azure credentials and upload them to GitHub secrets
resource "github_actions_secret" "github_actions_azure_credentials" {
  repository  = data.github_repository.packer_windows_avd.name
  secret_name = "AZURE_CREDENTIALS"

  plaintext_value = jsonencode(
    {
      clientId       = azuread_application.packer.application_id
      clientSecret   = azuread_service_principal_password.packer.value
      subscriptionId = data.azurerm_subscription.subscription.subscription_id
      tenantId       = data.azurerm_subscription.subscription.tenant_id
    }
  )
}
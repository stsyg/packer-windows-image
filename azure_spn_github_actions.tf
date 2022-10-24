###################################################################
# This code will gather information about Azure and GitHub environments
# and create:
# 1. Azure Managed Identity for the specified group
# 2. Create, extract and upload Azure SPN data. This Azure SPN will be used by GitHub Actions
# 3. Upload Azure SPN data to GitHub Actions of current repo 

# Fetch information about the configuration of the AzureRM provider
data "azuread_client_config" "current" {}

# Fetch information about current subscription
data "azurerm_subscription" "this" {}

# Get information about current GitHub Repository
data "git_repository" "this" {
  path = path.root
}

# Use current GitHub repo URL to get org/name and name of the repo
# Offset of 19(25) charecters from URL https://github.com/stsyg/repo_name.git 
locals {
# Get current GitHub repo org/name
  github_full_name = replace(substr(data.git_repository.this.url,19,-1), "/.git/", "")
# Get current GitHub repo name
  github_name = replace(substr(data.git_repository.this.url,25,-1), "/.git/", "")
}

# Create application registration within Azure Active Directory
resource "azuread_application" "this" {
  display_name = "${local.github_name}-sp-app"
  owners       = [data.azuread_client_config.current.object_id]
}

# Create service principal associated with an application within Azure Active Directory
resource "azuread_service_principal" "this" {
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Introducing time rotation 
resource "time_rotating" "this" {
  rotation_days = 7
}

# Create password credential associated with a service principal within Azure Active Directory
resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.id
    rotate_when_changed = {
      rotation = time_rotating.this.id
    }
}

# Assign RBAC Reader role to previously created Azure SPN with the scope to the subscription
resource "azurerm_role_assignment" "subscription_reader" {
  scope                = data.azurerm_subscription.this.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.this.id
}

# Assign RBAC Contributor role to previously created Azure SPN with the scope to first RG
resource "azurerm_role_assignment" "packer_build_contributor" {
  scope                = azurerm_resource_group.packer_build.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.this.id
}

# Assign RBAC Contributor role to previously created Azure SPN  with the scope to second RG
resource "azurerm_role_assignment" "packer_artifacts_contributor" {
  scope                = azurerm_resource_group.packer_artifacts.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.this.id
}

# Retrieve information about a GitHub repository
# tflint-ignore: terraform_unused_declarations
data "github_repository" "this" {
  full_name = local.github_full_name
}

# Retrieve information about a GitHub Actions public key
# tflint-ignore: terraform_unused_declarations
data "github_actions_public_key" "this" {
  repository = local.github_name
}

# Create and manage GitHub Actions secrets within your GitHub repositories
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret
resource "github_actions_secret" "packer_client_id" {
  repository      = local.github_name
  secret_name     = "PACKER_CLIENT_ID"
	# checkov:skip=CKV_SECRET_6: Not an issue
  encrypted_value = azuread_application.this.application_id
}

resource "github_actions_secret" "packer_client_secret" {
  repository      = local.github_name
  secret_name     = "PACKER_CLIENT_SECRET"
	# checkov:skip=CKV_SECRET_6: Not an issue
  encrypted_value = azuread_service_principal_password.this.value
}

resource "github_actions_secret" "packer_subscription_id" {
  repository      = local.github_name
  secret_name     = "PACKER_SUBSCRIPTION_ID"
  # checkov:skip=CKV_SECRET_6: Not an issue
  encrypted_value = data.azurerm_subscription.this.subscription_id
}

resource "github_actions_secret" "packer_tenant_id" {
  repository      = local.github_name
  secret_name     = "PACKER_TENANT_ID"
  # checkov:skip=CKV_SECRET_6: Not an issue
  encrypted_value = data.azurerm_subscription.this.tenant_id
}

# Export Azure credentials and upload them to GitHub secrets
resource "github_actions_secret" "github_actions_azure_credentials" {
  repository  = local.github_name
  secret_name = "AZURE_CREDENTIALS"
  # checkov:skip=CKV_SECRET_6: Not an issue

  encrypted_value = jsonencode(
    {
      clientId       = azuread_application.this.application_id
      clientSecret   = azuread_service_principal_password.this.value
      subscriptionId = data.azurerm_subscription.this.subscription_id
      tenantId       = data.azurerm_subscription.this.tenant_id
    }
  )
}

# Export the names of both resource groups to GitHub secrets
resource "github_actions_secret" "packer_artifacts_resource_group" {
  repository      = local.github_name
  secret_name     = "PACKER_ARTIFACTS_RESOURCE_GROUP"
  # checkov:skip=CKV_SECRET_6: Not an issue
  encrypted_value = azurerm_resource_group.packer_artifacts.name
}

resource "github_actions_secret" "packer_build_resource_group" {
  repository      = local.github_name
  secret_name     = "PACKER_BUILD_RESOURCE_GROUP"
  # checkov:skip=CKV_SECRET_6: Not an issue
  encrypted_value = azurerm_resource_group.packer_build.name
}
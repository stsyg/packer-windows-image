###################################################################
# This code will gather information about Azure environment
# and create:
# 1. Resource Groups for Packer build and artifacts
# 2. Shared Image Gallery (SIG)
# 3. Image definition
# 4. Azure user-assigned managed identity
# 5. Azure role definition
###################################################################

# Generate a random string (consisting of four characters)
resource "random_string" "random" {
  length  = 4
  upper   = false
  special = false
}

# Create resource group used to deploy final image
resource "azurerm_resource_group" "packer_artifacts" {
  location = var.location
  name     = "${var.prefix}-${var.service}-artifacts-rg"
  tags = var.default_tags
}

# Create resource group used during the image build
resource "azurerm_resource_group" "packer_build" {
  location = var.location
  name     = "${var.prefix}-${var.service}-build-rg"
  tags = var.default_tags
}

# Create Azure Compute Gallery (formerly Shared Image Gallery)
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery
resource "azurerm_shared_image_gallery" "this" {
  name                = "${var.prefix}-${var.service}-${random_string.random.id}"
  resource_group_name = azurerm_resource_group.packer_build.name
  location            = azurerm_resource_group.packer_build.location
  description         = "Custom images"
  tags                = var.default_tags
}

# # Create image definition
# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image
# resource "azurerm_shared_image" "this" {
#   description           = "Windows 11 image definition"
#   eula                  = "https://www.microsoft.com/en-us/Useterms/Retail/Windows/11/UseTerms_Retail_Windows_11_English.htm"
#   privacy_statement_uri = "https://privacy.microsoft.com/en-us/privacystatement"
#   release_note_uri      = "https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information"
#   name                  = "Windows11-${random_string.random.id}"
#   gallery_name          = azurerm_shared_image_gallery.this.name
#   resource_group_name   = azurerm_resource_group.packer_build.name
#   location              = azurerm_resource_group.packer_build.location
#   os_type               = "Windows"

#   identifier {
#     publisher = var.image_publisher
#     offer     = var.image_offer
#     sku       = var.image_sku
#   }
#   tags = var.default_tags
# }

# Create an Azure user-assigned managed identity
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
# aibIdentity = Azure Image Builder Identity
resource "azurerm_user_assigned_identity" "aib" {
  name                = "${var.prefix}-${var.service}-identity"
  resource_group_name = azurerm_resource_group.packer_build.name
  location            = azurerm_resource_group.packer_build.location
  tags                = var.default_tags
}

# Create an Azure role definition
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition
resource "azurerm_role_definition" "aibIdentity" {
  name  = "${var.prefix}-${var.service}-identityrole"
  scope       = data.azurerm_subscription.current.id
  description = "Azure Image Builder Image Definition Dev"
  permissions {
    actions = ["Microsoft.Compute/images/write",
      "Microsoft.Compute/images/read",
      "Microsoft.Compute/images/delete",
      "Microsoft.Compute/galleries/read",
      "Microsoft.Compute/galleries/images/read",
      "Microsoft.Compute/galleries/images/versions/read",
      "Microsoft.Compute/galleries/images/versions/write",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/virtualNetworks/subnets/join/action"]

    not_actions = []
  }
  assignable_scopes = [
    # azurerm_resource_group.vmssrg.id, # target RG for VMs created using custom image
    # data.azurerm_resource_group.vmssrg.id,
    azurerm_resource_group.packer_build.id,
    data.azurerm_subscription.current.id, # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}

# Assign previously created role definition to the adintified scope
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "aibIdentityAssignment" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.aibIdentity.role_definition_resource_id
  principal_id = azurerm_user_assigned_identity.aib.principal_id
}
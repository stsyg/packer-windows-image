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


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
variable "deploy_location" {
  type        = string
  default     = "canadacentral"
  description = "The Azure Region in which all resources in this example should be created."
}

variable "rg_artifacts" {
  type        = string
  default     = "packer-artifacts-rg"
  description = "Name of the resource group used to deploy final image"
}

variable "rg_build" {
  type        = string
  default     = "packer-build-rg"
  description = "Name of the resource group used during the image build"
}
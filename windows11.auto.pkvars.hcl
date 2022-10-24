variable "build_resource_group_name" {
  type    = string
#  default = "${env("PACKER_BUILD_RESOURCE_GROUP")}"
  description = "Packer Build Resource Group."
}

// variable "chef_boot" {
//   type    = string
//   default = "custom"
// }

// variable "chef_env" {
//   type    = string
//   default = "nonproduction"
// }

// variable "chef_json" {
//   type        = string
//   description = "(Optional) Specify a custom chef overide JSON to download."
//   default     = https://artifactory.platform.manulife.io/artifactory/chef-local/auth/first-boot-ggy-custom.json
// }

// variable "chef_bootstrap_uri"{
//   type        = string
//   description = "(Required) Manulife Bootstrap script URL to download and trigger chef"
//   default     = https://artifactory.platform.manulife.io/artifactory/chef-local/auth/Chef-BootstrapWin.ps1
// }

// variable "chef_server" {
//   type    = string
//   default = "NA"
// }

variable "client_id" {
  type    = string
#  default = "${env("ARM_CLIENT_ID")}"
  description = "Azure Service Principal App ID."
}

variable "client_secret" {
  type      = string
#  default   = "${env("ARM_CLIENT_SECRET")}"
  sensitive = true
  description = "Azure Service Principal Secret."
}

// variable "file_share" {
//   type    = string
//   default = ""
// }

// variable "file_share_pass" {
//   type      = string
//   default   = ""
//   sensitive = true
// }

// variable "file_share_user" {
//   type      = string
//   default   = ""
// }

variable "image_offer" {
  type    = string
  default = ""
  description = "Windows Image Offer."
}

variable "image_publisher" {
  type    = string
  default = ""
  description = "Windows Image Publisher."
}

variable "image_sku" {
  type    = string
  default = ""
  description = "Windows Image SKU."
}

variable "image_version" {
  type    = string
  default = "latest"
  description = "Windows Image Version."
}

variable "replication_regions" {
  type    = list(string)
  default = ["Canada East"]
  description = "Image replication regions."
}

variable "local_admins" {
  type    = string
  description = "(Optional)Comma seperated string with domain users/groups to be added to local administrator group"
  default = ""
}

variable "managed_image_name"{
  type = string
#  default = "${env("SHARED_IMAGE_NAME")}"
  description = "Image name."
}

variable "managed_image_resource_group_name"{
  type = string
  default = "${env("PACKER_BUILD_RESOURCE_GROUP")}"
  description = "Packer image build resource group."
}

// variable "shared_image_gallery_name" {
//   type    = string
//   default = "${env("SHARED_IMAGE_GALLERY_NAME")}"
// }

// variable "shared_image_gallery_rg" {
//   type    = string
//   default = "${env("SHARED_IMAGE_GALLERY_RG")}"
// }

variable "shared_image_name" {
  type    = string
  default = "${env("SHARED_IMAGE_NAME")}"
}

variable "shared_image_version" {
  type    = string
  default = "${env("SHARED_IMAGE_VERSION")}"
}

variable "subscription_id" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}

variable "tenant_id" {
  type    = string
  default = "${env("ARM_TENANT_ID")}"
}

// variable "private_virtual_network_with_public_ip" {
//   type    = bool
//   default = false
// }

// variable "virtual_network_name" {
//   type    = string
//   default = "${env("VNET_NAME")}"
// }

// variable "virtual_network_resource_group_name" {
//   type    = string
//   default = "${env("VNET_RESOURCE_GROUP")}"
// }

// variable "virtual_network_subnet_name" {
//   type    = string
//   default = "${env("VNET_SUBNET")}"
// }

variable "vm_size" {
  type    = string
  default = "Standard_D8s_v4"
  description = "VM size used to build an image."
}

// variable "user_assigned_managed_identities" {
//   type        = list(string)
//   description = "Specify a List of managed identities resource ID's to assign to the VM at provision time"
//   default     = null
// }

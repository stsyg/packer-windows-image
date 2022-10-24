prefix   = "prj"
service  = "sig"
location = "canadacentral"
# vmss_name                     = "vmss-rg"
# aibIdentity                      = "aibIdentity"
# aibIdentityRole                  = "aibIdentityRole"
# virtual_network_subnet_name      = "Application-01"
# user_assigned_managed_identities = ["https://mfcggy-kv.vault.azure.net/secrets/vmss-password"]
# local_admins                     = "APP-AZ CloudEng-Vendor-RO@MFCGD.com,mistroh@mfcgd.com"
# packer_verify_run                = false

default_tags = {
  environment = "Dev"
  designation = "Packer"
  provisioner = "Terraform"
}

image_details = {
  publisher = "MicrosoftWindowsDesktop"
  offer = "office-365"
  sku = "win11-22h2-avd-m365"
}
# packer-windows-image
Automate building of custom Windows Image

## Assign Azure role to deployment SPN

The following API permissions are required to use this code.

When authenticated with a service principal, this code requires one of the following application roles: Application.ReadWrite.All or Directory.ReadWrite.All

When authenticated with a user principal, this resource requires one of the following directory roles: Application Administrator or Global Administrator. More information can be found here: https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-cli

The script below is an example 
```
az role assignment create --assignee "{Azure SPN object ID}" \
--role "Application Administrator" \
--subscription "{subscriptionNameOrId}"
```

## GitHub Action Secrets

Create a Personal Access Token with write permissions to the repo. More information can be found here: https://docs.github.com/en/rest/actions/secrets#get-a-repository-public-key

Set environment variables in Terraform and specify following:
GITHUB_TOKEN=<Personal Access Token with write permissions>
GITHUB_OWNER=<owner_name>

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~>2.29.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.24.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | ~>0.1.3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~>5.5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.4.3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~>0.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.29.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.24.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.1.3 |
| <a name="provider_github"></a> [github](#provider\_github) | 5.5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_password) | resource |
| [azurerm_resource_group.packer_artifacts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.packer_build](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.packer_artifacts_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.packer_build_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.subscription_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [github_actions_secret.github_actions_azure_credentials](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.packer_artifacts_resource_group](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.packer_build_resource_group](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.packer_client_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.packer_client_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.packer_subscription_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.packer_tenant_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_rotating.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [git_repository.this](https://registry.terraform.io/providers/innovationnorway/git/latest/docs/data-sources/repository) | data source |
| [github_actions_public_key.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/actions_public_key) | data source |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifacts_resource_group"></a> [artifacts\_resource\_group](#input\_artifacts\_resource\_group) | Packer Artifacts Resource Group. | `string` | n/a | yes |
| <a name="input_build_resource_group"></a> [build\_resource\_group](#input\_build\_resource\_group) | Packer Build Resource Group. | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Azure Service Principal App ID. | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Azure Service Principal Secret. | `string` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to add to deployed resources | `map(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region in which all resources in this example should be created. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix used in Azure resources naming convention | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Service name used in Azure resources naming convention | `string` | n/a | yes |
| <a name="input_source_image_offer"></a> [source\_image\_offer](#input\_source\_image\_offer) | Windows Image Offer. | `string` | n/a | yes |
| <a name="input_source_image_publisher"></a> [source\_image\_publisher](#input\_source\_image\_publisher) | Windows Image Publisher. | `string` | n/a | yes |
| <a name="input_source_image_sku"></a> [source\_image\_sku](#input\_source\_image\_sku) | Windows Image SKU. | `string` | n/a | yes |
| <a name="input_source_image_version"></a> [source\_image\_version](#input\_source\_image\_version) | Windows Image Version. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription ID. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure Tenant ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_packer_artifacts_resource_group"></a> [packer\_artifacts\_resource\_group](#output\_packer\_artifacts\_resource\_group) | n/a |
| <a name="output_packer_build_resource_group"></a> [packer\_build\_resource\_group](#output\_packer\_build\_resource\_group) | n/a |
| <a name="output_packer_client_id"></a> [packer\_client\_id](#output\_packer\_client\_id) | n/a |
| <a name="output_packer_client_secret"></a> [packer\_client\_secret](#output\_packer\_client\_secret) | n/a |
| <a name="output_packer_subscription_id"></a> [packer\_subscription\_id](#output\_packer\_subscription\_id) | n/a |
| <a name="output_packer_tenant_id"></a> [packer\_tenant\_id](#output\_packer\_tenant\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

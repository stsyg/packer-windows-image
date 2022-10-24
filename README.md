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
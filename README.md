# packer-windows-image
Automate building of custom Windows Image

## Assign Azure role to deployment SPN

The following API permissions are required in order to use this code.

When authenticated with a service principal, this code requires one of the following application roles: Application.ReadWrite.All or Directory.ReadWrite.All

When authenticated with a user principal, this resource requires one of the following directory roles: Application Administrator or Global Administrator. 

[The more informaiton can be found here.](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-cli) 

The script below is an example 
```
az role assignment create --assignee "{Azure SPN object ID}" \
--role "Application Administrator" \
--subscription "{subscriptionNameOrId}"
```
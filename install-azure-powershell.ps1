# See https://docs.microsoft.com/en-us/powershell/azure/install-az-ps-msi?view=azps-7.3.2#install-or-update-on-windows-using-the-msi-package

$ErrorActionPreference = "Stop"

$downloadUrl = "https://github.com/Azure/azure-powershell/releases/download/v8.0.0-May2022/Az-Cmdlets-8.0.0.35824-x64.msi"
$outFile = "D:\az_pwsh.msi" # temporary disk

Write-Host "Downloading $downloadUrl ..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $downloadUrl -OutFile $outFile

Write-Host "Installing ..."
Start-Process "msiexec.exe" -Wait -ArgumentList "/package $outFile"

Write-Host "Done."
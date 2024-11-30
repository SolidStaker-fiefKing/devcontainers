#!/bin/bash

# Debug
#echo "PostCreateCommand Debug: SHELL=$SHELL PATH=$PATH USER=$USER" > /tmp/debug.log

# Register and Install Nuget
#sudo /usr/bin/pwsh -Command "Register-PackageSource -Name nuget.org -ProviderName NuGet -Location 'https://api.nuget.org/v3/index.json' -Trusted" >> /tmp/debug.log 2>&1
#sudo /usr/bin/pwsh -Command "Get-PackageProvider | where name -eq 'nuget' | Install-PackageProvider -Force" >> /tmp/debug.log 2>&1

# Install all major powershell modules for Entra & 365 Services
#sudo /usr/bin/pwsh -Command "Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers" >> /tmp/debug.log 2>&1
#sudo /usr/bin/pwsh -Command "Install-Module -Name Microsoft.Graph -Force -AllowClobber -Scope AllUsers" >> /tmp/debug.log 2>&1
#sudo /usr/bin/pwsh -Command "Install-Module -Name PnP.PowerShell -Force -AllowClobber -Scope AllUsers" >> /tmp/debug.log 2>&1
#sudo /usr/bin/pwsh -Command "Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber -Scope AllUsers" >> /tmp/debug.log 2>&1
#sudo /usr/bin/pwsh -Command "Install-Module -Name AzureAD -Force -AllowClobber -Scope AllUsers" >> /tmp/debug.log 2>&1
#sudo /usr/bin/pwsh -Command "Install-Module -Name Az.Security -Force -AllowClobber -Scope AllUsers" >> /tmp/debug.log 2>&1
#sudo /usr/bin/pwsh -Command "Install-Module -Name MicrosoftTeams -Force -AllowClobber -Scope AllUsers" >> /tmp/debug.log 2>&1

# Steps to Create and Use a PowerShell Repository on SMB Share

## Step 1: Set Up the SMB Share
1. Create a shared folder on the server (e.g., `\\server\PowerShellRepo`).
2. Ensure read/write permissions for users.

## Step 2: Create the SMB Repository
1. Install required modules:
   ```powershell
   Install-Module -Name PowerShellGet -Force
   Install-PackageProvider -Name NuGet -Force
```

Register the SMB repository:

Register-PSRepository -Name "MySMBRepo" -SourceLocation "\\server\PowerShellRepo" -InstallationPolicy Trusted

Step 3: Publish the Module to the SMB Repository
Create or update the module manifest (if needed):

New-ModuleManifest -Path "PSDemoEmployee.psd1" -RootModule "PSDemoEmployee.psm1" -Author "Your Name" -CompanyName "Your Company"

Publish the module to the repository:

Publish-Module -Name PSDemoEmployee -Repository MySMBRepo -NuGetApiKey 'AnyString'
Step 4: Install the Module from the SMB Repository
Register the repository on client machines:


Register-PSRepository -Name "MySMBRepo" -SourceLocation "\\server\PowerShellRepo" -InstallationPolicy Trusted

Install the module:

Install-Module -Name PSDemoEmployee -Repository MySMBRepo
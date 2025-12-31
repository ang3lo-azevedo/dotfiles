Write-Host "Starting Windows Self-Provisioning Bootstrap..." -ForegroundColor Cyan

# Elevate Privilege Level
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Winget (If not present in LTSC)
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Winget Package Manager..."
    $AppInstallerUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    Invoke-WebRequest -Uri $AppInstallerUrl -OutFile "$env:TEMP\winget.msixbundle"
    Add-AppxPackage "$env:TEMP\winget.msixbundle"
}

# Essential Drivers, Frameworks, and Tools for Ansible
Write-Host "Installing Core Runtimes and Tools..."
$apps = @(
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.DotNet.DesktopRuntime.8",
    "Git.Git",
    "Python.Python.3.11" # Install Python for Ansible
)
foreach ($app in $apps) { winget install --id $app --silent --accept-package-agreements --accept-source-agreements }

# Add Python scripts to PATH
$env:Path += ";C:\Program Files\Python311\Scripts\"
[System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Machine)

# Install Ansible using Pip
Write-Host "Installing Ansible..."
pip install ansible pywinrm

# Install required Ansible collections
Write-Host "Installing Ansible collections..."
ansible-galaxy collection install community.windows
ansible-galaxy collection install ansible.windows

# Clone the dotfiles repository
Write-Host "Cloning configuration repository from GitHub..."
git clone https://github.com/ang3lo-azevedo/dotfiles.git C:\dotfiles

# Run the local Ansible playbook
Write-Host "Running local Ansible playbook for self-configuration..."
$playbookPath = "C:\dotfiles\hosts\pc-angelo-win\playbook.yml"
$inventoryPath = "C:\dotfiles\hosts\pc-angelo-win\inventory.ini"
ansible-playbook $playbookPath -i $inventoryPath

Write-Host "Self-provisioning complete." -ForegroundColor Green
